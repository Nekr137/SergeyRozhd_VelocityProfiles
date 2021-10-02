function VisualizeProfiles(ranges, filename, figureHandler)

[Vn, Ve, T, H0] = LoadData(filename);

% ranges - data ranges like [ [from to] [from to] [from to] ]
% Vn(i,j) - north velocity vector
% Ve(i,j) - east velocity vector
% where i - depth, j - time
% T - time vector
% H0 - depth vector

% Adjust this vector to see different depth results
% Example 1: `depthIndices = 1:length(H0);`
% Example 2: `depthIndices = 1:5;`
% Example 3: `depthIndices = [1 3 5];`
depthIndices = [1 4];


figure(figureHandler);
hold on;
sz = get(0, 'ScreenSize');
set(figureHandler, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]);
axis square;
xlabel('Time');
ylabel('Depth');
box on;
grid on;
lenTime = length(T);
lenH0 = length(depthIndices);
dH0 = min(diff(H0));
YLim = [H0(depthIndices(1))-dH0 H0(depthIndices(end))+dH0];
XLim = [T(1) T(lenTime)];
set(gca, 'YLim', YLim)
set(gca, 'XLim', XLim);
datetick('x','HH:MM');
set(gca, 'XLim', XLim);
set(gca, 'YDir', 'reverse');

timeRange = T(lenTime) - T(1);
depthRange = YLim(2) - YLim(1);
unitVectorLengthOnScreen = 1 / lenH0 / 2;

for idxDepth = depthIndices
    disp(['idxDepth = ' num2str(idxDepth)]);
    h = H0(idxDepth);
    for idx = 1:lenTime
        t = T(idx);
        vn = Vn(idxDepth, idx);
        ve = Ve(idxDepth, idx);
        if (isnan(vn) || isnan(ve))
            continue;
        end
        vnScreen = vn * timeRange * unitVectorLengthOnScreen;
        veScreen = ve * depthRange * unitVectorLengthOnScreen;
        isInRange = IsInDaterange(t, ranges);
        if (isInRange)
            plot([t t+vnScreen], [h h+veScreen], 'r-');
        else
            plot([t t+vnScreen], [h h+veScreen], 'Color', [0.9 0.9 0.9]);
        end
    end
    figure(figureHandler);
end
end

function isInRange = IsInDaterange(date, ranges)
isInRange = 0;
for idx = 1:length(ranges)
    range = ranges(idx, :);
    if date >= range(1) && date <= range(2)
        isInRange = 1;
        break;
    end
end
end