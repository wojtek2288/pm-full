function [f, grad, hess] = fun(x, A, b)
    f = 0.5 * x' * A * x - b' * x;
    grad = A * x - b;
    hess = A;
end
