function [xFR, fval, it] = FR(fun, x0, e, use_analytical_alpha, plot)
    if nargin == 3
        use_analytical_alpha = 1;
        plot = 0;
    elseif nargin == 4
        plot = 0;
    end
   
    max_iter = 1000;

    % Armijo tolerance
    alpha_tol = 1e-3;
    % Armijo contraction coefficient
    beta = 0.5;

    xFR = x0;
    [fval, grad, hess] = fun(xFR);
    gradient_norms = zeros(max_iter + 1, 1);
    gradient_norms(1) = norm(grad);
   
    % Search direction
    d = -grad;

    for it = 1:max_iter 
        if use_analytical_alpha
            % Analytical alpha equation
            alpha = -dot(grad, d) / dot(d, hess * d);
        else
            % Armijo with contraction
            alpha = 1.0; % Starting alpha
            while fun(xFR + alpha * d) > fval + alpha * alpha_tol * dot(grad, d)
                alpha = beta * alpha; % Contraction
            end
        end

        % Update x
        xFR = xFR + alpha * d;
        [fval_new, grad_new, hess_new] = fun(xFR);

        % Conjugate gradient
        beta_fr = dot(grad_new, grad_new) / dot(grad, grad);
        d = -grad_new + beta_fr * d;

        fval = fval_new;
        grad = grad_new;
        hess = hess_new;

        gradient_norms(it + 1) = norm(grad);

        if norm(grad) < e
            break;
        end
    end

    if plot
        plot_gradients(gradient_norms, it + 1);
    end
end
