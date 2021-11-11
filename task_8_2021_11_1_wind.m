function task_8_2021_11_1_wind()

% Loading the data
[Vn, Ve, T, H0] = sr_load_task8('2021-11-07_attachments\task_8_veter(copy).dat');

% Extracting the interesting time interval
tstart = datenum('2021-08-09, 20:41', 'yyyy-mm-dd, HH:MM');
tend = T(end);
timeInterval = [tstart tend];
[Vn1, Ve1, T1] = sr_extract_time_interval(Vn, Ve, T, timeInterval);

% Find mean values
w = 60 * 20;
n = length(T1);
cnt = ceil(n/w);

Vnmean = zeros(cnt, 1);
Vemean = zeros(cnt, 1);
Tmean = zeros(cnt, 1);

for k = 1:cnt
   f = min(w * k + 1, n);
   s = f - w;
   Vnmean(k) = mean(Vn1(s:f)); 
   Vemean(k) = mean(Ve1(s:f)); 
   Tmean(k) = mean(T1(s:f)); 
end

% Visualization
figure; 

ax1 = subplot(211);
plot(T, Ve, 'b.', Tmean, Vemean, 'r.-');
ylabel('Vn');
set(ax1, 'XLim', [T(1) T(end)]);
xlabel('Time');
datetick('x','mm/dd HH:MM', 'keeplimits', 'keepticks');
grid on;

ax2 = subplot(212);
plot(T, Vn, 'b.', Tmean, Vnmean, 'r.-');
set(ax2, 'XLim', [T(1) T(end)]);
ylabel('Ve');
xlabel('Time');
datetick('x','mm/dd HH:MM', 'keeplimits', 'keepticks');
grid on;


end