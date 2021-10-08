function ax = BuildFigure(xmin, ymin, xmax, ymax)
figureHandler = figure;    % new figure
hold on;                   % Enabled not removing the old lines if new one is created.
sz = get(0, 'ScreenSize'); % Getting your screen size
set(figureHandler, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size
axis square;               % Made axis squared
xlabel('Time'); ylabel('Depth'); % Axis labels
box on; grid on;           % Enabling the box (a rectangle around the grapth) and enabling the grid

% YLim = [H0(1) - 0.01 * (H0(end)-H0(1)) H0(end) + 0.01*(H0(end)-H(1))];
% XLim = [T(1) T(end)];
ax = get(figureHandler, 'Children');
XLim = [xmin xmax];
YLim = [ymin ymax];
set(ax, 'YLim', YLim)
set(ax, 'XLim', XLim);
datetick('x','HH:MM');
set(ax, 'XLim', XLim);
set(ax, 'YDir', 'reverse'); % Made y axis reversed
end
