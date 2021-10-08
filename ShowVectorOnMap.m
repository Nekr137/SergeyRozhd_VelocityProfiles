function ShowVectorOnMap(ax, pe, pn, ve, vn, color)
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
xdata = [pe pe+ve*diff(xlim)/3];
ydata = [pn pn+vn*diff(ylim)/3];
plot(ax, xdata', ydata', 'LineWidth', 0.3, 'Color', color);
end