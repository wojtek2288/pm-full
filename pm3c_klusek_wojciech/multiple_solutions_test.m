function multiple_solutions_test(iteration_count)
% multiple_solutions_test.m Compares multiple optimal optimization problem
% solutions
% Inputs:
%   iteration_count - number of iterations to run

    precision = 10;
    non_unique_solutions_count = 0;
    equal_unique_solutions = 0;
    rng(1);

    for i = 1:iteration_count
        fprintf('Interation: %s\n', num2str(i));
        [A, b, c] = generator();
        x_1 = simplex(A, b, c, false, false);
        x_2 = simplex(A, b, c, false, true);

        lb = [-Inf(1, 5) zeros(1, 5)];
        ub = [zeros(1, 5) Inf(1, 5)];
        
        x_linprog = linprog(-c, [], [], A, b, lb, ub, ...
            optimoptions('linprog','Display','none'));
        linprog_val = get_value_with_precision(x_linprog, c, precision);

        if ~isequal(round(x_1, precision), round(x_2, precision))
            non_unique_solutions_count = non_unique_solutions_count + 1;
            x1_val = get_value_with_precision(x_1, c, precision);
            x2_val = get_value_with_precision(x_2, c, precision);
            
            if x1_val == x2_val && x1_val == linprog_val
                equal_unique_solutions = equal_unique_solutions + 1;
            end
        end
    end

    fprintf('Non unique solution count: %s\n', ...
        num2str(non_unique_solutions_count));
    fprintf('Equal unique solutions accuracy: %s\n', ...
        num2str(equal_unique_solutions / non_unique_solutions_count));
end