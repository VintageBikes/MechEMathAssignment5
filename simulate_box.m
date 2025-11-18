function [tlist, Vlist] = simulate_box(V0, tspan, box_params)
    %load the system parameters into the rate function
    %via an anonymous function
    my_rate_func = @(t_in,V_in) box_rate_func(t_in,V_in,box_params);
    
    %run the integration
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0);
end

