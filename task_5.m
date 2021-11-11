function task_5()

% remove depth label
% russian labels, titles
% данные ветра, даты from - to
% axis (bottom right) russian
[Vn, Ve, T, H0] = sr_load_task5('task_5.txt');

% Uncomment to debug
% [s1, s2] = size(Vn);
% Ve = 0.707 * (ones(s1, s2));
% Vn = 0.707 * (ones(s1, s2));
[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = sr_get_ranges_and_stations();

RunDayVisualization(Vn, Ve, T, H0, ranges1, stations1, figureTitle1);
sr_save_figure(gcf, 'output_task_5_fig_1');

RunDayVisualization(Vn, Ve, T, H0, ranges2, stations2, figureTitle2);
sr_save_figure(gcf, 'output_task_5_fig_2');

RunWholeIntervalVisualization(Vn, Ve, T, 1.0);
sr_save_figure(gcf, 'output_task_5_fig_3');

end

function RunWholeIntervalVisualization(Vn, Ve, T, H0)
screenCoef = 1 / length(H0) / 50;

% Building the figure
YLim = [0 2];
XLim = [T(1)-0.05*(T(end) - T(1)) T(end) + 0.05 * (T(end)-T(1))];
ax = sr_build_figure(XLim(1), YLim(1), XLim(2), YLim(2));
datetick('x','yy/mm/dd HH:MM');
ylabel('');

sr_visualize_profiles(ax, Vn, Ve, T, H0, [1 0 0], screenCoef);

title('Данные ветра, даты: 2021/08/09 - 2021/08/13');
sr_put_scale_vector(ax, screenCoef);
end

function RunDayVisualization(Vn, Ve, T, H0, ranges, stations, figureTitle)

rangeInterval = [ranges(1, 1), ranges(end, end)];
[Vn, Ve, T] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);

screenCoef = 1 / length(H0) / 10;

% Building the figure
YLim = [0 2];
XLim = [T(1)-0.05*(T(end) - T(1)) T(end) + 0.05 * (T(end)-T(1))];
ax = sr_build_figure(XLim(1), YLim(1), XLim(2), YLim(2));

sr_visualize_ranges(ax, ranges); 
sr_add_station_labels(ax, ranges, stations);

sr_create_figure(ax, Ve, Vn, T, H0, ranges, [1 0 0], [1.0 0.9 0.9], [0.9 0.9 0.9], screenCoef)
ylabel('');

title(figureTitle);
sr_put_scale_vector(ax, screenCoef);

end