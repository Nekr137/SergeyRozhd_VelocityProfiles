function task4_coloredTime()

DEPTH_SHIP = [2];
[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = GetRangesAndStations();
[filename1, filename2] = GetTestFilenames();
coordinates = StationCoordinates();

colors = BuildColorVector();
colorIdx = 2;

ax = axes;

LoadCoastLineMap(ax);
PutScaleVectorOnMap(ax);

ShowDayVectors(ax, filename1, ranges1, coordinates(1:8, :), DEPTH_SHIP, colors(1:8, :));
ShowDayVectors(ax, filename2, ranges2, coordinates(9:16, :), DEPTH_SHIP,colors(9:16, :));

end

function ShowDayVectors(ax, filename, ranges, coordinates, depths, colors)
    
    [Vn, Ve, T, H0] = LoadData(filename);
    [Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depths);
    
    for stationIdx = 1:length(ranges)
        
        color = colors(stationIdx, :);
        
        [stationVn, stationVe, stationT] = ExtractTimeInterval(Vn, Ve, T, ranges(stationIdx, :));
        [vn, ve, t] = smoothData(stationVn, stationVe, stationT);
        depthCnt = length(vn);
        coo = repmat(coordinates(stationIdx, :), depthCnt, 1);
        ShowVectorOnMap(ax, coo(:, 1), coo(:, 2), ve, vn, color);
    end
end
