function drawBalls(balls)
m = length(balls);
for i = 1:m
    xmin = balls(i).x - balls(i).radius;
    ymin = balls(i).y - balls(i).radius;
    r = balls(i).radius;
    color = balls(i).color;
    rectangle('Position', [xmin ymin 2*r 2*r], 'Curvature', [1, 1], 'FaceColor', color);
    hold on;
    
    %Draws an arrow pointing in the direction of the arrow of the ball.
    %{
    grade = sqrt(balls(i).vx^2+balls(i).vy^2)/25;
    arrowColor = (1-grade)*[1 0 0] + grade*[0 1 0];
    %}
    if(sqrt(balls(i).vx^2+balls(i).vy^2) > sqrt(180))
        arrowColor = [0 1 0];
    else
        arrowColor = [1 0 0];
    end
    arrowLength = 2*r - r/10;
    theta = atan2(balls(i).vy, balls(i).vx);
    coordinates = [xmin, xmin+arrowLength, xmin+(3*arrowLength/4), xmin+(3*arrowLength/4);balls(i).y, balls(i).y, balls(i).y-(arrowLength/4), balls(i).y+(arrowLength/4);];
    coordinates = coordinates - [balls(i).x.*ones(1, 4); balls(i).y.*ones(1, 4)];
    rotation = [cos(theta) -sin(theta); sin(theta) cos(theta);];
    coordinates = rotation*coordinates;
    coordinates = coordinates + [balls(i).x.*ones(1, 4); balls(i).y.*ones(1, 4)];
    coordinates = coordinates';
    plot(coordinates(1:2, 1), coordinates(1:2, 2), '-', 'Color', arrowColor);
    hold on;
    plot(coordinates(2:3, 1), coordinates(2:3, 2), '-', 'Color', arrowColor);
    hold on;
    plot(coordinates(2:2:4, 1), coordinates(2:2:4, 2), '-', 'Color', arrowColor);
    hold on;
    
    %Draws the ID number of the ball. Mainly used for debug purposes.
    %text(xmin, ymin, num2str(i));
end
end
