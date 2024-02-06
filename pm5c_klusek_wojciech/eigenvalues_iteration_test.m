function eigenvalues_iteration_test()
    rng(1);
    eigs = 1:50;
    FR1_a = [];
    FR2_a = [];
    NS_a = [];

    for n = eigs
        [FR1, FR2, NS] = test(50, 1, n);
        FR1_a(end+1) = FR1;
        NS_a(end+1) = NS;
        FR2_a(end+1) = FR2;
    end
    
    y_label = 'Eigenvalues count';
    plot_iterations(FR1_a, eigs, 'FR analitical', y_label);
    plot_iterations(FR2_a, eigs, 'FR Armijo', y_label);
    plot_iterations(NS_a, eigs, 'NS', y_label);
end
