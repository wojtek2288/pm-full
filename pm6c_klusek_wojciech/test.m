function test()
    rng(10);
    x0 = zeros(10, 1);
    e = 1e-4;
    it = 100;

    total_dist_quad = 0;
    count_quad = 0;
    
    total_dist_zfk = 0;
    total_iter_zfk = 0;
    total_norm_zfk = 0;
    count_zfk = 0;

    total_dist_nm = 0;
    total_iter_nm = 0;
    total_norm_nm = 0;
    count_nm = 0;

    count_all = 0;

    for i = 1:it
        fprintf('Iteration: %f\n', i);

        [A, b] = generate(3, 10);

        [xx_quad, exitflag_quad] = quadprog_solution(A, b);
        [xx_zfk, exitflag_zfk, iter_zfk] = ZFK(A, b, x0, e);
        [xx_nm, exitflag_nm, iter_nm] = NM(A, b, x0, e);
        
        total_iter_zfk = total_iter_zfk + iter_zfk;
        total_iter_nm = total_iter_nm + iter_nm;

        if exitflag_quad > 0
            count_quad = count_quad + 1;
        end

        if exitflag_zfk > 0
            count_zfk = count_zfk + 1;
        end

        if exitflag_nm > 0
            count_nm = count_nm + 1;
        end

        if exitflag_quad > 0 & exitflag_zfk > 0 & exitflag_nm > 0
            total_dist_quad = total_dist_quad + norm(xx_quad);
            total_dist_zfk = total_dist_zfk + norm(xx_zfk);
            total_dist_nm = total_dist_nm + norm(xx_nm);

            total_norm_zfk = total_norm_zfk + norm(xx_quad - xx_zfk);
            total_norm_nm = total_norm_nm + norm(xx_quad - xx_nm);
            count_all = count_all + 1;
        end
    end

    if count_quad > 0
        avg_dist_quad = total_dist_quad / count_all;
        fprintf('Średnia odległość (quadprog): %f\n', avg_dist_quad);
        fprintf('Liczba znalezioncyh rozwiązań (quadprog): %f\n', count_quad);
    else
        fprintf('Brak rozwiązań (quadprog)\n');
    end

    if count_zfk > 0
        avg_dist_zfk = total_dist_zfk / count_all;
        avg_norm_zfk = total_norm_zfk / count_all;
        avg_iter_zfk = total_iter_zfk / it;
        fprintf('Średnia odległość (ZFK): %f\n', avg_dist_zfk);
        fprintf('Średnia norma różnicy (ZFK): %f\n', avg_norm_zfk);
        fprintf('Średnia liczba iteracji (ZFK): %f\n', avg_iter_zfk);
        fprintf('Liczba znalezioncyh rozwiązań (ZFK): %f\n', count_zfk);
    else
        fprintf('Brak rozwiązań (ZFK)\n');
    end

    if count_nm > 0
        avg_dist_nm = total_dist_nm / count_all;
        avg_norm_nm = total_norm_nm / count_all;
        avg_iter_nm = total_iter_nm / it;
        fprintf('Średnia odległość (NM): %f\n', avg_dist_nm);
        fprintf('Średnia norma różnicy (NM): %f\n', avg_norm_nm);
        fprintf('Średnia liczba iteracji (NM): %f\n', avg_iter_nm);
        fprintf('Liczba znalezioncyh rozwiązań (NM): %f\n', count_nm);
    else
        fprintf('Brak rozwiązań (NM)\n');
    end
end
