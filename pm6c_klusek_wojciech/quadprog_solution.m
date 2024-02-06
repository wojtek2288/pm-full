function [xx, exitflag] = quadprog_solution(A, b)    
    n = size(A, 2);
    
    H = 2 * eye(n);
    f = zeros(n, 1);
    
    lb = zeros(n, 1);
    
    options = optimoptions('quadprog','Display','off');
    [xx, exitflag] = quadprog(H, f, [], [], A, b, lb, [], [], options);
end