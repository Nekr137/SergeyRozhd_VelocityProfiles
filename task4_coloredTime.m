function task4_coloredTime()

depthIndices.ship = [2];
depthIndices.ABS1 = [1];
depthIndices.ABS2 = [1];

colors = BuildColorVector();
ax = axes;
sz = get(0, 'ScreenSize'); % Getting your screen size
set(gcf, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size


coo.ship = StationCoordinates();
[coo.ABS1_adcp300, coo.ABS2_DVS, coo.ABS2_RCM] = GetCoordinatesOfBottomStations();

LoadCoastLineMap(ax);
PutScaleVectorOnMap(ax);

% -------------------------------------------------------------------------

[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = GetRangesAndStations();
[filename1, filename2] = GetTestFilenames();

[Vn, Ve, T, H0] = LoadData(filename1);
[Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices.ship);
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ship(1:8, :), colors(1:8, :), 0.3);

[Vn, Ve, T, H0] = LoadData(filename2);
[Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices.ship);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ship(9:16, :),colors(9:16, :), 0.3);

% -------------------------------------------------------------------------

[Vn, Ve, T, H0] = LoadABSData('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices.ABS1);
Vn = Vn./500; Ve = Ve./500;
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ABS1_adcp300, colors(1:8, :), 0.3);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ABS1_adcp300, colors(9:16, :), 0.3);
sr_text(coo.ABS1_adcp300(1), coo.ABS1_adcp300(2), 'ABS1\_adcp300', 'bl', [0.5 0 0], 7);

% -------------------------------------------------------------------------

[Vn, Ve, T, H0] = LoadABSData('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');
[Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices.ABS2);
Vn = Vn./300; Ve = Ve./300;
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ABS2_DVS, colors(1:8, :), 0.3);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ABS2_DVS, colors(9:16, :), 0.3);
sr_text(coo.ABS2_DVS(1), coo.ABS2_DVS(2), 'ABS2\_DVS', 'bl', [0.5 0 0], 7);

% -------------------------------------------------------------------------

[Vn, Ve, T, H0] = sr_load_ABS2_RCM_data('ABS2_RCM_184_20210809_1333.txt');
% [Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices.ABS2);
Vn = Vn./10; Ve = Ve./10;
ShowDayVectors(ax, Vn, Ve, T, ranges1, coo.ABS2_RCM, colors(1:8, :), 0.3);
ShowDayVectors(ax, Vn, Ve, T, ranges2, coo.ABS2_RCM, colors(9:16, :), 0.3);
sr_text(coo.ABS2_RCM(1), coo.ABS2_RCM(2), 'ABS2\_RCM\_DVS', 'bl', [0.5 0 0], 7);
end

function ShowDayVectors(ax, Vn, Ve, T, ranges, coordinates, colors, lineWidth) 
    [nCoordinates, ~] = size(coordinates);
    for stationIdx = 1:length(ranges)        
        % The case if several vectors at the same coodinate
        coordinateIdx = min(stationIdx, nCoordinates);
        
        color = colors(stationIdx, :);

        [stationVn, stationVe, stationT] = ExtractTimeInterval(Vn, Ve, T, ranges(stationIdx, :));
        [vn, ve, t] = smoothData(stationVn, stationVe, stationT);
        depthCnt = length(vn);
        coo = repmat(coordinates(coordinateIdx, :), depthCnt, 1);
        
        ShowVectorOnMap(ax, coo(:, 1), coo(:, 2), ve, vn, color, lineWidth);
    end
end
