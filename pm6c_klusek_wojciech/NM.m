function [xx, exitflag, it] = NM(A, b, x0, e)
    max_iter = 5000;
    it = 0;
    alpha = 1;   % reflection coefficient
    gamma = 1.5;   % expansion coefficient
    rho = 0.7;   % contraction coefficient
    sigma = 0.1; % shrinkage coefficient
    penalty = 1;
    max_penalty = 1e8;

    % Initialize the simplex
    n = length(x0);
    simplex = [x0, eye(n, n)];

    while it < max_iter
        % Evaluate penalty function for each point in the simplex
        penalties = arrayfun(@(i) penalty_function(simplex(:, i), A, b, penalty), 1:n+1);
        
        [penalties, idx] = sort(penalties);
        simplex = simplex(:, idx);

        if it > 0 && std(penalties) < e
            break;
        end

        % Reflection
        x0 = mean(simplex(:, 1:n), 2);
        xr = x0 + alpha * (x0 - simplex(:, end));
        r = penalty_function(xr, A, b, penalty);

        if penalties(1) <= r && r < penalties(end)
            simplex(:, end) = xr;
        elseif r < penalties(1)
            % Expansion
            xe = x0 + gamma * (xr - x0);
            if penalty_function(xe, A, b, penalty) < r
                simplex(:, end) = xe;
            else
                simplex(:, end) = xr;
            end
        else
            % Contraction
            xc1 = x0 + rho * (xr - x0);
            c1 = penalty_function(xc1, A, b, penalty);

            xc2 = x0 + rho * (simplex(:, end) - x0);
            c2 = penalty_function(xc2, A, b, penalty);

            if r < penalties(end) && c1 < r
                simplex(:, end) = xc1;
            elseif r >= penalties(end) && c2 < penalties(end)
                simplex(:, end) = xc2;
            else
                % Shrink
                for i = 2:n+1
                    simplex(:, i) = simplex(:, 1) + sigma * (simplex(:, i) - simplex(:, 1));
                end
            end
        end

        penalty = min(penalty * 10, max_penalty);

        it = it + 1;
    end

    xx = simplex(:, 1);

    if all(xx > -e) && norm(A * xx - b) < e
        exitflag = 1;
    else
        exitflag = 0;
    end
end





