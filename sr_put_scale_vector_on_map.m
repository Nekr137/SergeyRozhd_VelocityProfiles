function sr_put_scale_vector_on_map(ax)
red = [0.8 0 0];

xlim = get(ax, 'XLim');
ylim = get(ax, 'YLim');
x = xlim(1) + 0.05* (xlim(2) - xlim(1));
y = ylim(1) + 0.15* (ylim(2) - ylim(1));
sr_show_vector_on_map(ax, x, y, 0.5, 0.0, red);

sr_text(ax, x, y, '0.5 cm/s', 'br', red);
end
