close all;
clc;

%define system parameters
box_params = struct();
box_params.m = 0.1; %kg
box_params.I = 1; %kg m^2
box_params.g = 9.81; %m/s^2
box_params.k_list = [50, 46, 63, 50];
box_params.l0_list = [1, 1, 2, 1];
box_params.P_world = [2, -2, -2, 2; 2, 2, -2, -2];
box_params.P_box = [1, -1, -1, 1; 1, 1, -1, -1];

% optional starting positions
x0 = -0.8;
y0 = -0.11;
theta0 = 0.5;
vx0 = 0;
vy0 = 0;
vtheta0 = 0;
V0 = [x0;y0;theta0;vx0;vy0;vtheta0];

% find V_eq
rate_func = @(V_in) box_rate_func(0,V_in,box_params);
[V_eq, exit_flag] = multi_newton_solver(rate_func, [0; 0; 0; 0; 0; 0], struct());

% tspan
tspan = [0 10];

% simulate box at equilibrium
[tlist, Vlist] = simulate_box(V_eq, tspan, box_params);

% positions over time
figure();
plot(tlist, Vlist(:, 1), 'r')
hold on;
plot(tlist, Vlist(:, 2), 'b')
plot(tlist, Vlist(:, 3), 'k')
legend('x position', 'y position', 'angle (radians)')

% box animation
%box_plotting(Vlist, box_params.P_world, box_params.P_box)

%% Next section
% create rate functions
J_approx = approximate_jacobian(rate_func, V_eq);
rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
linear_rate = @(t_in, V_in) J_approx*(V_in-V_eq);

%small number used to scale initial perturbation
epsilons = [0.02, 0.05, 0.1];
for i = 1:length(epsilons)
    Vx = V_eq + epsilons(i)*V0;
    
    %run the integration of nonlinear system
    [tlist_nonlinear, Vlist_nonlinear] = ode45(rate_func,tspan,Vx);
    
    %run the integration of linear system
    [tlist_linear, Vlist_linear] = ode45(linear_rate,tspan,Vx);
    
    % positions over time
    figure();
    
    % x(t)
    subplot(3,1,1)
    plot(tlist_nonlinear, Vlist_nonlinear(:, 1), 'LineWidth', 1.5);
    hold on
    plot(tlist_linear, Vlist_linear(:, 1), '--', 'LineWidth', 1.5);
    xlabel('Time (s)')
    ylabel('x (m)')
    title(['x(t) Comparison, \epsilon=' num2str(epsilons(i))]);
    legend('Nonlinear','Linear')
    
    % y(t)
    subplot(3,1,2)
    plot(tlist_nonlinear, Vlist_nonlinear(:, 2), 'LineWidth', 1.5); hold on
    plot(tlist_linear, Vlist_linear(:, 2), '--', 'LineWidth', 1.5);
    xlabel('Time (s)')
    ylabel('y (m)')
    title(['y(t) Comparison, \epsilon=' num2str(epsilons(i))]);
    legend('Nonlinear','Linear')
    
    % theta(t)
    subplot(3,1,3)
    plot(tlist_nonlinear, Vlist_nonlinear(:, 3), 'LineWidth', 1.5); hold on
    plot(tlist_linear, Vlist_linear(:, 3), '--', 'LineWidth', 1.5);
    xlabel('Time (s)')
    ylabel('\theta (rad)')
    title(['\theta(t) Comparison, \epsilon=' num2str(epsilons(i))]);
    legend('Nonlinear','Linear')
end


%% MODES 
%[0 I; -Q 0]
Q = -J_approx(4:6,1:3);
[U_modes, Lambda] = eig(Q);
wn = sqrt(diag(Lambda))      % resonant freaks

% sort by frequency
[wn, idx] = sort(wn);
U_modes = U_modes(:,idx);


eps_mode = 0.01;
t_mode = t_nonlin_small; %reuse reduce recycle

figure;
for mode_idx = 1:3
    U0 = U_modes(:,mode_idx);
    omega_n = wn(mode_idx);

    V0_mode = V_eq + eps_mode*[U0;0;0;0];
    [t_nl, V_nl] = ode45(@(t,V) box_rate_func(t,V,box_params),tspan, V0_mode);

    dx_modal = eps_mode * U0(1) * cos(omega_n * t_nl);
    dy_modal = eps_mode * U0(2) * cos(omega_n * t_nl);
    dth_modal= eps_mode * U0(3) * cos(omega_n * t_nl);

    dx_nl = V_nl(:,1) - V_eq(1);
    dy_nl = V_nl(:,2) - V_eq(2);
    dth_nl= V_nl(:,3) - V_eq(3);

    subplot(3,1,mode_idx); hold on; grid on;
    plot(t_nl, dx_nl, 'k-', 'displayname','nonlinear \Deltax');
    plot(t_nl, dx_modal, 'r--', 'displayname','modal \Deltax');
    plot(t_nl, dy_nl, 'g-', 'displayname','nonlinear \Deltay');
    plot(t_nl, dy_modal, 'c--', 'displayname','modal \Deltay');
    plot(t_nl, dth_nl, 'b-', 'displayname','nonlinear \Delta\theta');
    plot(t_nl, dth_modal,'m--', 'displayname','modal \Delta\theta');
    xlabel('t');
    ylabel('displacement');
    title(sprintf('w = %.3f rad/s', omega_n));
end


% % Iconic starting parameters
% box_params = struct();
% box_params.m = 1; %kg
% box_params.I = 1; %kg m^2
% box_params.g = 9.8; %m/s^2
% box_params.k_list = [50, 20, 50, 20];
% box_params.l0_list = [5, 5, 5, 5];
% box_params.P_world = [2, -2, -2, 2; 2, 2, -2, -2];
% box_params.P_box = [.7, -.7, -.7, .7; .7, .7, -.7, -.7];
% 
% x0 = -0.8;
% y0 = -0.11;
% theta0 = 0.5;
% vx0 = 0;
% vy0 = 0;
% vtheta0 = 0;
% V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
% tspan = [0 10];