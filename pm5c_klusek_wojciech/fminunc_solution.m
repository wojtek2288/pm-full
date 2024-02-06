function [x_min, f_min] = fminunc_solution(A, b, x0)
    options = optimoptions('fminunc', 'Display', 'iter', 'Algorithm', ...
        'quasi-newton', 'GradObj', 'on');
    [x_min, f_min] = fminunc(@(x) fun(x, A, b), x0, options);
end