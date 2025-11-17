close all;
clc;


%define system parameters
box_params = struct();
box_params.m = 1; %kg
box_params.I = 1; %kg m^2
box_params.g = 0; %m/s^2
box_params.k_list = [50,50,50,50];
box_params.l0_list = [2,2, 2,2];
box_params.P_world = [2, -2, -2, 2;2, 2, -2, -2];
box_params.P_box = [1.7, -1.7, -1.7, 1.7;1.7, 1.7, -1.7, -1.7];

[tlist, Vlist] = simulate_box(box_params);

figure();
plot(tlist, Vlist(:, 1), 'r')
hold on;
plot(tlist, Vlist(:, 2), 'b')
plot(tlist, Vlist(:, 3), 'k')
length(tlist)

box_plotting(Vlist, box_params.P_world, box_params.P_box)

% spring_plotting_example()
