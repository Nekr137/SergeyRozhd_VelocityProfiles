function task_8_correlation()

% (1)

% Loading the data
[Vn, Ve, T, H0] = sr_load_task8('task_8_veter(copy).dat');

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
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
grid on;

ax2 = subplot(212);
plot(T, Vn, 'b.', Tmean, Vnmean, 'r.-');
set(ax2, 'XLim', [T(1) T(end)]);
ylabel('Ve');
xlabel('Time');
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
grid on;



% (2) Working with ABS(1/2) files

[Vn, Ve, T, H0] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, [1 length(H0)]);
Vn1 = Vn./1000; Ve1 = Ve./1000;

[Vn, Ve, T, H0] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, [1 length(H0)]);
Vn2 = Vn./1000; Ve2 = Ve./1000;
     
end