close all;
clc;

x = 5;
y = 5;
theta = pi/6;
Plist_box = [1, -1, -1, 1; 1, 1, -1, -1];


Plist_world = compute_rbt(x,y,theta,Plist_box)

plot(Plist_world(1,:), Plist_world(2,:))
grid on
axis equal
