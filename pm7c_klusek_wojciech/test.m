function test()
    rng(1);
    r = 20;
    s = 20;
    tolerance = 1e-6;
    iterations = 100;
    correct = 0;
    incorrect = 0;
    imp_interations_count = 0;
    quadprog_iterations_count = 0;

    for i=1:iterations
        fprintf('Iteration: %d\n', i);

        [P, Q] = dane(r, s);

        [RO1, f_opt1, exitflag1, it1, LL_eqlin1, LL_lower1] = quadprog_solution(P, Q);
        quadprog_iterations_count = quadprog_iterations_count + it1;
    
        [RO2, f_opt2, exitflag2, it2, LL_eqlin2, LL_lower2] = IPM(P, Q);
        imp_interations_count = imp_interations_count + it2;

        if exitflag1 == exitflag2 && ...
            norm(RO1 - RO2) < tolerance && ...
            norm(f_opt1 - f_opt2) < tolerance
            correct = correct + 1;
        else
            incorrect = incorrect + 1;
        end
    end

    fprintf('Accuracy: %.2f\n', correct / iterations);
    fprintf('Average quadprog number of iterations: %.2f\n', ...
        quadprog_iterations_count / iterations);
    fprintf('Average IPM number of iterations: %.2f\n', ...
        imp_interations_count / iterations);
end
