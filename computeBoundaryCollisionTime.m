function delta = computeBoundaryCollisionTime(grid, ball)

deltaX = 0;
deltaY = 0;
minX = ball.x - ball.radius;
maxX = ball.x + ball.radius;
minY= ball.y - ball.radius;
maxY = ball.y + ball.radius;
minXIndex = ceil(minX/grid.cellLength) + 1;
maxXIndex = ceil(maxX/grid.cellLength) + 1;
minYIndex= grid.dimensionY - ceil(minY/grid.cellLength);
maxYIndex = grid.dimensionY - ceil(maxY/grid.cellLength);

if(minXIndex == 1 && ball.vx < 0)
    %0 = (minX + delta*ball.vx) - (minXIndex-1)*grid.cellLength;
    deltaX = minX/ball.vx;
elseif(maxXIndex == grid.dimensionX && ball.vx > 0)
    %distance = (maxXIndex-2)*grid.cellLength - maxX;
    deltaX = (maxX - (maxXIndex-2)*grid.cellLength)/ball.vx;
end

if(minYIndex == grid.dimensionY && ball.vy < 0)
    deltaY = minY/ball.vy;
elseif(maxYIndex == 1 && ball.vy > 0)
    deltaY = (maxY - (grid.dimensionY-2)*grid.cellLength)/ball.vy;
end

if(deltaY > deltaX)
    delta = deltaY;
else
    delta = deltaX;
end

end
