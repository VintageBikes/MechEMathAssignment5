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
    P_box = box_params.P_box;
    num_springs = length(k_list);
    a_linear = [0; -g];
    atheta = 0;

    for spring = 1:num_springs
        F = compute_spring_force(k_list(spring), l0_list(spring), P_box(:,spring), P_world(:,spring)); 
        % TODO do something with rotation to transform F into a vector
        a_linear = a_linear + F/m;
        % TODO do the same for angular acceleration
        % atheta = atheta + F/I * other stuff
    end
end