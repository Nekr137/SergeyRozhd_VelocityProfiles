function task

% -------------------------------------------------------------------------

ranges1 = [
    [datenum('08/10/21 11:21') datenum('08/10/21 11:44')]
    [datenum('08/10/21 11:48') datenum('08/10/21 12:02')]
    [datenum('08/10/21 12:12') datenum('08/10/21 12:31')]
    [datenum('08/10/21 12:43') datenum('08/10/21 12:59')]
    [datenum('08/10/21 13:09') datenum('08/10/21 13:22')]
    [datenum('08/10/21 13:32') datenum('08/10/21 13:48')]
    [datenum('08/10/21 13:57') datenum('08/10/21 14:15')]
    [datenum('08/10/21 14:46') datenum('08/10/21 14:54')]
];
fig1 = figure;
VisualizeProfiles(ranges1, 'DATA_000p.000', fig1);
VisualizeRanges(fig1, ranges1);
AddStationLabels(fig1, ranges1, {'st(1)', 'st(2)', 'st2', 'st3', 'st4', 'st5', 'st6', 'st7', 'st8'});
title('08/10/21');

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
VisualizeProfiles(ranges2, 'DATA_003p.000', fig2);
VisualizeRanges(gcf, ranges2);
AddStationLabels(gcf, ranges2, {'stn16', 'stn17', 'stn18', 'stn19', 'stn20', 'stn21', 'stn22', 'stn23'});
title('08/11/21');

% -------------------------------------------------------------------------
end

