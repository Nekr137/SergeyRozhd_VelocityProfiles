function task_8_correlation()

%% (1)

% Loading the data
[Vn.wind, Ve.wind, T.wind, ~] = sr_load_task8('task_8_veter(copy).dat');

% Removing broken data - when time is zero
remIndices = find(T.wind < 1);
Vn.wind(remIndices) = [];
Ve.wind(remIndices) = [];
T.wind(remIndices) = [];

% Extracting the interesting time interval
% timeInterval = [datenum('2021-08-09, 20:41', 'yyyy-mm-dd, HH:MM') T.wind(end)];
timeInterval = [datenum('2021-08-09, 20:32', 'yyyy-mm-dd, HH:MM') T.wind(end)];
[Vn.windInterv, Ve.windInterv, T.windInterv] = sr_extract_time_interval(Vn.wind, Ve.wind, T.wind, timeInterval);

% Find mean values
w = 60 * 20;
n = length(T.windInterv);
cnt = ceil(n/w);

% wndm - wind mean
Vn.wndm = zeros(1, cnt);
Ve.wndm = zeros(1, cnt);
T.wndm = zeros(1, cnt);

for k = 1:cnt
   f = min(w * k + 1, n);
   s = f - w;
   Vn.wndm(k) = mean(Vn.windInterv(s:f)); 
   Ve.wndm(k) = mean(Ve.windInterv(s:f)); 
   T.wndm(k) = mean(T.windInterv(s:f)); 
end


%  V - north
%  U - east 

%% (2) Working with ABS(1/2) files

[Vn.abs1, Ve.abs1, T.abs1, H0.abs1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.abs1, Ve.abs1, H0.abs1] = sr_extract_depths(Vn.abs1, Ve.abs1, H0.abs1, [length(H0.abs1)]);
% Vn.abs1 = Vn.abs1 ./ 1000;
% Ve.abs1 = Ve.abs1 ./ 1000;
Vn.abs1 = Vn.abs1 ./ 500;
Ve.abs1 = Ve.abs1 ./ 500;


