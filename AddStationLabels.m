function AddStationLabels(fig, ranges, labels)
figure(fig);
yLim = get(gca, 'YLim');
xLim = get(gca, 'XLim');
yPos = yLim(1) + 0.07 * (yLim(2) - yLim(1));
for idx = 1:length(ranges)
    r = ranges(idx, :);
    r(1) = max(r(1), xLim(1));
    r(2) = min(r(2), xLim(2));
    xPos = 0.5 * (r(2) + r(1));
    h = text(xPos, yPos, labels(idx));
    extent = get(h,'Extent');
    width = extent(3);
    pos = get(h, 'Position');
    pos(1) = pos(1) - 0.5 * width;
    set(h, 'Position', pos);
    set(h,'Units','data');
end
end