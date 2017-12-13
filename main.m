%%Particle Collision Simulator

clc; close all; clear all;

rng('shuffle');
%User defined variables
desiredSystemWidth = 900;
gridDimensionX = 9;
ballCount = 10;%20;
secondsToSimulate = 10;%20;
fps = 30;
useRandomBalls = true;
particleSink = false;
debug = true;

%%Initialization of system variables.
gridDimensionY = gridDimensionX;
gridCellLength = desiredSystemWidth/(gridDimensionX - 2);
grid = constructGrid(gridDimensionX, gridDimensionY, gridCellLength);

currentDelta = [-1 0 0];
collisionTests = 0;
collisionsResolved = [0 0];
tToFrameRatio = 547/(500*fps);
tCurrent = 0;
tFinal = secondsToSimulate/tToFrameRatio;
tStep = 1;

%frames(200) = struct('cdata',[],'colormap',[]);
frame = 1;

if(useRandomBalls)
    disp('Warning: A generated set of ball may displace backward in time to outside the boundaries of the system.');
    disp('In which case, an error will be thrown by MATLAB.');
    balls = constructRandomBalls(grid, ballCount);
    if(debug)
        save('randomlygeneratedballs.mat', 'balls');
    end
else
    %load('randomlygeneratedballs.mat');
    load('initializedballs4.mat');
end


writerObj = VideoWriter('collisionAnimation.mp4','MPEG-4');
writerObj.FrameRate = 30;
writerObj.Quality = 100;
open(writerObj);


