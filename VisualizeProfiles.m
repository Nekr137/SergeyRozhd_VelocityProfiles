function VisualizeProfiles(figureHandler, Vn, Ve, T, H0, color)

UNIT_VECTOR_LENGTH_ON_SCREEN = 1 / length(H0) / 2;

ax = get(figureHandler, 'Children'); % getting the axis of the figure
timeRange  = diff(get(ax,'XLim'));   % time range coefficient
depthRange = diff(get(ax,'YLim'));   % depth range coefficient

for idxDepth = 1:length(H0) % depth cycle
    for idx = 1:length(T)     % time cycle
        h = H0(idxDepth);
        t = T(idx);
        vn = Vn(idxDepth, idx);
        ve = Ve(idxDepth, idx);
        if (isnan(vn) || isnan(ve)) % if the vn or ve is NAN -> continue
            continue;
        end
        % Finding the coordinate of vectors on the Depth(Time) picture
        vnScreen = vn * depthRange * UNIT_VECTOR_LENGTH_ON_SCREEN;
        veScreen = ve * timeRange  * UNIT_VECTOR_LENGTH_ON_SCREEN;
        xCoordinates = [t t+veScreen];
        yCoordinates = [h h-vnScreen]; % The '-' sign is here because of the reversed depth axis
        plot(xCoordinates, yCoordinates, 'Color', color); % Show vector
    end
    figure(figureHandler); % Made figure active to update and see the progress
end
end
