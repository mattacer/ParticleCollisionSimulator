function aabb = aabbFromBalls(balls)
%Creates a m by 3 aabb array from a balls array.
%balls must be an array of balls.
%Returns an array where the odd rows are minimums and even rows are maximums. IDs are stored in column 3.

m = length(balls);
aabb = zeros(2*m, 3);
for i = 1:2:2*m-1
    id = floor((i+1)/2);
    aabb(i, 1) = balls(id).x - balls(id).radius;
    aabb(i+1, 1) = balls(id).x + balls(id).radius;
    aabb(i, 2) = balls(id).y - balls(id).radius;
    aabb(i+1, 2) = balls(id).y + balls(id).radius;
    aabb(i, 3) = id;
    aabb(i+1, 3) = id;
end
end