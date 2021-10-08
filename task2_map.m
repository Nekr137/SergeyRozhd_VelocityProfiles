function task2_map
% The task from 2021-10-07
% Placed smoothing vectors on the MAP

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

coordinates = [
  36.461407409553331  45.292780496454917
  36.480233063429758  45.276467442133175
  36.498251903568615  45.262193519601652
  36.518422247007642  45.244860899384797
  36.537516838796591  45.230077193905714
  36.553384175635287  45.212234790741313
  36.568444698736428  45.194392387576904
  36.586194600962770  45.178589116202716
  36.468668733191379  45.101611891121991
  36.484536070030082  45.106199937649976
  36.512236675019679  45.111297767125521
  36.531869142633660  45.114866247758407
  36.554459927285372  45.120983643129058
  36.578126463587161  45.125571689657050
  36.602061937801473  45.129140170289929
  36.623845908715616  45.133218433870368
];


fig = figure;
s1 = subplot(221);
s2 = subplot(222);
s3 = subplot(223);
s4 = subplot(224);

depth1 = 1;
depth2 = 4;

LoadCoastLineMap(s1);
title(['08/10/21, depth idx = ' num2str(depth1)]);
ShowMap(s1, coordinates(1:8, :), depth1, filename1, ranges1);

LoadCoastLineMap(s2);
title(['08/10/21, depth idx = ' num2str(depth2)]);
ShowMap(s2, coordinates(1:8, :), depth2, filename1, ranges1);

LoadCoastLineMap(s3);
title(['08/11/21, depth idx = ' num2str(depth1)]);
ShowMap(s3, coordinates(9:16, :), depth1, filename2, ranges2);

LoadCoastLineMap(s4);
title(['08/11/21, depth idx = ' num2str(depth2)]);
ShowMap(s4, coordinates(9:16, :), depth2, filename2, ranges2);

end

function ShowMap(ax, coordinates, depthIndices, filename, ranges) 

% Parsing the file
[Vn, Ve, T, H0] = LoadData(filename);

% Uncomment to check if visualization is correct
% [s1, s2] = size(Vn);
% Ve = 0.707 * (ones(s1, s2));
% Vn = 0.707 * (ones(s1, s2));

% Extracting this depth information only
[Ve, Vn, H0] = ExtractDepths(Ve, Vn, H0, depthIndices);
rangesCnt = length(ranges);

depthColors = [[1 0 0]; [0 0 1]; [0 1 0]; [1 1 0]; [1 0 1]; [1 1 0]];

for stationIdx = 1:rangesCnt 
    coo = coordinates(stationIdx, :); % station coordinate
    [stationVn, stationVe, stationT] = ExtractTimeInterval(Vn, Ve, T, ranges(stationIdx, :));
    
%     for depthIdx = 1:length(H0)
%         for timeIdx = 1:length(stationVn)
%             ShowVectorOnMap(...
%                 ax, coo(1), coo(2),...
%                 stationVe(depthIdx, timeIdx),...
%                 stationVn(depthIdx, timeIdx),...
%                 [0.9 0.9 0.9]);
%         end
%     end
    
    % !nb: The `t` is a vector of size [depthCnt] like the vn or ve
    %      due to different positions of nan elements in each velocity
    %      array!
    [vn, ve, t] = smoothData(stationVn, stationVe, stationT);
    
    for depthIdx = 1:length(t)
        color = depthColors(min(depthIdx,length(depthColors)), :);
        ShowVectorOnMap(ax, coo(1), coo(2), ve(depthIdx), vn(depthIdx), color);
    end
end

end

function ShowVectorOnMap(ax, pe, pn, ve, vn, color)
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
xdata = [pe pe+ve*diff(xlim)/3];
ydata = [pn pn+vn*diff(ylim)/3];
plot(ax, xdata, ydata, 'LineWidth', 0.3, 'Color', color);
end

