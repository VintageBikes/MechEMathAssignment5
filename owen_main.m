close all;
clc;


%define system parameters
box_params = struct();
box_params.m = .1; %kg
box_params.I = 1; %kg m^2
box_params.g = 9.81; %m/s^2
box_params.k_list = [50,50,50,50];
box_params.l0_list = [1,1, 1,1];
box_params.P_world = [2, -2, -2, 2;2, 2, -2, -2];
box_params.P_box = [1, -1, -1, 1;1, 1, -1, -1];

[tlist, Vlist] = simulate_box(box_params);

figure();
plot(tlist, Vlist(:, 1), 'r')
hold on;
plot(tlist, Vlist(:, 2), 'b')
plot(tlist, Vlist(:, 3), 'k')
length(tlist)

box_plotting(Vlist, box_params.P_world, box_params.P_box)

solver_params= struct(); % makes structure for parameter values
solver_params.dxmin = 1e-10; % min step size
solver_params.ftol = 1e-10 ; %tolerence on function value
solver_params.dxmax  = 1e8; % max step size
solver_params.max_iter = 200 ; % max # of iterations
solver_params.approx = 1; % 1 = use approximate jacobian, 0 = use numerical jacobian

my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
eq = multivarate_newton(@box_rate_func, [0,0,0], )

% spring_plotting_example()
