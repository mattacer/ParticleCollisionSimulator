function ball = ConstructBall(x, y, vx, vy, radius, mass)
switch(floor(mass/10))
    case 0
        color = 'red';
    case 1
        color = 'yellow';
    case 2
        color = 'green';
    case 3
        color = 'cyan';
    case 4
        color = 'blue';
    case 5
        color = 'magenta';
end
ball = struct('x', x, 'y', y, 'vx', vx, 'vy', vy, 'radius', radius, 'mass', mass, 'color', color);
end
