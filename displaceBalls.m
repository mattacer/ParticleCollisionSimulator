function balls = displaceBalls(balls, timeStep)

m = length(balls);
for i = 1:m
    balls(i).x = balls(i).x + timeStep*balls(i).vx;
    balls(i).y = balls(i).y + timeStep*balls(i).vy;
end
end
