%Computes the rigid body transformation that maps a set
%of points in the box-frame to their corresponding
%world-frame coordinates
%INPUTS:
%x: the x position of the centroid of the box
%y: the y position of the centroid of the box
%theta: the orientation of the box
%Plist_box: a 2 x n matrix of points in the box frame
%OUTPUTS:
%Plist_world: a 2 x n matrix of points describing
%the world-frame coordinates of the points in Plist_box
function Plist_world = compute_rbt(x,y,theta,Plist_box)
    %x positions = centroid + Pboxxcos(theta) + Pboxysin(theta)
    
    Plist_world = zeros(size(Plist_box));
    for i = 1:length(Plist_box)
        Plist_world(1, i) = x + Plist_box(1, i)*cos(theta) - Plist_box(2,i)*sin(theta);
        Plist_world(2, i) = y + Plist_box(1, i)*sin(theta) + Plist_box(2,i)*cos(theta);
    end
        
end