function plot_iterations(iterations, n, plot_title, x_label)
    figure;
    plot(n, iterations, '-o');
    xlabel(x_label);
    ylabel('Iteration');
    title(plot_title);
    legend('Iteration count');
    grid on;
end
