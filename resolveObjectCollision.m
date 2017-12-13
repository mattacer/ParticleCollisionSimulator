function [vel1,vel2] = resolveObjectCollision(balls)%posX,posY,velX,velY)
% Resolves elastic object to object collisions
% Input is a 1 by 2 matrix of colliding objects

v1Cartesian = [balls(1).vx;balls(1).vy];
v2Cartesian = [balls(2).vx;balls(2).vy];

contactAngle = atan2((balls(2).y-balls(1).y),(balls(2).x-balls(1).x));

% Rotate axes so that new x-axis is perpendicular to line of contact
rotationMatrix = [cos(contactAngle), sin(contactAngle);
                  -sin(contactAngle), cos(contactAngle)];  
v1Rotated = rotationMatrix*v1Cartesian;
v2Rotated = rotationMatrix*v2Cartesian;

% Swap velocities along rotated x-axis
%{
tempSwappedVelocity = v1Rotated(1);
v1Rotated(1) = v2Rotated(1);
v2Rotated(1) = tempSwappedVelocity;
%}
m1 = balls(1).mass;
m2 = balls(2).mass;
tempVelocity = ((m1-m2)*v1Rotated(1)+2*m2*v2Rotated(1))/(m1+m2);
v2Rotated(1) = ((m2-m1)*v2Rotated(1)+2*m1*v1Rotated(1))/(m1+m2);
v1Rotated(1) = tempVelocity;

% Rotate back to initial frame
v1Cartesian = rotationMatrix'*v1Rotated;
v2Cartesian = rotationMatrix'*v2Rotated;
vel1 = [v1Cartesian(1); v1Cartesian(2)];
vel2 = [v2Cartesian(1); v2Cartesian(2)];

end