function draw(P, Q, p, q)
    drawPolygon(P, 'r');
    drawPolygon(Q, 'b');
    
    if nargin > 2
        plot([p(1), q(1)], [p(2), q(2)], 'k-', 'LineWidth', 2);
    end
    
    axis equal;
    hold off;
end

function drawPolygon(T, color)
    X = T(:, 1);
    Y = T(:, 2);
    X(end+1) = X(1);
    Y(end+1) = Y(1);
    fill(X, Y, color);
    hold on;
end
