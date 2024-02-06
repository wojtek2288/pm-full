function plot_gradients(gradient_norms, count)
    figure;
    plot(1:count, gradient_norms(1:count), '-o');
    xlabel('Iteration');
    ylabel('Gradient Norm');
    title('Gradient Norms');
    legend('Gradient Norms');
    grid on;
end
