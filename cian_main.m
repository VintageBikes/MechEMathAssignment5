close all;
clc;

x = 5;
y = 5;
theta = pi/6;
Plist_box = [1, -1, -1, 1; 1, 1, -1, -1];


Plist_world = compute_rbt(x,y,theta,Plist_box);

plot(Plist_world(1,:), Plist_world(2,:))

k = 1;
l0 = 1;
PA = [0,0];
PB = [0,2];

grid on
axis equal
