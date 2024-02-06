function [f, grad] = penalty_function(x, A, b, penalty)
    constraint_eq = A * x - b;
    constraint_ineq = max(0, -x);
    
    f = norm(x)^2 + penalty * (norm(constraint_eq)^2) + penalty * (norm(constraint_ineq)^2);
    grad = 2 * (x + penalty * A' * constraint_eq - penalty * constraint_ineq);
end