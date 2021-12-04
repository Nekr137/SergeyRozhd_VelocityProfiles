function sr_visualize_profiles(ax, Vn, Ve, T, H0, color, screenCoef, xyScreenRatio)
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
        vnScreen = vn * depthRange * screenCoef;
        veScreen = ve * timeRange  * screenCoef;
        if exist('xyScreenRatio', 'var')
            vnScreen = xyScreenRatio * vnScreen;
        end
        xCoordinates = [t t+veScreen];
        yCoordinates = [h h-vnScreen]; % The '-' sign is here because of the reversed depth axis
        plot(xCoordinates, yCoordinates, 'Color', color); % Show vector
        plot(xCoordinates(1), yCoordinates(1), 'Color', color, 'Marker', '.');
    end
end
end