while(tCurrent < tFinal)
    possibleCollisions = {[], 1};
    objectCollisions = {[], 1};
    boundaryCollisions = [];
    
    %%Positional Prediction
    %drawBalls(balls);
    balls = displaceBalls(balls, tStep);
    tCurrent = tCurrent + tStep;
    aabbArray = aabbFromBalls(balls);
    [gridOccupationArray, boundaryCollisions] = aabbGridOccupation(grid, aabbArray);
    
    %%Broad Phase Detection of Positional Prediction
    for i = 1:length(gridOccupationArray(:, 1))
        for j = 2:5
            grid.box{gridOccupationArray(i, j)}(end +1) = gridOccupationArray(i, 1);
            grid.counter(gridOccupationArray(i, j)) = grid.counter(gridOccupationArray(i, j)) + 1;
        end
    end
    for i = 1:(grid.dimensionX*grid.dimensionY)
        grid.box{i} = unique(grid.box{i});
        grid.counter(i) = length(grid.box{i});
        for j = 1:grid.counter(i)
            for k = j+1:grid.counter(i)
                possibleCollisions{1}(possibleCollisions{2}, :) = [grid.box{i}(j) grid.box{i}(k)];
                possibleCollisions{2} = possibleCollisions{2} + 1;
            end
        end
    end
    
    %%Exact Collision Detection
    if(possibleCollisions{2} > 1)
        %Removes duplicate rows that may cause runtime errors.
        possibleCollisions{1} = unique(possibleCollisions{1}, 'rows');
        possibleCollisions{2} = length(possibleCollisions{1}(:, 1));
        for i = 1:possibleCollisions{2}
            ball1 = balls(possibleCollisions{1}(i, 1));
            ball2 = balls(possibleCollisions{1}(i, 2));
            distance = sqrt((ball2.x - ball1.x)^2 + (ball2.y - ball1.y)^2);
            if(distance < (ball1.radius + ball2.radius))
                objectCollisions{1}(objectCollisions{2}, :) = possibleCollisions{1}(i, :);
                objectCollisions{2} = objectCollisions{2} + 1;
            end
            collisionTests = collisionTests + 1;
        end
    end
    %%First Collision Time Detection
    if(objectCollisions{2} > 1)
        for i = 1:objectCollisions{2}-1
            id1 = objectCollisions{1}(i, 1);
            id2 = objectCollisions{1}(i, 2);
            %delta = find_collision_time(balls(id1), balls(id2));
            delta = computeObjectCollisionTime([balls(id1), balls(id2)]);
            if(currentDelta(1, 1) < delta)
                currentDelta = [delta id1 id2];
            elseif(currentDelta(1, 1) == delta)
                currentDelta(end+1, :) = [delta id1 id2];
            end
        end
    end
    for i = 1:length(boundaryCollisions)
        id1 = boundaryCollisions(i);
        delta = computeBoundaryCollisionTime(grid, balls(id1));
        if(currentDelta(1, 1) < delta)
            currentDelta = [delta id1 0];
        elseif(currentDelta(1, 1) == delta)
            %This is for simultaneous boundary collisions.
            currentDelta(end+1, :) = [delta id1 0];
        end
        %balls(id1) = [];
    end
    
    %%Position/Velocity Correction at First Collision Time
    if(currentDelta(1, 1) ~= -1)
        balls = displaceBalls(balls, -currentDelta(1, 1));
        tCurrent = tCurrent - currentDelta(1, 1);
        for i = 1:length(currentDelta(:, 2))
            if(currentDelta(i, 3) == 0)
                [newV1] = computeBoundaryCollisionVelocities(grid, balls(currentDelta(i, 2)));
                balls(currentDelta(i, 2)).vx = newV1(1);
                balls(currentDelta(i, 2)).vy = newV1(2);
                collisionsResolved(1, 2) = collisionsResolved(1, 2) + 1;
            else
                id1 = currentDelta(i, 2);
                id2 = currentDelta(i, 3);
                [newV1, newV2] = resolveObjectCollision([balls(id1), balls(id2)]);
                balls(id1).vx = newV1(1);
                balls(id1).vy = newV1(2);
                balls(id2).vx = newV2(1);
                balls(id2).vy = newV2(2);
                collisionsResolved(1, 1) = collisionsResolved(1, 1) + 1;
            end
        end
    end
    if(particleSink)
        if(currentDelta(1, 1) ~= -1 && currentDelta(1, 3) == 0)
            balls(currentDelta(1, 2)) = [];
        end
    end
    currentDelta = [-1 0 0];
    
    %%Displays/Saves Current Frame
    figure(1);
    clf;
    drawBalls(balls);
    title('Collision Simulation')
    set(gca, 'XLim', [0 grid.systemWidth], 'YLim', [0 grid.systemHeight], 'PlotBoxAspectRatio', [1 1 1], 'Box', 'on', 'XTickLabel','', 'YTickLabel','', 'XTick', 0:grid.cellLength:grid.systemWidth, 'XGrid', 'On',  'YTick', 0:grid.cellLength:grid.systemHeight, 'YGrid', 'On');
    if(debug)
        %Side axis used to display debug information.
        debugInfo = axes('Position',[0 0 1 1],'Visible','off');
        axes(debugInfo);
        text(.025,0.5,sprintf('%ix%i\nt = %4.3f sec\nTime Step: %i\nCurrent Step:\n%4.3f\nFrame: %i\nCollisions Tested:\n%i\nObject Collisions:\n%i\nBound Collisions:\n%i',...
            grid.dimensionX, grid.dimensionY, tCurrent*18.23/tFinal, tStep, tCurrent, frame, collisionTests, collisionsResolved(1, 1), collisionsResolved(1, 2)));
    end
    %frames(frame) = getframe;
    writeVideo(writerObj,getframe);
    frame = frame + 1;
    
    if(isempty(balls))
        break;
    end
    %Clears the current grid by making a new grid.
    grid = constructGrid(gridDimensionX, gridDimensionY, gridCellLength);
    
end
close(writerObj);
%movie(frames);
%{
writerObj = VideoWriter('collisionAnimation.mp4','MPEG-4');
writerObj.FrameRate = 30;
writerObj.Quality = 100;
open(writerObj);
writeVideo(writerObj,frames);
close(writerObj);
%}