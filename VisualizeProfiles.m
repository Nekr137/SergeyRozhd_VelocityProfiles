function VisualizeProfiles(ranges, filename, figureHandler)

[Vn, Ve, T, H0] = LoadData(filename);

% ranges - data ranges like [ [from to] [from to] [from to] ]
% Vn(i,j) - north velocity vector
% Ve(i,j) - east velocity vector
% where i - depth, j - time
% T - time vector
% H0 - depth vector

figure(figureHandler);
hold on;

xlabel('Time');
ylabel('Depth');
box on;
grid on;
lenTime = length(T);
lenH0 = 4;
dH0 = H0(2)-H0(1);
YLim = [H0(1)-dH0 H0(lenH0)+dH0];
XLim = [T(1) T(lenTime)];
set(gca, 'YLim', YLim)
set(gca, 'XLim', XLim);
% ticks = XLim(1):0.4*(XLim(2)-XLim(1)):XLim(2);
% xticks(ticks);
% dateaxis('x',length(ticks));
%datetick('x','dd-mmm-yyyy HH:MM:SS');
datetick('x','HH:MM');
set(gca, 'XLim', XLim);

timeRange = T(lenTime) - T(1);
depthRange = YLim(2) - YLim(1);
unitVectorLengthOnScreen = 1 / lenH0 / 3;

for idxDepth = 1:lenH0
    disp(['idxDepth = ' num2str(idxDepth)]);
    h = H0(idxDepth);
    for idx = 1:lenTime
        t = T(idx);
        isInRange = IsInDaterange(t, ranges);
%         if (~isInRange)
%             continue;
%         end
        vn = Vn(idxDepth, idx);
        ve = Ve(idxDepth, idx);
        vnScreen = vn * timeRange * unitVectorLengthOnScreen;
        veScreen = ve * depthRange * unitVectorLengthOnScreen;
        if (isInRange)
            plot([t t+vnScreen], [h h+veScreen], 'r-');
        else
            plot([t t+vnScreen], [h h+veScreen], 'Color', [0.9 0.9 0.9]);
        end
    end
    figure(gcf);
end
% i = find(t > datenum('10-Aug-2021 11:48:00'), 1);
% plot(Vn(:,i),-H0,'-r');set(gca,'ydir','reverse');

end

function isInRange = IsInDaterange(date, ranges)
isInRange = 0;
for idx = 1:length(ranges)
    range = ranges(idx, :);
    if date >  range(1) && date < range(2)
        isInRange = 1;
        break;
    end
end
end