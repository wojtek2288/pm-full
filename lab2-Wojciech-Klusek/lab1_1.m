A = [1 2
    1 -2
    3 -1
    4 2];

b = [6 2 5 8];

f = [5 3];

opcje = optimset(@linprog);
opcje = optimset(opcje,'Display','iter','Algorithm','interior-point');

[x, fval, exitflag, output, lambda] = linprog(-f,A,b);

x_opt = [A(1,:);A(4,:)] \ [b(1);b(4)];
disp(x_opt);
f_opt = f'*x_opt;
disp(f_opt)