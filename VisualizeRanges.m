function VisualizeRanges(ax, ranges)
color = [0.7, 0.7, 0.7];
set(gca,'YGrid', 'on')
set(gca,'XGrid', 'off')
YLim = get(gca, 'YLim');
for idx = 1:length(ranges)
    r = ranges(idx, :);
    plot(ax, [r(1) r(1)], YLim, 'Color', color);
    plot(ax, [r(2) r(2)], YLim, 'Color', color);
end
end