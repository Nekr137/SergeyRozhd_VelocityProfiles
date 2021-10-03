function task

% Adjust this vector to see different depth results
% Example 1: `depthIndices = [1 3 5];`
% Example 2: `depthIndices = 1:5;` (1:5 is equal to [1 2 3 4 5] vector
% Example 3: `depthIndices = -100:100;` (Extracting the all depths)
depthIndices = [1 4];


% -------------------------------------------------------------------------

% Creating the intersting ranges
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
fig1 = figure;                                                   % Creating the empty figure
VisualizeProfiles(ranges1, 'DATA_000p.000', fig1, depthIndices); % Running the VisualizeProfiles() function
VisualizeRanges(fig1, ranges1);                                  % Running the VisualizeRanges()   function
AddStationLabels(fig1, ranges1, {'st(1)', 'st(2)', 'st2', 'st3', 'st4', 'st5', 'st6', 'st7', 'st8'}); % Adding the labels
title('08/10/21'); % Put title

% -------------------------------------------------------------------------

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
fig2 = figure;
VisualizeProfiles(ranges2, 'DATA_003p.000', fig2, depthIndices);
VisualizeRanges(gcf, ranges2);
AddStationLabels(gcf, ranges2, {'stn16', 'stn17', 'stn18', 'stn19', 'stn20', 'stn21', 'stn22', 'stn23'});
title('08/11/21');

% -------------------------------------------------------------------------
end

