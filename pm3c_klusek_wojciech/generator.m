function [A, b, c] = generator()
% generator.m Generates valid input for linear programming problem
% Outputs:
%   A - coefficient matrix
%   b - right side of equation for A
%   c - function to maximize

    A = randi([-5, 5], 5);
    c = randi([-5, 5], 10, 1);
    b = randi([1, 5], 5, 1);
    
    I = eye(5);
    
    A = [A I];
end