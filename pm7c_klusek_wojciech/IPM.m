function [RO, f_opt, exitflag, it, LL_eqlin, LL_lower] = IPM(P, Q)
    [D, Aeq, beq] = get_initial_form(P, Q);
    n = size(Aeq, 1);
    m = size(Aeq, 2);
    
    max_iterations = 100;
    exitflag = 0;
    eps = 1e-10;
    sigma = 0.01;
    beta = 0.999;

    x = ones(m, 1);
    y = [1 ; 1];
    z = ones(m, 1);
    
    for it = 1:max_iterations

        if(norm(Aeq * x - beq) < eps && ...
                norm(D * x - Aeq' * y - z) < eps && ...
                norm(z' * x) < eps)
            exitflag = 1;
            break;
        end
                
        % Calculate directions
        r = sigma * (z' * x) / (n + m);
        X = diag(x);
        Z = diag(z);
        e = ones(length(x), 1);
    
        L = [-(X \ Z + D), Aeq'; Aeq, zeros(size(Aeq, 1))];
        R = [-Aeq' * y - r * (X \ e) + D * x; beq - Aeq * x];
    
        directions = L \ R;
        
        x_dir = directions(1:length(z));
        y_dir = directions((length(z) + 1):end);
        z_dir = X \ (r * e - X * Z * e - Z * x_dir);
        
        % Calculate alpha    
        beta_x = -beta * (x ./ x_dir);
        beta_x(x_dir >= 0) = Inf;
    
        beta_z = -beta * (z ./ z_dir);
        beta_z(z_dir >= 0) = Inf;
    
        alpha = min(1, min([beta_x; beta_z]));
        
        % Update current solution
        x = x + alpha * x_dir;
        y = y + alpha * y_dir;
        z = z + alpha * z_dir;
    end

    if exitflag == 1
        RO = x;
        f_opt = RO' * D * RO;
        LL_eqlin = y;
        LL_lower = z;
    end
end