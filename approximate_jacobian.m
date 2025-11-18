%Implementation of finite difference approximation
%for Jacobian of multidimensional function
%INPUTS:
%fun: the mathetmatical function we want to differentiate
%x: the input value of fun that we want to compute the derivative at
%OUTPUTS:
%J: approximation of Jacobian of fun at x

function J = approximate_jacobian(fun,x)
    f0 = fun(x); % Vector of function with x inputs
    J = zeros(length(f0), length(x)); %makes a matrix of zeros with the length of the vector f0 by the length x

    e_n = zeros(length(x),1); % makes a column vector size x by 1 (so 3 by 1)
    
    delta_x = 1e-6; %Step size

    for n = 1:length(x) % Loop for each value of vector x
        e_n(n) = 1; % Makes standard basis vector

        % The following code is derived from the numerical diffrentiation
        % function for the approximate derivative where: 

        f_left = fun(x - e_n*delta_x); % is the left part of the numerator of the function
        f_right = fun(x + e_n*delta_x); % is the right part of the numeration of the function
        J(:,n) = (f_right - f_left)/(2*delta_x); % the function itself for deriving the approximate derivative

        e_n(n) = 0; % Resetting to 0 so that the vector does not become all ones
       
    end
end
