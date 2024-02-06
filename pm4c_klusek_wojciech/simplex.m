function [ROx, ROy, exitflag] = simplex(c, A, b, g, debug)
% simplex.m Finds x vector for maximum value of function c, with
% constraints defined in A and b.
% Inputs:
%   A - coefficient matrix
%   b - right side of equation for A
%   c - function to maximize
%   debug - flag used to enable/disable tableau printing
%
% Outputs:
%   ROx - vector which maximizes c function

    if nargin == 3
        debug = false;
    end

    % Transpose c to be consistent with linprog
    c = c';
    b = [b;g];

    % Initialize tableau
    [tableau, basic_variables, m, n, c_dual, artificial_cols] = init_dual_tableau(A, b, c);
    
    % If we added some artificial variables then first phase
    if ~isempty(artificial_cols)

        [tableau, basic_variables] = iterate_tableau( ...
            tableau, m, n, basic_variables, c_dual, debug);
        
        if any(ismember(basic_variables, artificial_cols))
            ROy = [];
            ROx = [];
            exitflag = 0;
            return;
        end
        
        % Remove artificial cols
        n = n - length(artificial_cols);
        tableau(:, artificial_cols) = [];

        % Fill cjzj row
        % c_dual is 0 0 ... -1 -1 vector let's switch back and go to max
        % instead of min
        c_dual = b' * -1;
        zj = c_dual(basic_variables) * tableau(1:m, 1:n);
        cjzj = c_dual - zj;
        tableau(end, 1:n) = cjzj;
    end
 
    % Iterate until optimal solution is found or no optimal solution
    % exists.
    [tableau, basic_variables] = iterate_tableau( ...
        tableau, m, n, basic_variables, c_dual, debug);

    % If no optimal solution exists return empty array
    if isempty(tableau)
        ROy = [];
        ROx = [];
        exitflag = 0;
        return;
    end

    % Extract solution vector from tableau
    ROy = extract_solution(tableau, m, n, basic_variables);
    Ab = tableau(1:m, n - m + 1:n);
    cb = c_dual(basic_variables);
    ROx = (cb * -Ab)';
    exitflag = 1;
end

function [tableau, basic_variables, m, n, c_dual, artificial_cols] = init_dual_tableau(...
    A, b, c)

    A_dual = A';
    b_dual = c';
    c_dual = b';
  
    [m, n] = size(A_dual);
    
    negative = find(b_dual < 0);
    
    if any(negative)
        % Multiply the rows corresponding to negative by -1
        A_dual(negative, :) = A_dual(negative, :) * -1;
        b_dual(negative) = b_dual(negative) * -1;

        % Add artificial variables
        new_columns = zeros(m, length(negative));
        new_columns(negative, :) = eye(length(negative));
        A_dual = [A_dual new_columns];
        [new_m, new_n] = size(A_dual);
    
        % Make new c function to get rid of artificial variables 
        c_dual = [zeros(1, length(c_dual)) zeros(1, length(negative))];
        artificial_cols = n+1:new_n;
        c_dual(artificial_cols) = -1;

        eye_cols = find(c_dual == -1);
        % If we need to take some not artificial variables to base
        if length(eye_cols) < new_m
            % Take equations where there is only one variable
            one_variable_conditions = A_dual(:, n - m + 1:n);
            colOnes = sum(one_variable_conditions == 1, 1);
            colZeros = sum(one_variable_conditions == 0, 1);
            cols = find(colOnes == 1 & colZeros == m - 1) + n - m;
            
            eye_cols = [cols eye_cols];
        end
        
        % Initialize basic_variables based on the order of appearance
        basic_variables = zeros(1, length(eye_cols));
        for i = 1:size(A_dual, 1)
            % Find the column index with 1 in the i-th row
            [~, col_index] = find(A_dual(i, eye_cols) == 1);
            basic_variables(i) = eye_cols(col_index);
        end

        m = new_m;
        n = new_n;
    else
        % Switch from min to max in dual for simplex
        c_dual = c_dual * -1;
        % Let's take last n - columns where n is number of variables
        basic_variables = n - m + 1:n;
        artificial_cols = [];
    end

    tableau = [A_dual b_dual; c_dual 0];

    % Initial basic feasible solution
    zj = c_dual(basic_variables) * tableau(1:m, 1:n);
    cjzj = c_dual - zj;
    tableau(end, 1:n) = cjzj;
end

function [tableau, basic_variables] = iterate_tableau( ...
    tableau, m, n, basic_variables, c, debug)
    % Display tableau if debug flag is true
    if debug
        disp('c:')
        disp(c)
        print_tableau(tableau, basic_variables);
    end
    
    % Check if all values in net evaluation row are negative or 0
    while any(tableau(end, 1:n) > 0)
        % Find pivot column
        [~, pivot_col] = max(tableau(end, 1:n));
        
        % Find pivot row
        ratios = tableau(1:m, end) ./ tableau(1:m, pivot_col);
        % Do not use negative ratios and 0 divided by negative
        neg_indices = ratios < 0 | tableau(1:m, end) == 0 & tableau(1:m, pivot_col) < 0;
        ratios(neg_indices) = inf;
        [ratio, pivot_row] = min(ratios);

        if ratio == inf
            tableau = [];
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
        
        % Display tableau if debug flag is true
        if debug
            disp('c:')
            disp(c)
            print_tableau(tableau, basic_variables);
        end
    end
end

function x = extract_solution(tableau, m, n, basic_variables)
    % Extract x from tableau
    x = zeros(n, 1);
    x(basic_variables) = tableau(1:m, n + 1);
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
