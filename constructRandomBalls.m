function balls = constructRandomBalls(grid, ballCount)
radii = num2cell(randi([10, floor(grid.maxRadius)], 1, ballCount), ballCount);
balls = struct('radius', radii);
for i = 1:ballCount
    balls(i).x = randi([balls(i).radius, floor(grid.systemWidth)-balls(i).radius]);
    balls(i).y = randi([balls(i).radius, floor(grid.systemHeight)-balls(i).radius]);
    if(i > 1)
        %Brute force method of ensuring no generated balls overlap.
        j = i-1;
        while(j > 1)
            distance = sqrt((balls(j).x - balls(i).x)^2 + (balls(j).radius + balls(i).radius)^2);
            if(distance < (balls(j).radius + balls(i).radius))
                balls(i).x = randi([balls(i).radius, floor(grid.systemWidth)-balls(i).radius]);
                balls(i).y = randi([balls(i).radius, floor(grid.systemHeight)-balls(i).radius]);
                %Starts the loop over when they are over lapping.
                j = i-1;
            else
                j = j-1;
            end
        end
    end
    %if(balls(i).x)
    balls(i).vx = randi([-10, 10]);
    balls(i).vy = randi([-10, 10]);
    balls(i).mass = balls(i).radius;
    x = floor(balls(i).mass)/floor(grid.maxRadius);
    balls(i).color = (1 - x)*[1 1 0] + x*[0 0 1];
    %{
    switch(floor(balls(i).mass/10))
        case 0
            balls(i).color = 'red';
        case 1
            balls(i).color = 'yellow';
        case 2
            balls(i).color = 'green';
        case 3
            balls(i).color = 'cyan';
        case 4
            balls(i).color = 'blue';
        otherwise
            balls(i).color = 'magenta';
    end
    %}
end
end
