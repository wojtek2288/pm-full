function [x, is_unique, iter] = simplex( ...
    A, b, c, debug, use_second_solution_if_exists)
% simplex.m Finds x vector for maximum value of function c, with
% constraints defined in A and b.
% Inputs:
%   A - coefficient matrix
%   b - right side of equation for A
%   c - function to maximize
%   debug - flag used to enable/disable tableau printing
%   use_second_solution_if_exists - makes function return second optimum x
%
% Outputs:
%   x - vector which maximizes c function
%   is_unique - flag specifying if solution is unique
%   iter - number of iterations to obtain solution

    if nargin == 3
        debug = false;
        use_second_solution_if_exists = false;
    elseif nargin == 4
        use_second_solution_if_exists = false;
    end
    
    % Initialize tableau
    [tableau, basic_variables, m, n, c] = init_tableau(A, b, c);
    
    % Iterate until optimal solution is found or no optimal solution
    % exists.
    [tableau, basic_variables, non_basic_zero_cjzj, iter] = iterate_tableau( ...
        tableau, m, n, basic_variables, c, debug, nan);

    if ~isempty(non_basic_zero_cjzj) && use_second_solution_if_exists
        [tableau, basic_variables, non_basic_zero_cjzj, iter] = iterate_tableau( ...
            tableau, m, n, basic_variables, c, debug, non_basic_zero_cjzj(1));
    end
    
    % If no optimal solution exists return empty array
    if isempty(tableau)
        x = [];
        is_unique = nan;
        return;
    end

    if isempty(non_basic_zero_cjzj)
        is_unique = true;
    else
        is_unique = false;
    end
    
    % Extract solution vector from tableau
    x = extract_solution(tableau, m, n, basic_variables);
end

function [tableau, basic_variables, m, n, c] = init_tableau(A, b, c)
    [m, n] = size(A);
    c = c';
   
    % Negative constraint for first half of variables (y = -x)
    A(1:m, 1:m) = A(1:m, 1:m) * -1;
    c(1:m) = c(1:m) * -1;
  
    tableau = [A b; c 0];

    % Initial basic feasible solution
    basic_variables = m + 1:n;
    zj = c(basic_variables) * tableau(1:m, 1:n);
    cjzj = c - zj;

    tableau(end, 1:n) = cjzj;
end

function [tableau, basic_variables, non_basic_zero_cjzj, iter] = iterate_tableau( ...
    tableau, m, n, basic_variables, c, debug, second_solution_pivot_col)

    % Display tableau if debug flag is true
    if debug
        print_tableau(tableau, basic_variables);
    end

    iter = 1;
    % Check if all values in net evaluation row are negative or 0
    while any(tableau(end, 1:n) > 0) || ~isnan(second_solution_pivot_col)

        % Find pivot column
        [~, pivot_col] = max(tableau(end, 1:n));

        if ~isnan(second_solution_pivot_col)
            pivot_col = second_solution_pivot_col;
            second_solution_pivot_col = nan;
        end
        
        % Find pivot row
        ratios = tableau(1:m, end) ./ tableau(1:m, pivot_col);
        ratios(ratios <= 0) = inf;
        [ratio, pivot_row] = min(ratios);

        if ratio == inf
            tableau = [];
            non_basic_zero_cjzj = [];
            return;
        end

        % Pivot the tableau
        tableau(pivot_row, :) = tableau(pivot_row, :) ...
            / tableau(pivot_row, pivot_col);
        for i = 1:m
            if i ~= pivot_row
                tableau(i, :) = tableau(i, :) - ...
                    tableau(i, pivot_col) * tableau(pivot_row, :);
            end
        end

        % Update the basic variables
        basic_variables(pivot_row) = pivot_col;
        
        % Update solution
        zj = c(basic_variables) * tableau(1:m, 1:n);
        cjzj = c - zj;

        tableau(end, 1:n) = cjzj;

        iter = iter + 1;
        % Display tableau if debug flag is true
        if debug
            print_tableau(tableau, basic_variables);
        end
    end
    
    % Check if solution is unique if `non_basic_zero_cjzj` is empty
    all_columns = 1:n;
    include_columns = all_columns(~ismember(all_columns, basic_variables));
    non_basic_zero_cjzj = find(tableau(end, include_columns) == 0);
end

function x = extract_solution(tableau, m, n, basic_variables)
    % Extract x from tableau
    x = zeros(n, 1);
    x(basic_variables) = tableau(1:m, n + 1);

    % Substitute back (x = -y)
    x(1:m) = x(1:m) * -1;
end

function print_tableau(tableau, basic_variables)
    rowLabels = cell(1, numel(basic_variables));
    for i = 1:numel(basic_variables)
        rowLabels{i} = ['x_', num2str(basic_variables(i))];
    end
    rowLabels{end+1} = 'cj - zj';

    numColumns = size(tableau, 2);
    columnLabels = cell(1, numColumns - 1);
    for i = 1:numColumns - 1
        columnLabels{i} = ['A_', num2str(i)];
    end
    columnLabels{end+1} = 'b';

    % Convert the matrix and row labels to a table
    dataTable = array2table(tableau, 'RowNames', rowLabels, ...
        'VariableNames', columnLabels);
    
    % Display the table
    disp(dataTable);
end
