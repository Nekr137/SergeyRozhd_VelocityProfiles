function task2_map
% The task from 2021-10-07
% Placed smoothing vectors on the MAP

% Adjust this vector to see different depth results
% Example 1: `depthIndices = [1 3 5];`
% Example 2: `depthIndices = 1:5;` (1:5 is equal to [1 2 3 4 5] vector
% Example 3: `depthIndices = -100:100;` (Extracting the all depths)
depthIndices = [1 4];

close all;

% Creating the intersting ranges
filename1 = 'DATA_000p.000';
filename2 = 'DATA_003p.000';

ranges1 = [
    [datenum('08/10/21 11:21') datenum('08/10/21 11:44')] % range 1
    [datenum('08/10/21 11:48') datenum('08/10/21 12:02')] % range 2
    [datenum('08/10/21 12:12') datenum('08/10/21 12:31')] % ...
    [datenum('08/10/21 12:43') datenum('08/10/21 12:59')]
    [datenum('08/10/21 13:09') datenum('08/10/21 13:22')]
    [datenum('08/10/21 13:32') datenum('08/10/21 13:48')]
    [datenum('08/10/21 13:57') datenum('08/10/21 14:15')]
    [datenum('08/10/21 14:46') datenum('08/10/21 14:54')]
];
ranges2 = [
    [datenum('08/11/21 11:09') datenum('08/11/21 11:22')]
    [datenum('08/11/21 11:30') datenum('08/11/21 11:44')]
    [datenum('08/11/21 11:53') datenum('08/11/21 12:08')]
    [datenum('08/11/21 12:14') datenum('08/11/21 12:26')]
    [datenum('08/11/21 12:32') datenum('08/11/21 12:35')]
    [datenum('08/11/21 13:00') datenum('08/11/21 13:11')]
    [datenum('08/11/21 13:19') datenum('08/11/21 13:30')]
    [datenum('08/11/21 13:45') datenum('08/11/21 13:53')]
];


[fig, coordinates] = LoadCoastLineMap();
ShowMap(fig, coordinates(1:8, :), depthIndices, filename1, ranges1);
ShowMap(fig, coordinates(9:16, :), depthIndices, filename2, ranges2);

% -------------------------------------------------------------------------
end

function ShowMap(fig, coordinates, depthIndices, filename, ranges) 

% Parsing the file
[Vn, Ve, T, H0] = LoadData(filename);

% Extracting this depth information only
[Ve, Vn, H0] = ExtractDepths(Ve, Vn, H0, depthIndices);
rangesCnt = length(ranges);

depthColors = [[1 0 0]; [0 0 1]; [0 1 0]; [1 1 0]; [1 0 1]; [1 1 0]];

for stationIdx = 1:rangesCnt 
    coo = coordinates(stationIdx, :); % station coordinate
    [stationVn, stationVe, stationT] = ExtractTimeInterval(Vn, Ve, T, ranges(stationIdx, :));
    
    for depthIdx = 1:length(H0)
        for timeIdx = 1:length(stationVn)
            ShowVectorOnMap(...
                fig, coo(1), coo(2),...
                stationVn(depthIdx, timeIdx),...
                stationVe(depthIdx, timeIdx),...
                [0.9 0.9 0.9]);
        end
    end
    
    % !nb: The `t` is a vector of size [depthCnt] like the vn or ve
    %      due to different positions of nan elements in each velocity
    %      array!
    [vn, ve, t] = smoothData(stationVn, stationVe, stationT);
    
    for depthIdx = 1:length(t)
        color = depthColors(min(depthIdx,length(depthColors)), :);
        ShowVectorOnMap(fig, coo(1), coo(2), vn(depthIdx), ve(depthIdx), color);
    end
end

end

function ShowVectorOnMap(fig, pe, pn, ve, vn, color)
ax = get(fig, 'Children');
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');

xdata = [pe pe+ve*diff(xlim)/3];
ydata = [pn pn+vn*diff(ylim)/3];

plot(xdata, ydata, 'LineWidth', 1.0, 'Color', color);

end

function v = cellOfStrings2num(c)
v = zeros(length(c), 1);
for k = 1:length(c)
   v(k) = str2num(cell2mat(c(k)));
end
end

function backConversion()
ax = get(fig, 'Children');
xtick = get(ax,'XTick');
ytick = get(ax,'YTick');
xlabel = cellOfStrings2num(get(ax,'XTickLabel'));
ylabel = cellOfStrings2num(get(ax,'YTickLabel'));

xK = mean(diff(xlabel)) ./ mean(diff(xtick));
yK = mean(diff(ylabel)) ./ mean(diff(ytick));
xB = xlabel(2) - xK * xtick(2);
yB = ylabel(2) - yK * ytick(2);
end