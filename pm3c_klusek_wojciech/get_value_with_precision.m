function value = get_value_with_precision(x, c, precision)
% get_value_with_precision.m Gets value of c' * x rounding to precision
% Inputs:
%   x - solution vector
%   c - function
%   precision - number of significant digits to round to

    if ~isempty(x)
        value = round(c' * x, precision);
    else
        value = nan;
    end
end