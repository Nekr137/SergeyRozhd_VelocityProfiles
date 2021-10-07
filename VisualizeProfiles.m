function VisualizeProfiles(ranges, filename, figureHandler, depthIndices)
% ranges - data ranges like [ [from to] [from to] [from to] ]
% Vn(i,j) - north velocity vector
% Ve(i,j) - east velocity vector
% where i - depth, j - time
% T - time vector
% H0 - depth vector

[Vn, Ve, T, H0] = LoadData(filename);        % Parsing the file

% Check if depth indices are bigger or smaller then it should be
[~, existingIndices] = find(depthIndices <= length(H0) & depthIndices >=1);
depthIndices = depthIndices(existingIndices);

figure(figureHandler);     % Made specified (created previously) figure active.
hold on;                   % Enabled not removing the old lines if new one is created.
sz = get(0, 'ScreenSize'); % Getting your screen size
set(figureHandler, 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size
axis square;               % Made axis squared
xlabel('Time'); ylabel('Depth'); % Axis labels
box on; grid on;           % Enabling the box (a rectangle around the grapth) and enabling the grid

% Calculate and set the limits of axis
dH0 = min(diff(H0));
YLim = [H0(depthIndices(1))-dH0 H0(depthIndices(end))+dH0];
XLim = [T(1) T(length(T))];
set(gca, 'YLim', YLim)
set(gca, 'XLim', XLim);
datetick('x','HH:MM');
set(gca, 'XLim', XLim);
set(gca, 'YDir', 'reverse'); % Made y axis reversed

% Calculating some variables for conversion of vector sizes.
timeRange = T(length(T)) - T(1);
depthRange = YLim(2) - YLim(1);
unitVectorLengthOnScreen = 1 / length(depthIndices) / 2;

for idxDepth = depthIndices % depth cycle
    disp(['idxDepth = ' num2str(idxDepth)]); % Show idxDepth in the command window
    h = H0(idxDepth);
    for idx = 1:length(T) % time cycle
        t = T(idx);
        vn = Vn(idxDepth, idx);
        ve = Ve(idxDepth, idx);
        if (isnan(vn) || isnan(ve)) % if the vn or ve is NAN -> continue
            continue;
        end
        % Finding the coordinate of vectors on the Depth(Time) picture
        vnScreen = vn * depthRange * unitVectorLengthOnScreen;
        veScreen = ve * timeRange  * unitVectorLengthOnScreen;
        isInRange = IsInDaterange(t, ranges);
        xCoordinates = [t t+veScreen];
        yCoordinates = [h h-vnScreen]; % The '-' sign is here because of the reversed depth axis
        if isInRange
            color = [1 0 0]; 
        else
            color = [0.9 0.9 0.9];
        end
        plot(xCoordinates, yCoordinates, 'Color', color); % Show vector
    end
    figure(figureHandler); % Made figure active to update and see the progress
end
end
