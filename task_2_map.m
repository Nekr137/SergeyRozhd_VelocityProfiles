function task_2_map()

% remove non-visualized stations
% depth extension
% make vectors same at different figures

% The task from 2021-10-07
% Placed smoothing vectors on the MAP

% Creating the intersting ranges
filename1 = 'DATA_000p.000';
filename2 = 'DATA_003p.000';

[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = sr_get_ranges_and_stations();
coordinates = sr_get_station_coordinates();

depth1 = 1;
depth2 = 4;


ShowMap(coordinates(1:8, :), depth1, filename1, ranges1, '08/10/21');
sr_save_figure(gcf, 'output_task_2_map_fig_1');

ShowMap(coordinates(1:8, :), depth2, filename1, ranges1, '08/10/21');
sr_save_figure(gcf, 'output_task_2_map_fig_2');

ShowMap(coordinates(9:16, :), depth1, filename2, ranges2, '08/11/21');
sr_save_figure(gcf, 'output_task_2_map_fig_3');

ShowMap(coordinates(9:16, :), depth2, filename2, ranges2, '08/11/21');
sr_save_figure(gcf, 'output_task_2_map_fig_4');



end

function ShowMap(coordinates, depthIndices, filename, ranges, figureTitle) 

fig = figure;
sz = get(0, 'ScreenSize'); % Getting your screen size
set(gcf, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]);
ax = gca;
sr_load_coastline_map(ax);

% Parsing the file
[Vn, Ve, T, H0] = sr_load_data(filename);

% Uncomment to check if visualization is correct
% [s1, s2] = size(Vn);
% Ve = 0.707 * (ones(s1, s2));
% Vn = 0.707 * (ones(s1, s2));

titleHandler = get(ax, 'Title');
str = [figureTitle ', depth: ' num2str(H0(depthIndices(1)))];
set(titleHandler, 'String', str);

% Extracting this depth information only
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices);
rangesCnt = length(ranges);

depthColors = [[1 0 0]; [0 0 1]; [0 1 0]; [1 1 0]; [1 0 1]; [1 1 0]];

for stationIdx = 1:rangesCnt 
    coo = coordinates(stationIdx, :); % station coordinate
    [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
    
%     for depthIdx = 1:length(H0)
%         for timeIdx = 1:length(stationVn)
%             ShowVectorOnMap(...
%                 ax, coo(1), coo(2),...
%                 stationVe(depthIdx, timeIdx),...
%                 stationVn(depthIdx, timeIdx),...
%                 [0.9 0.9 0.9]);
%         end
%     end

    [vn, ve, t] = sr_smooth_data(stationVn, stationVe, stationT);
    
    for depthIdx = 1:length(t)
        color = depthColors(min(depthIdx,length(depthColors)), :);
        sr_show_vector_on_map(ax, coo(1), coo(2), ve(depthIdx), vn(depthIdx), color);
    end
end

sr_put_scale_vector_on_map(ax);
sr_put_stations_on_map(ax);
end


