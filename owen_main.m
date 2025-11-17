box_params.m = 1;
box_params.I = 1;
box_params.g = 9.81;

%BL, BR, 
box_params.k_list = [1,1,1,1];
box_params.l0_list = [1,1,1,1];
box_params.P_world = [2, -2, -2, 2;2, 2, -2, -2];
box_params.P_box = [1, -1, -1, 1;1, 1, -1, -1];

[ax,ay,atheta] = compute_accel(0,0,0,box_params);
