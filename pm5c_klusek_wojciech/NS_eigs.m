function [xNS, fval, it] = NS_eigs(fun, x0, e, plot)
    if nargin == 3
        plot = 0;
    end
    
    it = 1;
    max_iter = 1000;
    xNS = x0;
    [f, grad, hess] = fun(xNS);
    gradient_norms = zeros(max_iter + 1, 1);
    gradient_norms(it) = norm(grad);
    
    for i = 1:max_iter
        % Unique eigenvalues of hessian
        lambda = eig(hess);
        
        % Sort eigenvalues ascending
        lambda = sort(lambda);
        
        % Directional minimization for eigenvalues
        for j = 1:length(lambda)
            % Direction of decline - the inverse of the i-th eigenvalue
            alpha = 1 / lambda(j);
            dir = -1 * grad;

            xNS = xNS + alpha * dir;
            
            [f, grad, hess] = fun(xNS);
            
            it = it + 1;
            gradient_norms(it) = norm(grad);

            % Stop condition
            if norm(grad) < e || it > max_iter
                break;
            end
        end
        
        % Stop condition
        if norm(grad) < e || it > max_iter
            break;
        end
    end
    
    if plot
        plot_gradients(gradient_norms, it);
    end

    fval = f;
end
