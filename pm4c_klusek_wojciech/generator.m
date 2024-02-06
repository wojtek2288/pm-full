function [A, b, c, g] = generator()
% generator.m Generates valid input for linear programming problem
% Outputs:
%   A - coefficient matrix
%   b - right side of equation for A
%   c - function to maximize
    n = 5;
    m = 10;

    A = randi([-2, 2], m, n);
    b = randi([1, 5], m, 1);
    c = randi([-2, 2], n, 1);
    g = randi([1, 5], n , 1);
    
    I = eye(n);
    
    A = [A; I];
end