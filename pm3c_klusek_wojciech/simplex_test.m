function simplex_test(iteration_count, debug)
% simplex_test.m Compares simplex.m and linprog functions
% Inputs:
%   iteration_count - number of iterations to run
%   debug - flag used to enable/disable tableau printing

    if nargin < 2
        debug = false;
    end

    valid_counter = 0;
    invalid_counter = 0;
    unique_counter = 0;
    nan_counter_simplex = 0;
    precision = 10;
    rng(1);
    iteration_sum = 0;
    
    for i = 1:iteration_count
        fprintf('Interation: %s\n', num2str(i));
        [A, b, c] = generator();
        
        lb = [-Inf(1, 5) zeros(1, 5)];
        ub = [zeros(1, 5) Inf(1, 5)];
        
        x_linprog = linprog(-c, [], [], A, b, lb, ub, ...
            optimoptions('linprog','Display','none'));
        linprog_val = get_value_with_precision(x_linprog, c, precision);
        

        [x_simplex, is_unique, iter] = simplex(A, b, c, debug);
        simplex_val = get_value_with_precision(x_simplex, c, precision);
        iteration_sum = iteration_sum + iter;

        if isempty(x_simplex)
            nan_counter_simplex = nan_counter_simplex + 1;
        end

        if is_unique == true
            unique_counter = unique_counter + 1;
        end

        if (isnan(linprog_val) && isnan(simplex_val)) || ...
                (isequal(linprog_val, simplex_val))
            valid_counter = valid_counter + 1;
        else

            invalid_counter = invalid_counter + 1;
        end
    end

    fprintf('Solution accuracy: %s\n', ...
        num2str(valid_counter / iteration_count));
    fprintf('Average iteration count: %s\n', ...
        num2str(iteration_sum / iteration_count));
    fprintf('Number of unique solutions: %s\n', ...
        num2str(unique_counter));
    fprintf('Number of nans: %s\n', ...
        num2str(nan_counter_simplex));
end

