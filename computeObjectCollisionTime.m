function objectCollisionTimes = ...
    computeObjectCollisionTimeAlt(balls)%->[ball ball]

% computeObjectCollisionTime determines the reverse time increment for
% overlapping pairs of objects. You can input either a single collision
% pair OR all collision pairs in the format specified below. 
% N is the number of object-to-object collision pairs.

%%% Input %%%
% posX [N x 2 array]: x coordinates of collision pair
% posY [N x 2 array]: y coordinates of collision pair
% velX [N x 2 array]: x velocity components of collision pair
% velY [N x 2 array]: y velocity components of collision pair
% radius [scalar]: object radius

%%% Output %%%
% objectCollisionTimes [N x 1 array]

% ----------------------------------------------------------------------- %

% Solve quadratic equation to determine reverse time increment
%a = velY(:,2).^2-2*velY(:,1).*velY(:,2)+velX(:,2).^2-...
    %2*velX(:,1).*velX(:,2)+velY(:,1).^2+velX(:,1).^2;
a = (balls(:, 2).vy).^2-2*(balls(:,1).vy).*(balls(:,2).vy)+(balls(:,2).vx).^2-...
    2*(balls(:,1).vx).*(balls(:,2).vx)+(balls(:,1).vy).^2+(balls(:,1).vx).^2;
%{
b = (2*posY(:,1)-2*posY(:,2)).*velY(:,2)+(2*posX(:,1)-...
    2*posX(:,2)).*velX(:,2)+2*posY(:,2).*velY(:,1)+...
    2*posX(:,2).*velX(:,1)-2*velY(:,1).*posY(:,1)-2*velX(:,1).*posX(:,1);
    %}
b = (2*(balls(:,1).y)-2*(balls(:,2).y)).*(balls(:,2).vy)+(2*(balls(:,1).x)-...
    2*(balls(:,2).x)).*(balls(:,2).vx)+2*(balls(:,2).y).*(balls(:,1).vy)+...
    2*(balls(:,2).x).*(balls(:,1).vx)-2*(balls(:,1).vy).*(balls(:,1).y)-2*(balls(:,1).vx).*(balls(:,1).x);
%{
c = posY(:,2).^2-2*posY(:,1).*posY(:,2)+posX(:,2).^2-...
    2*posX(:,1).*posX(:,2)+posY(:,1).^2+posX(:,1).^2-(radius(:, 1) + radius(:, 2)).^2;
    %}
c = (balls(:,2).y).^2-2*(balls(:,1).y).*(balls(:,2).y)+(balls(:,2).x).^2-...
    2*(balls(:,1).x).*(balls(:,2).x)+(balls(:,1).y).^2+(balls(:,1).x).^2-(balls(:, 1).radius + balls(:, 2).radius).^2;

objectCollisionTimes = (-b+sqrt(b.^2-4*a.*c))./(2*a);

end