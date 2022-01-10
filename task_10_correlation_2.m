function task_10_correlation_2

% Loading the data
[Vn.wind, Ve.wind, T.wind, ~] = sr_load_task8('task_8_veter(copy).dat');

% Removing the broken data - when time is zero
remIndices = find(T.wind < 1);
Vn.wind(remIndices) = [];
Ve.wind(remIndices) = [];
T.wind(remIndices) = [];

% Extracting the interesting time interval
% ??? startTime = datenum('2021-08-09, 20:32', 'yyyy-mm-dd, HH:MM');
startTime = datenum('2021-08-09, 20:41', 'yyyy-mm-dd, HH:MM'); 
timeInterval = [startTime T.wind(end)];
[Vn.windInterv, Ve.windInterv, T.windInterv] = sr_extract_time_interval(Vn.wind, Ve.wind, T.wind, timeInterval);

w = 60 * 20;
Vn.wndm = sr_find_average_data(Vn.windInterv, w); 
Ve.wndm = sr_find_average_data(Ve.windInterv, w); 
T.wndm  = sr_find_average_data(T.windInterv, w);

Cd = 0.001;
Vn.windTau = Vn.wndm * Cd;
Ve.windTau = Ve.wndm * Cd;
T.windTau = T.wndm;

%  V - north
%  U - east 

%% (2) Working with ABS(1/2) files

[Vn.abs1, Ve.abs1, T.abs1, H0.abs1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.abs1, Ve.abs1, H0.abs1] = sr_extract_depths(Vn.abs1, Ve.abs1, H0.abs1, [length(H0.abs1)]);
% Vn.abs1 = Vn.abs1 ./ 1000;
% Ve.abs1 = Ve.abs1 ./ 1000;
% Vn.abs1 = Vn.abs1 ./ 500;
% Ve.abs1 = Ve.abs1 ./ 500;


