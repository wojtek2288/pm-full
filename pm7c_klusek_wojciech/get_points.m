function [p, q, dist] = get_points(x, P, Q)
    p = P' * x(1:size(P, 1));
    q = Q' * x(size(P, 1)+1:end);
    dist = norm(p - q);
end