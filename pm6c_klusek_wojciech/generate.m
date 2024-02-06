function [A, b] = generate(m, n)
    A = randi([-5 5], m, n);
    while rank(A) ~= m
        A = randi([-5 5], m, n);
    end
    b = randi([-5, 5], m, 1);
end