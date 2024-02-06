function simplex_test(iteration_count, debug)
% simplex_test.m Compares simplex.m and linprog functions
% Inputs:
%   iteration_count - number of iterations to run
%   debug - flag used to enable/disable tableau printing

    if nargin < 2
        debug = false;
    end

    found_valid_counter = 0;
    found_invalid_counter = 0;
    not_found_valid_counter = 0;
    not_found_invalid_counter = 0;
    precision = 10;
    rng(1);
    
    for i = 1:iteration_count
        fprintf('Interation: %s\n', num2str(i));
        [A, b, c, g] = generator();
                
        [x_linprog, ~, ~, ~, lambda] = linprog(-c, A, [b;g], [], [], [], [], ...
            optimoptions('linprog','Display','none'));
        linprog_x_val = get_value_with_precision(x_linprog, c, precision);

        [~, n] = size(A');
        y_linprog = linprog([b;g], [], [], A', c, zeros(1, n), [], ...
            optimoptions('linprog','Display','none'));
        linprog_y_val = get_value_with_precision(y_linprog, [b;g], precision);
        
        [ROx, ROy, exitflag] = simplex(c, A, b, g, debug);
        simplex_x_val = get_value_with_precision(ROx, c, precision);
        simplex_y_val = get_value_with_precision(ROy, [b;g], precision);

        if isempty(x_linprog)
            if exitflag == 0
                not_found_valid_counter = not_found_valid_counter + 1;
            else
                not_found_invalid_counter = not_found_invalid_counter + 1;
            end
        else
            % disp('lower:')
            % disp(lambda.lower)
            % disp('upper:')
            % disp(lambda.upper)
            % disp('eqlin:')
            % disp(lambda.eqlin)
            % disp('ineqlin:')
            % disp(lambda.ineqlin)
           
            if isequal(linprog_x_val, simplex_x_val) && isequal(linprog_y_val, simplex_y_val)
                found_valid_counter = found_valid_counter + 1;
            else
                found_invalid_counter = found_invalid_counter + 1;
            end
        end
    end

    fprintf('Solution accuracy when found: %s\n', ...
        num2str(found_valid_counter / (found_valid_counter + found_invalid_counter)));
    fprintf('Solution accuracy when not found: %s\n', ...
        num2str(not_found_valid_counter / (not_found_valid_counter + not_found_invalid_counter)));
    fprintf('Number of found: %s\n', ...
        num2str(found_valid_counter + found_invalid_counter));
    fprintf('Number of not found: %s\n', ...
        num2str(not_found_valid_counter + not_found_invalid_counter));
end