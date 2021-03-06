function task_1()
% The task from 2021-10-01 - visualize velocities, ranges, profiles,
% station labels

% Adjust this vector to see different depth results
% Example 1: `depthIndices = [1 3 5];`
% Example 2: `depthIndices = 1:5;` (1:5 is equal to [1 2 3 4 5] vector
% Example 3: `depthIndices = -100:100;` (Extracting the all depths)
depthIndices = [1 4];

% -------------------------------------------------------------------------

% Creating the intersting ranges
filename1 = 'DATA_000p.000';
ranges1 = [
    [datenum('08/10/21 11:21') datenum('08/10/21 11:44')] % range 1
    [datenum('08/10/21 11:48') datenum('08/10/21 12:02')] % range 2
    [datenum('08/10/21 12:12') datenum('08/10/21 12:31')] % ...
    [datenum('08/10/21 12:43') datenum('08/10/21 12:59')]
    [datenum('08/10/21 13:09') datenum('08/10/21 13:22')]
    [datenum('08/10/21 13:32') datenum('08/10/21 13:48')]
    [datenum('08/10/21 13:57') datenum('08/10/21 14:15')]
    [datenum('08/10/21 14:46') datenum('08/10/21 14:54')]
];
stations1 = {'st(1)', 'st(2)', 'st2', 'st3', 'st4', 'st5', 'st6', 'st7', 'st8'};
figureTitle1 = '08/10/21';

RunFigureCreation(depthIndices, filename1, ranges1, stations1, figureTitle1);
sr_save_figure(gcf, 'output_task_1_fig_1');

% -------------------------------------------------------------------------

ranges2 = [
    [datenum('08/11/21 11:09') datenum('08/11/21 11:22')]
    [datenum('08/11/21 11:30') datenum('08/11/21 11:44')]
    [datenum('08/11/21 11:53') datenum('08/11/21 12:08')]
    [datenum('08/11/21 12:14') datenum('08/11/21 12:26')]
    [datenum('08/11/21 12:32') datenum('08/11/21 12:35')]
    [datenum('08/11/21 13:00') datenum('08/11/21 13:11')]
    [datenum('08/11/21 13:19') datenum('08/11/21 13:30')]
    [datenum('08/11/21 13:45') datenum('08/11/21 13:53')]
];
filename2 = 'DATA_003p.000';
stations2 = {'stn16', 'stn17', 'stn18', 'stn19', 'stn20', 'stn21', 'stn22', 'stn23'};
figureTitle2 = '08/11/21';

RunFigureCreation(depthIndices, filename2, ranges2, stations2, figureTitle2);
sr_save_figure(gcf, 'output_task_1_fig_2');

% -------------------------------------------------------------------------
end

function RunFigureCreation(depthIndices, filename, ranges, stations, figureTitle) 

% Parsing the file
[Vn, Ve, T, H0] = sr_load_data(filename);

% Extracting this depth information only
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices);

% Building the figure
YLim = [H0(1)-0.3*(H0(end)-H0(1)) H0(end) + 0.3 * (H0(end)-H0(1))];
ax = sr_build_figure(T(1), YLim(1), T(end), YLim(2));

% Running the sr_visualize_ranges() function
sr_visualize_ranges(ax, ranges); 

% Adding the labels
sr_add_station_labels(ax, ranges, stations);

% Put title
title(figureTitle);

STATION_VECTORS_COLOR = [1 0 0];
NONSTATION_VECTORS_COLOR = [0.9 0.9 0.9];

rangesCnt = length(ranges);

% Showing non ranges
rangeInterval = [T(1) ranges(1)];
[vn, ve, t] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);
screenCoef = 1 / length(H0) / 4;
sr_visualize_profiles(ax, vn, ve, t, H0, NONSTATION_VECTORS_COLOR, screenCoef);
for stationIdx = 1:rangesCnt
    if stationIdx > 1
        rangeInterval = [ranges(stationIdx-1, 2) ranges(stationIdx, 1)];
        [vn, ve, t] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);
        sr_visualize_profiles(ax, vn, ve, t, H0, NONSTATION_VECTORS_COLOR, screenCoef);
    end
   figure(gcf);
end
rangeInterval = [ranges(end) T(end)];
[vn, ve, t] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);
sr_visualize_profiles(ax, vn, ve, t, H0, NONSTATION_VECTORS_COLOR, screenCoef);

% Showing the ranges
for stationIdx = 1:rangesCnt
    [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
    sr_visualize_profiles(ax, stationVn, stationVe, stationT, H0, STATION_VECTORS_COLOR, screenCoef);
    figure(gcf);
end

sr_put_scale_vector(ax, screenCoef);

end