[Vn.abs2, Ve.abs2, T.abs2, H0.abs2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');
[Vn.abs2, Ve.abs2, H0.abs2] = sr_extract_depths(Vn.abs2, Ve.abs2, H0.abs2, [length(H0.abs2)]);
% Vn.abs2 = Vn.abs2 ./ 1000;
% Ve.abs2 = Ve.abs2 ./ 1000;
Vn.abs2 = Vn.abs2 ./ 50;
Ve.abs2 = Ve.abs2 ./ 50;
%      

%% Visualization of (1) and (2)
figure; 

ax1 = subplot(211);
hold on; box on; grid on;
plot(T.wind, Ve.wind, 'Marker', 'None', 'Color', [0.8 0.8 0.8]);
plot(T.wndm, Ve.wndm, 'k.-', T.abs1, Ve.abs1, 'r.-', T.abs2, Ve.abs2, 'b.-');
ylabel('Vn');
set(ax1, 'XLim', [T.wind(1) T.wind(end)]);
xlabel('Time');
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
legend('wind', 'wind mean', 'abs1', 'abs2');

ax2 = subplot(212);
hold on; box on; grid on;
plot(T.wind, Vn.wind, 'Marker', 'None', 'Color', [0.8 0.8 0.8]);
plot(T.wndm, Vn.wndm, 'k.-', T.abs1, Vn.abs1, 'r.-', T.abs2, Vn.abs2, 'b.-');
set(ax2, 'XLim', [T.wind(1) T.wind(end)]);
ylabel('Ve');
xlabel('Time');
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
legend('wind', 'wind mean', 'abs1', 'abs2');

%% (3)

tmin = max([T.abs1(1) T.abs2(1) T.wndm(1)]);
tmax = min([T.abs1(end) T.abs2(end) T.wndm(end)]);
interv = [tmin tmax];

[Vn.abs1, Ve.abs1, T.abs1] = sr_extract_time_interval(Vn.abs1, Ve.abs1, T.abs1, interv);
[Vn.abs2, Ve.abs2, T.abs2] = sr_extract_time_interval(Vn.abs2, Ve.abs2, T.abs2, interv);
[Vn.wndm, Ve.wndm, T.wndm] = sr_extract_time_interval(Vn.wndm, Ve.wndm, T.wndm, interv);

minLen = min([length(Vn.abs1) length(Vn.abs2) length(Vn.wndm)]);
Vn.abs1 = Vn.abs1(1:minLen);
Vn.abs2 = Vn.abs2(1:minLen);
Vn.wndm = Vn.wndm(1:minLen);
Ve.abs1 = Ve.abs1(1:minLen);
Ve.abs2 = Ve.abs2(1:minLen);
Ve.wndm = Ve.wndm(1:minLen);

% Smoothing ?
% lvl = 20;
% Vn.abs1 = smooth(Vn.abs1, lvl)';
% Vn.abs2 = smooth(Vn.abs2, lvl)';
% Vn.wndm = smooth(Vn.wndm, lvl)';
% Ve.abs1 = smooth(Ve.abs1, lvl)';
% Ve.abs2 = smooth(Ve.abs2, lvl)';
% Ve.wndm = smooth(Ve.wndm, lvl)';

lag = 100;

r.vn_abs1_wndm = sr_corr(Vn.abs1, Vn.wndm, lag);
r.vn_abs2_wndm = sr_corr(Vn.abs2, Vn.wndm, lag);
r.ve_abs1_wndm = sr_corr(Ve.abs1, Ve.wndm, lag);
r.ve_abs2_wndm = sr_corr(Ve.abs2, Ve.wndm, lag);
r.ve_abs1_vn_wndm = sr_corr(Ve.abs1, Vn.wndm, lag);
r.ve_abs2_vn_wndm = sr_corr(Ve.abs2, Vn.wndm, lag);
r.vn_abs1_ve_wndm = sr_corr(Vn.abs1, Ve.wndm, lag);
r.vn_abs2_ve_wndm = sr_corr(Vn.abs2, Ve.wndm, lag);

%% Visualisation of (3)
vv = -lag:lag;

figure;
function vis1(ax, xx, yy, xlab, ylab)
    axes(ax);
    plot(ax, xx, yy, 'k.');
    axis square; box on; grid on;
    xl = get(ax,'XLim'); yl = get(ax,'YLim');
    lim = [min(xl(1), yl(1)); max(xl(2), yl(2))];
    set(ax, 'XLim', lim); set(ax, 'YLim', lim);
    xlabel(xlab); ylabel(ylab);
end
subplot(421); vis1(gca, Vn.abs1, Vn.wndm, 'Vn abs1', 'Vn wind');
subplot(422); vis1(gca, Vn.abs2, Vn.wndm, 'Vn abs2', 'Vn wind');
subplot(423); vis1(gca, Ve.abs1, Ve.wndm, 'Ve abs1', 'Ve wind');
subplot(424); vis1(gca, Ve.abs2, Ve.wndm, 'Ve abs2', 'Ve wind');
subplot(425); vis1(gca, Ve.abs1, Vn.wndm, 'Ve abs1', 'Vn wind');
subplot(426); vis1(gca, Ve.abs2, Vn.wndm, 'Ve abs2', 'Vn wind');
subplot(427); vis1(gca, Vn.abs1, Ve.wndm, 'Vn abs1', 'Ve wind');
subplot(428); vis1(gca, Vn.abs2, Ve.wndm, 'Vn abs2', 'Ve wind');

figure;
function vis2(ax, xx, yy, lgnd)
    axes(ax);     plot(ax, xx, yy, 'k.-');
    xlabel('N = 1,2,3,...');     ylabel('r');
    box on;     grid on;
    set(ax,'YLim',[-1 1]);
    set(gca,'YTick', [-1.0 -0.6 0 0.6 1.0])
    legend(lgnd);
end
subplot(421); vis2(gca, vv, r.vn_abs1_wndm, 'Vn abs1 & Vn wind');
subplot(422); vis2(gca, vv, r.vn_abs2_wndm, 'Vn abs2 & Vn wind');
subplot(423); vis2(gca, vv, r.ve_abs1_wndm, 'Ve abs1 & Ve wind');
subplot(424); vis2(gca, vv, r.ve_abs2_wndm, 'Ve abs2 & Ve wind');
subplot(425); vis2(gca, vv, r.ve_abs1_vn_wndm, 'Ve abs1 & Vn wind');
subplot(426); vis2(gca, vv, r.ve_abs2_vn_wndm, 'Ve abs2 & Vn wind');
subplot(427); vis2(gca, vv, r.vn_abs1_ve_wndm, 'Vn abs1 & Ve wind');
subplot(428); vis2(gca, vv, r.vn_abs2_ve_wndm, 'Vn abs2 & Ve wind');

figure; vis2(gca, vv, sr_corr(Vn.abs1, Vn.abs1, lag), 'Vn abs1 & Vn abs1');
end