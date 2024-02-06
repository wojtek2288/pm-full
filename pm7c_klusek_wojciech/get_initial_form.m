function [D, Aeq, beq, lb] = get_initial_form(P, Q)
    r = size(P, 1);
    s = size(Q, 1);
    
    C = [P' -Q'];
    D = C' * C;
    
    Aeq = [ones(1, r), zeros(1, s); zeros(1, r), ones(1, s)];
    beq = [1; 1];
    lb = zeros(r + s, 1);
end