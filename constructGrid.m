function grid = constructGrid(x, y, length)

systemWidth = (x - 2)*length;
systemHeight = (y - 2)*length;
maxRadius = length/2;
%gridCells = cell(x*y);
grid = struct('dimensionX', x, 'dimensionY', y, 'cellLength', length, 'systemWidth', systemWidth, 'systemHeight', systemHeight, 'maxRadius', maxRadius, 'box', {cell(x, y)}, 'counter', zeros(1, x*y));
end