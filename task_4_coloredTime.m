function task_4_coloredTime()

% 4 figures (1 day, 2day, RCM(10e) RCM(11e), mm/sec (just label)


depthIndices.ship = [1]; % taking the first cell
depthIndices.ABS1 = [1];
depthIndices.ABS2 = [1];

colors = sr_build_color_vector();
ax = axes;
sz = get(0, 'ScreenSize'); % Getting your screen size
set(gcf, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size


coo.ship = sr_get_station_coordinates();
[coo.ABS1_adcp300, coo.ABS2_DVS, coo.ABS2_RCM] = sr_get_coordinates_of_bottom_stations();

sr_load_coastline_map(ax);
sr_put_scale_vector_on_map(ax);
sr_put_stations_on_map(ax);

% -------------------------------------------------------------------------

[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = sr_get_ranges_and_stations();
[filename1, filename2] = sr_get_test_filenames();

[Vn, Ve, T, H0] = sr_load_data(filename1);
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices.ship);
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ship(1:8, :), colors(1:8, :), 0.3);

[Vn, Ve, T, H0] = sr_load_data(filename2);
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices.ship);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ship(9:16, :),colors(9:16, :), 0.3);

% -------------------------------------------------------------------------

[Vn, Ve, T, H0] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices.ABS1);
Vn = Vn./1000; Ve = Ve./1000;
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ABS1_adcp300, colors(1:8, :), 0.3);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ABS1_adcp300, colors(9:16, :), 0.3);
sr_text(ax, coo.ABS1_adcp300(1), coo.ABS1_adcp300(2), 'ABS1\_adcp300', 'bl', [0.5 0 0], 7);

% -------------------------------------------------------------------------

[Vn, Ve, T, H0] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices.ABS2);
Vn = Vn./1000; Ve = Ve./1000;
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ABS2_DVS, colors(1:8, :), 0.3);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ABS2_DVS, colors(9:16, :), 0.3);
sr_text(ax, coo.ABS2_DVS(1), coo.ABS2_DVS(2), 'ABS2\_DVS', 'bl', [0.5 0 0], 7);

sr_save_figure(gcf, 'output_task_4_colored_time_fig_1');
% -------------------------------------------------------------------------

figure;
ax = axes;
colors = sr_build_color_vector();
ax = axes;
sz = get(0, 'ScreenSize'); % Getting your screen size
set(gcf, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size
coo.ship = sr_get_station_coordinates();
[coo.ABS1_adcp300, coo.ABS2_DVS, coo.ABS2_RCM] = sr_get_coordinates_of_bottom_stations();
sr_load_coastline_map(ax);
sr_put_scale_vector_on_map(ax);
sr_put_stations_on_map(ax);
[Vn, Ve, T, H0] = sr_load_ABS2_RCM_data('ABS2_RCM_184_20210809_1333.txt');
% [Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices.ABS2);
Vn = Vn./100; Ve = Ve./100;
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ABS2_RCM, colors(1:8, :), 0.3);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ABS2_RCM, colors(9:16, :), 0.3);
sr_text(ax, coo.ABS2_RCM(1), coo.ABS2_RCM(2), 'ABS2\_RCM\_DVS', 'bl', [0.5 0 0], 7);

sr_save_figure(gcf, 'output_task_4_colored_time_fig_2');
end

function ShowDayVectors(ax, Vn, Ve, T, ranges, coordinates, colors, lineWidth) 
    [nCoordinates, ~] = size(coordinates);
    for stationIdx = 1:length(ranges)        
        % The case if several vectors at the same coodinate
        coordinateIdx = min(stationIdx, nCoordinates);
        
        color = colors(stationIdx, :);

        [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
        [vn, ve, t] = sr_smooth_data(stationVn, stationVe, stationT);
        depthCnt = length(vn);
        coo = repmat(coordinates(coordinateIdx, :), depthCnt, 1);
        
        sr_show_vector_on_map(ax, coo(:, 1), coo(:, 2), ve, vn, color, lineWidth);
    end
end
