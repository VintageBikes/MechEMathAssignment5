function [tlist, Vlist] = simulate_box(box_params)
    %load the system parameters into the rate function
    %via an anonymous function
    my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
    x0 = 0;
    y0 = 0;
    theta0 = 0.75;
    vx0 = 0;
    vy0 = 0;
    vtheta0 = 0;
    V0 = [x0;y0;theta0;vx0;vy0;vtheta0];
    tspan = [0 10];
    
    %run the integration
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0);
end

