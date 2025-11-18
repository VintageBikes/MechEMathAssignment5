function X_root  = multivarate_newton(fun,x,solver_params)

    dxmin = solver_params.dxmin; % min step size from specified params from solver_params
    ftol = solver_params.ftol; %tolerence on function value from specified params from solver_params
    dxmax = solver_params.dxmax; % max step size from specified params from solver_params
    max_iter = solver_params.max_iter; % max # of iterations from specified params from solver_params
    approx = solver_params.approx; % 1 = use approximate jacobian, 0 = use numerical jacobian from specified params from solver_params
 
    if approx % if approx is 1, will use approximate jacobian, 0 will use numerical jacobian
        fval = fun(x); % function value at guess x 
        J = approximate_jacobian(fun,x); %uses approx jacobian
    else 
        [fval, J] = fun(x); % uses numerical jacobian
    end 
    delta_x = -J\fval ; % finds step using jacobian

    count = 0; % starts keeping count of iterations

    while count < max_iter && norm(delta_x) > dxmin && norm(fval) > ftol && norm(delta_x) < dxmax % makes sure the max amount of iterations is not passed
% and the guess is greater than the min guess size and value of our guess is greater then out tolerance, and the guess is less than the maximum guess... 
        count = count + 1; % adds to iteration count

        if approx % if approx is 1, will use approximate jacobian, 0 will use numerical jacobian
            fval = fun(x); % function value at guess x 
            J = approximate_jacobian(fun, x); %uses approx jacobian
        else
            [fval, J] = fun(x); % uses numerical jacobian
        end
        delta_x = -J\fval; % finds step using jacobian
        x = x + delta_x; % updates root
    end

    X_root = x; %calls root X_root

end
