function sr_put_scale_vector(ax, screenCoef)
red = [0.8 0 0];

xlim = get(ax, 'XLim');
ylim = get(ax, 'YLim');
x = xlim(1) + 0.05* (xlim(2) - xlim(1));
y = ylim(1) + 0.95* (ylim(2) - ylim(1));
sr_visualize_profiles(ax, 0.0, 1.0, x, y, red, screenCoef);

sr_text(x, y, '1.0 cm/s', 'tr', red);
end
