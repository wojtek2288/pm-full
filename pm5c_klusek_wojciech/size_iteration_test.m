function size_iteration_test()
    rng(1);
    size = 10:10:200;
    FR1_a = [];
    FR2_a = [];
    NS_a = [];

    for n = size
        [FR1, FR2, NS] = test(n, 1, 10);
        FR1_a(end+1) = FR1;
        NS_a(end+1) = NS;
        FR2_a(end+1) = FR2;
    end
    
    y_label = 'Size';
    plot_iterations(FR1_a, size, 'FR analitical', y_label);
    plot_iterations(FR2_a, size, 'FR Armijo', y_label);
    plot_iterations(NS_a, size, 'NS', y_label);
end
