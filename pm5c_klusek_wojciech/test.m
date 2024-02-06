function [FR1_iter, FR2_iter, NS_iter] = test(matrix_size, iter, unique_eigenvalues_count)
    rng(1);
    fminunc_norm_sum = 0;
    fminunc_correct_count = 0;

    FR_analytical_norm_sum = 0;
    FR_analytical_iter_count = 0;
    FR_analytical_correct_count = 0;

    FR_armijo_norm_sum = 0;
    FR_armijo_iter_count = 0;
    FR_armijo_correct_count = 0;

    NS_norm_sum = 0;
    NS_iter_count = 0;
    NS_correct_count = 0;

    e = 1e-5;
    precision = 10;

    for i = 1:iter
        disp(['Iteration: ' num2str(i)]);
        [A, b] = generate(matrix_size, unique_eigenvalues_count);
        x0 = zeros(matrix_size, 1);
        xE = A \ b;
        fval = round(fun(xE, A, b), precision);

        [xFminunc, Fminunc_fval] = fminunc_solution(A, b, x0);
        [xFR_analytical, FR_analytical_fval, FR_analytical_it] = FR( ...
            @(x) fun(x, A, b), x0, e, 1);
        [xFR_armijo, FR_armijo_fval, FR_armijo_it] = FR( ...
            @(x) fun(x, A, b), x0, e, 0);
        [xNS, NSfval, NSit] = NS_eigs(@(x) fun(x, A, b), x0, e);

        FR_analytical_iter_count = FR_analytical_iter_count + FR_analytical_it;
        FR_armijo_iter_count = FR_armijo_iter_count + FR_armijo_it;
        NS_iter_count = NS_iter_count + NSit;
        
        if isequal(round(Fminunc_fval, precision), fval)
            fminunc_correct_count = fminunc_correct_count + 1;
        end
        
        if isequal(round(FR_analytical_fval, precision), fval)
            FR_analytical_correct_count = FR_analytical_correct_count + 1;
        end

        if isequal(round(FR_armijo_fval, precision), fval)
            FR_armijo_correct_count = FR_armijo_correct_count + 1;
        end

        if isequal(round(NSfval, precision), fval)
            NS_correct_count = NS_correct_count + 1;
        end

        fminunc_norm_sum = fminunc_norm_sum + norm(xE - xFminunc);
        FR_analytical_norm_sum = FR_analytical_norm_sum + norm(xE - xFR_analytical);
        FR_armijo_norm_sum = FR_armijo_norm_sum + norm(xE - xFR_armijo);
        NS_norm_sum = NS_norm_sum + norm(xE - xNS);
    end

    fminunc_avg_norm = fminunc_norm_sum / iter;
    fminunc_accuracy = fminunc_correct_count / iter;

    FR_analytical_avg_norm = FR_analytical_norm_sum / iter;
    FR_analytical_accuracy = FR_analytical_correct_count / iter;

    FR_armijo_avg_norm = FR_armijo_norm_sum / iter;
    FR_armijo_accuracy = FR_armijo_correct_count / iter;

    NS_avg_norm = NS_norm_sum / iter;
    NS_accuracy = NS_correct_count / iter;
    
    disp(['fminunc accuracy: ' num2str(fminunc_accuracy)]);
    disp(['fminunc average norm: ' num2str(fminunc_avg_norm)]);
    fprintf('\n')
    
    disp(['FR analytical accuracy: ' num2str(FR_analytical_accuracy)]);
    disp(['FR analytical average iteration count: ' ...
        num2str(FR_analytical_iter_count / iter)]);
    disp(['FR analytical average norm: ' num2str(FR_analytical_avg_norm)]);
    fprintf('\n')

    disp(['FR armijo accuracy: ' num2str(FR_armijo_accuracy)]);
    disp(['FR armijo average iteration count: ' ...
        num2str(FR_armijo_iter_count / iter)]);
    disp(['FR armijo average norm: ' num2str(FR_armijo_avg_norm)]);
    fprintf('\n')

    disp(['NS accuracy: ' num2str(NS_accuracy)]);
    disp(['NS average iteration count: ' num2str(NS_iter_count / iter)]);
    disp(['NS average norm: ' num2str(NS_avg_norm)]);

    FR1_iter = FR_analytical_iter_count / iter;
    FR2_iter = FR_armijo_iter_count / iter;
    NS_iter = NS_iter_count / iter;
end