[Vn.abs2, Ve.abs2, T.abs2, H0.abs2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');
[Vn.abs2, Ve.abs2, H0.abs2] = sr_extract_depths(Vn.abs2, Ve.abs2, H0.abs2, [length(H0.abs2)]);
% Vn.abs2 = Vn.abs2 ./ 1000;
% Ve.abs2 = Ve.abs2 ./ 1000;
% Vn.abs2 = Vn.abs2 ./ 50;
% Ve.abs2 = Ve.abs2 ./ 50;
%      

%% Visualization of (1) and (2)
figure; 

ax1 = subplot(211);
hold on; box on; grid on;
plot(T.wind, Ve.wind, 'Marker', 'None', 'Color', [0.8 0.8 0.8]);
plot(T.windTau, Ve.windTau * 1e3, 'k.-', T.abs1, Ve.abs1 * 1e-3, 'r.-', T.abs2, Ve.abs2 * 1e-1, 'b.-');
ylabel('U');
set(ax1, 'XLim', [T.wind(1) T.wind(end)]);
xlabel('Time');
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
legend('wind', '\tau [N/m^2] x 1000', 'V_{abs1} [m/s] x 0.001', 'V_{abs2} [m/s] x 0.1');

ax2 = subplot(212);
hold on; box on; grid on;
plot(T.wind, Vn.wind, 'Marker', 'None', 'Color', [0.8 0.8 0.8]);
plot(T.windTau, Vn.windTau * 1e3, 'k.-', T.abs1, Vn.abs1 * 1e-3, 'r.-', T.abs2, Vn.abs2 * 1e-1, 'b.-');
set(ax2, 'XLim', [T.wind(1) T.wind(end)]);
ylabel('V');
xlabel('Time');
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
legend('wind', '\tau [N/m^2] x 1000', 'V_{abs1} [m/s] x 0.001', 'V_{abs2} [m/s] x 0.1');

%% Finding of the set of correlation coeffitients.

tmin = max([T.abs1(1) T.abs2(1) T.windTau(1)]);
tmax = min([T.abs1(end) T.abs2(end) T.windTau(end)]);
interv = [tmin tmax];

[Vn.abs1, Ve.abs1, T.abs1] = sr_extract_time_interval(Vn.abs1, Ve.abs1, T.abs1, interv);
[Vn.abs2, Ve.abs2, T.abs2] = sr_extract_time_interval(Vn.abs2, Ve.abs2, T.abs2, interv);
[Vn.windTau, Ve.windTau, T.windTau] = sr_extract_time_interval(Vn.windTau, Ve.windTau, T.windTau, interv);

minLen = min([length(Vn.abs1) length(Vn.abs2) length(Vn.windTau)]);
Vn.abs1 = Vn.abs1(1:minLen);
Vn.abs2 = Vn.abs2(1:minLen);
Vn.windTau = Vn.windTau(1:minLen);
Ve.abs1 = Ve.abs1(1:minLen);
Ve.abs2 = Ve.abs2(1:minLen);
Ve.windTau = Ve.windTau(1:minLen);

% Smoothing ?
% lvl = 20;
% Vn.abs1 = smooth(Vn.abs1, lvl)';
% Vn.abs2 = smooth(Vn.abs2, lvl)';
% Vn.windTau = smooth(Vn.windTau, lvl)';
% Ve.abs1 = smooth(Ve.abs1, lvl)';
% Ve.abs2 = smooth(Ve.abs2, lvl)';
% Ve.windTau = smooth(Ve.windTau, lvl)';

lag = 100;

r.vn_abs1_tau_n = sr_corr(Vn.abs1, Vn.windTau, lag);
r.vn_abs2_tau_n = sr_corr(Vn.abs2, Vn.windTau, lag);
r.ve_abs1_tau_e = sr_corr(Ve.abs1, Ve.windTau, lag);
r.ve_abs2_tau_e = sr_corr(Ve.abs2, Ve.windTau, lag);
r.ve_abs1_tau_n = sr_corr(Ve.abs1, Vn.windTau, lag);
r.ve_abs2_tau_n = sr_corr(Ve.abs2, Vn.windTau, lag);
r.vn_abs1_tau_e = sr_corr(Vn.abs1, Ve.windTau, lag);
r.vn_abs2_tau_e = sr_corr(Vn.abs2, Ve.windTau, lag);

%% Visualisation of (3)

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
subplot(421); vis1(gca, Vn.abs1, Vn.windTau, 'Vn abs1', '\tau_n');
subplot(422); vis1(gca, Vn.abs2, Vn.windTau, 'Vn abs2', '\tau_n');
subplot(423); vis1(gca, Ve.abs1, Ve.windTau, 'Ve abs1', '\tau_e');
subplot(424); vis1(gca, Ve.abs2, Ve.windTau, 'Ve abs2', '\tau_e');
subplot(425); vis1(gca, Ve.abs1, Vn.windTau, 'Ve abs1', '\tau_n');
subplot(426); vis1(gca, Ve.abs2, Vn.windTau, 'Ve abs2', '\tau_n');
subplot(427); vis1(gca, Vn.abs1, Ve.windTau, 'Vn abs1', '\tau_e');
subplot(428); vis1(gca, Vn.abs2, Ve.windTau, 'Vn abs2', '\tau_e');

figure;
function vis2(ax, xx, yy, lgnd)
	mid = round(length(xx) / 2);		
	xx = xx(mid:end);
	yy = yy(mid:end);
    axes(ax);     plot(ax, xx, yy, 'k.-');
    xlabel('Time');     ylabel('r');
    datetick(ax,'x', 'mm/dd HH:MM','keeplimits', 'keepticks');
    set(ax,'XTickMode','auto');
    set(ax,'XLimMode','auto');
    box on;     grid on;
    set(ax,'YLim',[-1 1]);
    set(gca,'YTick', [-1.0 -0.6 0 0.6 1.0])
    legend(lgnd);
end
oneMin = datenum('00:41', 'HH:MM') - datenum('00:40', 'HH:MM');
xx = startTime + oneMin * [-lag:lag];
subplot(421); vis2(gca, xx, r.vn_abs1_tau_n, 'Vn abs1 & \tau_n');
subplot(422); vis2(gca, xx, r.vn_abs2_tau_n, 'Vn abs2 & \tau_n');
subplot(423); vis2(gca, xx, r.ve_abs1_tau_e, 'Ve abs1 & \tau_e');
subplot(424); vis2(gca, xx, r.ve_abs2_tau_e, 'Ve abs2 & \tau_e');
subplot(425); vis2(gca, xx, r.ve_abs1_tau_n, 'Ve abs1 & \tau_n');
subplot(426); vis2(gca, xx, r.ve_abs2_tau_n, 'Ve abs2 & \tau_n');
subplot(427); vis2(gca, xx, r.vn_abs1_tau_e, 'Vn abs1 & \tau_e');
subplot(428); vis2(gca, xx, r.vn_abs2_tau_e, 'Vn abs2 & \tau_e');

figure; vis2(gca, xx, sr_corr(Vn.abs1, Vn.abs1, lag), 'Vn abs1 & Vn abs1');
end
