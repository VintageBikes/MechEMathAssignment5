close all;
clc;

%define system parameters
% box_params = struct();
% box_params.m = 0.1; %kg
% box_params.I = 1; %kg m^2
% box_params.g = 9.81; %m/s^2
% box_params.k_list = [50, 50, 50, 50];
% box_params.l0_list = [1, 1, 1, 1];
% box_params.P_world = [2, -2, -2, 2; 2, 2, -2, -2];
% box_params.P_box = [1, -1, -1, 1; 1, 1, -1, -1];
box_params = struct();
box_params.m = 1; %kg
box_params.I = 1; %kg m^2
box_params.g = 9.8; %m/s^2
box_params.k_list = [50, 20, 50, 20];
box_params.l0_list = [2, 2, 1, 1];
box_params.P_world = [2, -2, -2, 2; 2, 2, -2, -2];
box_params.P_box = [.7, -.7, -.7, .7; .7, .7, -.7, -.7];

% find V_eq
rate_func = @(V_in) box_rate_func(0,V_in,box_params);
[V_eq, exit_flag] = multi_newton_solver(rate_func, [0; 0; 0; 0; 0; 0], struct())

% starting values
x0 = -0.8;
y0 = -0.11;
theta0 = 0.5;
vx0 = 0;
vy0 = 0;
vtheta0 = 0;
V0 = [x0;y0;theta0;vx0;vy0;vtheta0];

% tspan
tspan = [0 10];

% simulate box
[tlist, Vlist] = simulate_box(V_eq, tspan, box_params);

% positions over time
figure();
plot(tlist, Vlist(:, 1), 'r')
hold on;
plot(tlist, Vlist(:, 2), 'b')
plot(tlist, Vlist(:, 3), 'k')
length(tlist)

% box animation
box_plotting(Vlist, box_params.P_world, box_params.P_box)


linear_rate = @(t_in,V_in) approximate_jacobian*(V_in-V_eq);



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