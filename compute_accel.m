%Computes the linear and angular acceleration of the box
%given its current position and orientation
%INPUTS:
%x: current x position of the box
%y: current y position of the box
%theta: current orientation of the box
%box_params: a struct containing the parameters that describe the system
%Fields:
%box_params.m: mass of the box
%box_params.I: moment of inertia w/respect to centroid
%box_params.g: acceleration due to gravity
%box_params.k_list: list of spring stiffnesses
%box_params.l0_list: list of spring natural lengths
%box_params.P_world: 2 x n list of static mounting
%   points for the spring (in the world frame)
%box_params.P_box: 2 x n list of mounting points
%    for the spring (in the box frame)
%
%OUTPUTS
%ax: x acceleration of the box
%ay: y acceleration of the box
%atheta: angular acceleration of the box
function [ax,ay,atheta] = compute_accel(x,y,theta,box_params)
    m = box_params.m;
    I = box_params.I;
    g = box_params.g;
    k_list = box_params.k_list;
    l0_list = box_params.l0_list;
    P_world = box_params.P_world;
    P_box = box_params.P_box
    num_springs = length(k_list);
    a_linear = [0; -g];
    atheta = 0;

    %initialize totals
    Fx_total = 0;
    Fy_total = 0;
    torque_total = 0;

    Plist_world = compute_rbt(x,y,theta,P_box)

    for spring = 1:num_springs
        Pw = P_world(:,spring); %fixed point in environment
        Pb = Plist_world(:,spring); %fixed point on box
        l = norm(Pb-Pw); %current spring length
        e_s = (Pb-Pw)/1; %unit vector from Pw to Pb
        F_i = -k_list(num_springs) * (l - l0_list(num_springs)) * e_s;
        Fx_total = Fx_total + F_i(1); %add the sum of all forces acting in the x direction
        Fy_total = Fy_total + F_i(2); %add the sum of all forces acting in the y direction

        r_i = Pb - [x; y]; %position vector from centroid
        torque_i = r_i(1)*F_i(2) - r_i(2)*F_i(1); %2d cross product
        torque_total = torque_total + torque_i; %add sum of all torque
    end

    Fy_total = Fy_total - m * g; %add gravity

    %Compute acceleration
    ax = Fx_total/m;
    ay = Fy_total/m;
    atheta = torque_total/I;
end