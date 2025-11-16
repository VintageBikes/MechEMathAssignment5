box_params.m = 1;
box_params.I = 1;
box_params.g = 9.81;
box_params.k_list = [100];
box_params.l0_list = [1];
box_params.P_world = [0;2];
box_params.P_box = [1, -1, -1, 1; 1, 1, -1, -1];;

[ax,ay,atheta] = compute_accel(0,0,0,box_params)
