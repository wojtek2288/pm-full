function [RO, f_opt, exitflag, it, LL_eqlin, LL_lower] = quadprog_solution(P, Q)
    [D, Aeq, beq, lb] = get_initial_form(P, Q);

    options = optimoptions('quadprog', ...
        'ConstraintTolerance', 1.000e-10, ...
        'OptimalityTolerance', 1.000e-10, ...
        'Display','none');
    
    [x, ~, exitflag, output, lambda] = quadprog(D, [], [], [], Aeq, beq, ...
        lb, [], [], options);
    
    if exitflag == 1
        RO = x;
        f_opt = RO' * D * RO;
        it = output.iterations;
        LL_eqlin = lambda.eqlin;
        LL_lower = lambda.lower; 
    end
end
