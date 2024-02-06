function [xx, exitflag, it] = ZFK(A, b, x0, e)
    options = optimoptions('fminunc', ...
        'SpecifyObjectiveGradient', true, ...
        'OptimalityTolerance', e * 1e-3, ...
        'StepTolerance', e * 1e-3, ...
        'Display','none');

    penalty = 1;
    max_penalty = 1e8;
    max_iter = 500;
    it = 0;
    x = x0;

    while it < max_iter
        [x, ~, ~, output] = fminunc( ...
            @(x) penalty_function(x, A, b, penalty), x, options);

        if it > 0 && norm(x - prev_x) < e
            break;
        end

        prev_x = x;
        penalty = min(penalty * 10, max_penalty);
        it = it + output.iterations;
    end

    xx = x;

    if all(xx > -e) && norm(A * xx - b) < e
        exitflag = 1;
    else
        exitflag = 0;
    end
end
