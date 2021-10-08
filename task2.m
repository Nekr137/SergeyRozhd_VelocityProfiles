function task2
[filename1, filename2] = GetTestFilenames();
[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = GetRangesAndStations();
RunFigureCreation(filename1, ranges1, stations1, figureTitle1);
RunFigureCreation(filename2, ranges2, stations2, figureTitle2);
end


function RunFigureCreation(filename, ranges, stations, figureTitle) 

% Parsing the file
[Vn, Ve, T, H0] = LoadData(filename);
depthIndices = [1 4];
[Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices);

screenCoef = 1 / length(H0) / 3;

% Building the figure
YLim = [H0(1)-0.3*(H0(end)-H0(1)) H0(end) + 0.3 * (H0(end)-H0(1))];
XLim = [T(1)-0.05*(T(end) - T(1)) T(end) + 0.05 * (T(end)-T(1))];
ax = BuildFigure(XLim(1), YLim(1), XLim(2), YLim(2));

% Running the VisualizeRanges() function
VisualizeRanges(ax, ranges); 

% Adding the labels
AddStationLabels(ax, ranges, stations);

% Put title
title(figureTitle);

% Uncomment to validate the visualization
% [s1, s2] = size(Vn);
% Ve = 0.707 * (ones(s1, s2));
% Vn = 0.707 * (ones(s1, s2));
CreateFigure(ax, Ve, Vn, T, H0, ranges, [1 0 0], [1.0 0.9 0.9], [0.9 0.9 0.9], screenCoef)


[Vn, Ve, T, H0] = LoadABSData('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
% Uncomment to validate the visualization
% [s1, s2] = size(Vn);
% Ve = 0.707 * (ones(s1, s2));
% Vn = 0.707 * (ones(s1, s2));

depthIndices = [1 2 3 4 5 6];
[Vn, Ve, H0] = ExtractDepths(Vn, Ve, H0, depthIndices);

rangeInterval = [ranges(1, 1), ranges(end, end)];
[Vn, Ve, T] = ExtractTimeInterval(Vn, Ve, T, rangeInterval);

CreateFigure(ax, Ve/500, Vn/500, T, H0, ranges, [0 0 1], [0.8 0.8 1.0], [0.9 0.9 0.9], screenCoef)

PutScaleVector(ax, screenCoef);

end
