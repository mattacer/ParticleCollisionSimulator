function [gridOccupationArray, boundaryCollisions] = aabbGridOccupation(grid, aabbArray)

toLinearIndex = reshape(1:(grid.dimensionX*grid.dimensionY), grid.dimensionY, grid.dimensionX);

m = length(aabbArray(:, 1));
boundaryCollisions = [];
gridOccupationArray = zeros(m/2, 5);
for i = 1:2:m-1
    %j = floor((i+1)/2);
    gridOccupationArray(floor((i+1)/2), 1) = aabbArray(i, 3);
    
    minX = aabbArray(i, 1);
    maxX = aabbArray(i+1, 1);
    minY = aabbArray(i, 2);
    maxY = aabbArray(i+1, 2);
    minXIndex = ceil(minX/grid.cellLength) + 1;
    maxXIndex = ceil(maxX/grid.cellLength) + 1;
    minYIndex= grid.dimensionY - ceil(minY/grid.cellLength);
    maxYIndex = grid.dimensionY - ceil(maxY/grid.cellLength);
    if(minXIndex == 1 || maxXIndex == grid.dimensionX || minYIndex == grid.dimensionY || maxYIndex == 1)
        boundaryCollisions(end+1) = aabbArray(i, 3);
    end
    %x-min & y-max
    gridOccupationArray(floor((i+1)/2), 2) = toLinearIndex(maxYIndex, minXIndex);
    %Pmin
    gridOccupationArray(floor((i+1)/2), 3) = toLinearIndex(minYIndex, minXIndex);
    %y-max & x-min
    gridOccupationArray(floor((i+1)/2), 4) = toLinearIndex(minYIndex, maxXIndex);
    %Pmax
    gridOccupationArray(floor((i+1)/2), 5) = toLinearIndex(maxYIndex, maxXIndex);
end
end
