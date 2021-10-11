function task_suspension()

% set depth labels as meters

% total suspended mater (TSM)

% See suspension.docx
suspension1 = [3.48 2.49 1.94 1.41 0.49 0.55 0.36 0.64]; % 10.08.21
suspension2 = [1.09 1.18 0.63 0.62 0.88 0.67 1.21 1.56]; % 11.08.21

depth1 = 1;

coo = sr_get_station_coordinates();
[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = sr_get_ranges_and_stations();
[filename1, filename2] = sr_get_test_filenames();

figure;
ax1 = axes;
sz = get(0, 'ScreenSize');
set(gcf, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]);
sr_load_coastline_map(ax1);
sr_put_scale_vector_on_map(ax1);
sr_put_stations_on_map(ax1);
[Vn, Ve, T, H0] = sr_load_data(filename1);
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depth1);
set(get(ax1, 'Title'), 'String', ['10/08/21, depth = ' num2str(H0(depth1))]);
ShowDayVectors(ax1, Vn, Ve, T, ranges1, coo(1:8, :), suspension1);
[Vn, Ve, T, H0] = sr_load_data(filename2);
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depth1);
ShowDayVectors(ax1, Vn, Ve, T, ranges2, coo(9:16, :), suspension2);

sr_save_figure(gcf, 'output_task_suspension');
end

function ShowDayVectors(ax, Vn, Ve, T, ranges, coordinates, suspension) 
    [nCoordinates, ~] = size(coordinates);
    for stationIdx = 1:length(ranges)        
        % The case if several vectors at the same coodinate
        coordinateIdx = min(stationIdx, nCoordinates);
        
        [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
        [vn, ve, t] = sr_smooth_data(stationVn, stationVe, stationT);
        depthCnt = length(vn);
        coo = repmat(coordinates(coordinateIdx, :), depthCnt, 1);
        
        sr_show_vector_on_map(ax, coo(:, 1), coo(:, 2), ve, vn, [0 0.7 0], 1.5);
        
        sus = suspension(coordinateIdx);
        ve = ve * sus; % The same as: ve / norm([ve vn]) * (norm([ve vn]) * sus);
        vn = vn * sus; % The same as: ve / norm([ve vn]) * (norm([ve vn]) * sus);
        
        sr_show_vector_on_map(ax, coo(:, 1), coo(:, 2), ve, vn, [1 0 0], 0.5);
    end
end
