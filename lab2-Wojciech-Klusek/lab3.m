N = 7;

A = [-2 -1 0
    -1 -4 -6];

lb = [0 0 0];

b = [-3*N -2*N];
f = [1 1 1];

[x, fval, exitflag, output, lambda] = linprog(f,A,b, [], [], lb, [])
