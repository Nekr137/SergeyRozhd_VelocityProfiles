function sr_create_figure(ax, Ve, Vn, T, H0, ranges, stationSmoothedVectorsColor, stationVectorColors, nonstationVectorsColor, screenCoef)

[rangesCnt, ~] = size(ranges);

% Showing non ranges
rangeInterval = [T(1) ranges(1)];
[vn, ve, t] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);
sr_visualize_profiles(ax, vn, ve, t, H0, nonstationVectorsColor, screenCoef);
for stationIdx = 1:rangesCnt
    if stationIdx > 1
        rangeInterval = [ranges(stationIdx-1, 2) ranges(stationIdx, 1)];
        [vn, ve, t] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);
        sr_visualize_profiles(ax, vn, ve, t, H0, nonstationVectorsColor, screenCoef);
    end
    figure(gcf);
end
rangeInterval = [ranges(end) T(end)];
[vn, ve, t] = sr_extract_time_interval(Vn, Ve, T, rangeInterval);
sr_visualize_profiles(ax, vn, ve, t, H0, nonstationVectorsColor, screenCoef);

% Showing the vectors
for stationIdx = 1:rangesCnt
    [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
    sr_visualize_profiles(ax, stationVn, stationVe, stationT, H0, stationVectorColors, screenCoef);
    figure(gcf);
end

% A cycle for showing the smoothed vectors
for stationIdx = 1:rangesCnt 
    [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));

    % !nb: The `t` is a vector of size [depthCnt] like the vn or ve
    %      due to different positions of nan elements in each velocity
    %      array!
    [vn, ve, t] = sr_smooth_data(stationVn, stationVe, stationT);
    
    for depthIdx = 1:length(t)
        sr_visualize_profiles(ax, vn(depthIdx), ve(depthIdx), t(depthIdx), H0(depthIdx), stationSmoothedVectorsColor, screenCoef);
    end
    figure(gcf);
end
end