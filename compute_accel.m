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

%OUTPUTS
%ax: x acceleration of the box
%ay: y acceleration of the box
%atheta: angular acceleration of the box
function [ax, ay, atheta] = compute_accel(x, y, theta, box_params)
    m = box_params.m;
    I = box_params.I;
    g = box_params.g;
    k_list = box_params.k_list;
    l0_list = box_params.l0_list;
    
    P_box = box_params.P_box;        % points on box (box frame)
    P_world_fixed = box_params.P_world;  % fixed environment anchors
    
    % transform box points into world frame
    P_box_world = compute_rbt(x, y, theta, P_box);

    num_springs = length(k_list);

    Fx_total = 0;
    Fy_total = 0;
    torque_total = 0;

    for spring = 1:num_springs
        Pw = P_world_fixed(:, spring);   % fixed world anchor
        Pb = P_box_world(:, spring);     % box point in world frame
        
        d = Pb - Pw; 
        l = norm(d);  
        e_s = d / l;                     % unit vector from Pw → Pb
        
        % spring force magnitude
        F_i = -k_list(spring) * (l - l0_list(spring)) * e_s;

        Fx_total = Fx_total + F_i(1);
        Fy_total = Fy_total + F_i(2);

        % torque about COM
        r_i = Pb - [x; y];
        torque_i = r_i(1)*F_i(2) - r_i(2)*F_i(1);
        torque_total = torque_total + torque_i;
    end

    % add gravity
    Fy_total = Fy_total - m * g;

    % linear and angular acceleration
    ax = Fx_total / m;
    ay = Fy_total / m;
    atheta = torque_total / I;
end
