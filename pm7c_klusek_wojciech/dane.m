function [P, Q] = dane(r, s)
    P = generate(r);
    Q = generate(s);
    dist = 2 + eps + (5 - eps) * rand;
    Q(:, 1) = Q(:, 1) + dist;
end

function T = generate(n)
    angles = rand(1, n) * 2 * pi;
    angles = sort(angles);
    x = cos(angles);
    y = sin(angles);
    T = [x; y]';
end
