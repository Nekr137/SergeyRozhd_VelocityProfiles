function sr_show_vector_on_map(ax, pe, pn, ve, vn, color, lineWidth)

if ~exist('lineWidth', 'var')
    lineWidth = 0.3;
end
if ~exist('color', 'var')
    color = [1 0 0];
end

xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
xdata = [pe pe+ve*diff(xlim)/3];
ydata = [pn pn+vn*diff(ylim)/3];

if length(pe) > 1
    plot(ax, xdata', ydata', 'LineWidth', lineWidth, 'Color', color);
else
    plot(ax, xdata, ydata, 'LineWidth', lineWidth, 'Color', color);
end
end