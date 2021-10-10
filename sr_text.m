function height = sr_text(x, y, str, position, color, fontSize)

h = text(x, y, str);

if ~exist('color', 'var'); color = [1 0 0]; end
set(h, 'Color', color);

if ~exist('fontSize', 'var'); fontSize = 10; end
set(h, 'FontSize', fontSize);

set(h,'Units','data');
extent = get(h,'Extent');
width = extent(3);
height = extent(4);
pos = get(h, 'Position');
if strcmp(position, 'br')
    pos(2) = pos(2) - 0.7 * height;
end
if strcmp(position, 'tr')
    pos(2) = pos(2) + 0.7 * height;
end
if strcmp(position, 'bl')
    pos(2) = pos(2) - 0.7 * height;
    pos(1) = pos(1) - width;
end
set(h, 'Position', pos);
end