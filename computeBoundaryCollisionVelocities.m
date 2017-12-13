function newVelocity = computeBoundaryCollisionVelocities(grid, ball)
vx = ball.vx;
vy = ball.vy;
minX = ball.x - ball.radius;
maxX = ball.x + ball.radius;
minY= ball.y - ball.radius;
maxY = ball.y + ball.radius;
minXIndex = ceil(minX/grid.cellLength) + 1;
maxXIndex = ceil(maxX/grid.cellLength) + 1;
minYIndex= grid.dimensionY - ceil(minY/grid.cellLength);
maxYIndex = grid.dimensionY - ceil(maxY/grid.cellLength);
if(minXIndex == 1 && vx < 0 && minX + vx < 0)
    vx = -ball.vx;
elseif(maxXIndex+1 >= grid.dimensionX && vx > 0 && maxX + vx > grid.systemWidth)
    vx = -ball.vx;
end

if(minYIndex >= grid.dimensionY && vy < 0 && minY + vy < 0)
    vy = -ball.vy;
elseif(maxYIndex-1 == 1 && vy > 0 && maxY + vy > grid.systemHeight)
    vy = -ball.vy;
end
%{
v1 = sqrt((ball.vx)^2 + (ball.vy)^2);
if(ball.vx == 0)
    theta1i = sign(ball.vy)*pi/2;
else
    theta1i = atan(ball.vy/ball.vx);
end

vn1 = -v1*sin(theta1i);
vt1 = v1*cos(theta1i);
theta1f = atan(vn1/vt1);
v1f = sqrt(vn1^2 + vt1^2);


vx1 = v1f*cos(theta1f);
vy1 = v1f*sin(theta1f);
%}
newVelocity = [vx, vy];
end
