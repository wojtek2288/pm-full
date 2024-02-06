function [A, b, eigenvalues] = generate(n, unique_eigenvalues_count)
    if nargin < 2
        unique_eigenvalues_count = n;
    end

    if unique_eigenvalues_count > n
        error('The number of unique eigenvalues cannot exceed the size of the matrix.');
    end
    
    unique_elements = randperm(n, unique_eigenvalues_count);
    result_vector = repelem(unique_elements, ceil(n / unique_eigenvalues_count));
    eigenvalues = result_vector(1:n);

    D = diag(eigenvalues);
    V = orth(randn(n));
 
    A = V * D * V';
    b = randn(n, 1);
end
