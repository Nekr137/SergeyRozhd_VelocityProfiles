function CreateFigure(ax, Ve, Vn, T, H0, ranges, stationSmoothedVectorsColor, stationVectorColors, nonstationVectorsColor, screenCoef)

rangesCnt = length(ranges);

% Showing non ranges
rangeInterval = [T(1) ranges(1)];
[vn, ve, t] = ExtractTimeInterval(Vn, Ve, T, rangeInterval);
VisualizeProfiles(ax, vn, ve, t, H0, nonstationVectorsColor, screenCoef);
for stationIdx = 1:rangesCnt
    if stationIdx > 1
        rangeInterval = [ranges(stationIdx-1, 2) ranges(stationIdx, 1)];
        [vn, ve, t] = ExtractTimeInterval(Vn, Ve, T, rangeInterval);
        VisualizeProfiles(ax, vn, ve, t, H0, nonstationVectorsColor, screenCoef);
    end
    figure(gcf);
end
rangeInterval = [ranges(end) T(end)];
[vn, ve, t] = ExtractTimeInterval(Vn, Ve, T, rangeInterval);
VisualizeProfiles(ax, vn, ve, t, H0, nonstationVectorsColor, screenCoef);

% Showing the vectors
for stationIdx = 1:rangesCnt
    [stationVn, stationVe, stationT] = ExtractTimeInterval(Vn, Ve, T, ranges(stationIdx, :));
    VisualizeProfiles(ax, stationVn, stationVe, stationT, H0, stationVectorColors, screenCoef);
    figure(gcf);
end

% A cycle for showing the smoothed vectors
for stationIdx = 1:rangesCnt 
    [stationVn, stationVe, stationT] = ExtractTimeInterval(Vn, Ve, T, ranges(stationIdx, :));

    % !nb: The `t` is a vector of size [depthCnt] like the vn or ve
    %      due to different positions of nan elements in each velocity
    %      array!
    [vn, ve, t] = smoothData(stationVn, stationVe, stationT);
    
    for depthIdx = 1:length(t)
        VisualizeProfiles(ax, vn(depthIdx), ve(depthIdx), t(depthIdx), H0(depthIdx), stationSmoothedVectorsColor, screenCoef);
    end
    figure(gcf);
end
end