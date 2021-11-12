function task_8_correlation()

%% (1)

% Loading the data
[Vn.wind, Ve.wind, T.wind, ~] = sr_load_task8('task_8_veter(copy).dat');

% Extracting the interesting time interval
timeInterval = [datenum('2021-08-09, 20:41', 'yyyy-mm-dd, HH:MM') T.wind(end)];
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

ax1 = subplot(311);
hold on; box on; grid on;
plot(T.wind, Ve.wind, 'Marker', 'None', 'Color', [0.8 0.8 0.8]);
plot(T.wndm, Ve.wndm, 'k.-', T.abs1, Ve.abs1, 'r.-', T.abs2, Ve.abs2, 'b.-');
ylabel('Vn');
set(ax1, 'XLim', [T.wind(1) T.wind(end)]);
xlabel('Time');
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
legend('wind', 'wind mean', 'abs1', 'abs2');

ax2 = subplot(312);
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

assert(length(Vn.abs1) == length(Vn.abs2), '[ ! ] Check your data, length must be equal');
assert(length(Vn.abs1) == length(Vn.wndm), '[ ! ] Check your data, length must be equal');

r.vn_abs1_wndm = sr_corr(Vn.abs1, Vn.wndm);
r.vn_abs2_wndm = sr_corr(Vn.abs2, Vn.wndm);
r.ve_abs1_wndm = sr_corr(Ve.abs1, Ve.wndm);
r.ve_abs2_wndm = sr_corr(Ve.abs2, Ve.wndm);

%% Visualisation of (3)
ax3 = subplot(325); hold on; box on; grid on;
vv = 1:length(r.vn_abs1_wndm);
plot(vv, r.vn_abs1_wndm, 'r.');
plot(vv, r.vn_abs2_wndm, 'b.');
xlabel('N = 1,2,3,...');
ylabel('r');
legend('abs1-wind', 'abs2-wind');
title('Vn');

ax4 = subplot(326); hold on; box on; grid on;
plot(vv, r.ve_abs1_wndm, 'r.');
plot(vv, r.ve_abs2_wndm, 'b.');
xlabel('N = 1,2,3,...');
ylabel('r');
legend('abs1-wind', 'abs2-wind');
title('Ve');
end