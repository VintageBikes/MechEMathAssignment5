
function simulate_box()
    close all;
    %define system parameters
    box_params = struct();
    box_params.m = 1; %kg
    box_params.I = 1; %kg m^2
    box_params.g = 0; %m/s^2
    box_params.k_list = [50,50,50,50];
    box_params.l0_list = [2,2, 2,2];
    box_params.P_world = [2, -2, -2, 2;2, 2, -2, -2];
    box_params.P_box = [1.7, -1.7, -1.7, 1.7;1.7, 1.7, -1.7, -1.7];
    %load the system parameters into the rate function
    %via an anonymous function
    my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
    x0 = -0.1;
    y0 = -0.11;
    theta0 = 0.01;
    vx0 = 0;
    vy0 = 0;
    vtheta0 = 0;
    V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
    tspan = [0 10];
    
    %run the integration
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0)

    plot(tlist, Vlist(:, 1), 'r')
    hold on;
    plot(tlist, Vlist(:, 2), 'b')
    plot(tlist, Vlist(:, 3), 'k')
    length(tlist)

    figure
    %Sim
    figure
    hold on
    axis equal
    axis([-5 5 -5 5])   % adjust to your scene
    P_box = box_params.P_box; % 2x4
    
    % initialize plot with NaNs
    square_plot = plot(NaN, NaN, 'k-', 'LineWidth', 2);
    
    for t = 1:length(tlist)
        x = Vlist(t,1); 
        y = Vlist(t,2);
        theta = Vlist(t,3);
    
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        P_world = R * P_box + [x; y]; 
        P_plot = [P_world, P_world(:,1)];
    
        set(square_plot,'XData',P_plot(1,:),'YData',P_plot(2,:));
        drawnow
    end

end

