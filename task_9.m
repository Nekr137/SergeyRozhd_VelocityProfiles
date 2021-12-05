function task_9

[Vn.ABS1, Ve.ABS1, T.ABS1, H0.ABS1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.ABS2, Ve.ABS2, T.ABS2, H0.ABS2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');

step.ABS1 = 80.0;
step.ABS2 = 20.0;

timeLim = [
    max([T.ABS1(1) T.ABS2(1)])
    min([T.ABS1(end) T.ABS2(end)])
];

fig = figure;
sz = get(0, 'ScreenSize'); % Getting your screen size
set(fig, 'Position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size
ax(1) = subplot(511);
ax(2) = subplot(512);
ax(3) = subplot(513);
ax(4) = subplot(514);
ax(5) = subplot(515);
buildContourPlot(ax(2), T.ABS1, timeLim, Vn.ABS1, H0.ABS1, step.ABS1, 'ABS1, U-component');
buildContourPlot(ax(3), T.ABS1, timeLim, Ve.ABS1, H0.ABS1, step.ABS1, 'ABS1, V-component');
buildContourPlot(ax(4), T.ABS2, timeLim, Vn.ABS2, H0.ABS2, step.ABS2, 'ABS2, U-component');
buildContourPlot(ax(5), T.ABS2, timeLim, Ve.ABS2, H0.ABS2, step.ABS2, 'ABS2, V-component');

colormap default

%% Time interval

% Loading the data
[Vn.wind, Ve.wind, T.wind, ~] = sr_load_task8('task_8_veter(copy).dat');

% Removing broken data - when time is zero
remIndices = find(T.wind < 1);
Vn.wind(remIndices) = [];
Ve.wind(remIndices) = [];
T.wind(remIndices) = [];
H0.wind = [1];

% Extracting the interesting time interval
% windTimeInterval = [datenum('2021-08-09, 20:41', 'yyyy-mm-dd, HH:MM') T.wind(end)];
% windTimeInterval = [datenum('2021-08-09, 20:32', 'yyyy-mm-dd, HH:MM') T.wind(end)];
[Vn.windInterv, Ve.windInterv, T.windInterv] = sr_extract_time_interval(Vn.wind, Ve.wind, T.wind, timeLim);

% Find mean values
w = 60 * 40;
Vn.wndm = sr_find_average_data(Vn.windInterv, w); 
Ve.wndm = sr_find_average_data(Ve.windInterv, w); 
T.wndm  = sr_find_average_data(T.windInterv, w); 

axes(ax(1));
hold on; box on; grid on;
set(ax(1),'YLim', [0 2.0]);
set(ax(1),'XLim', timeLim);
set(ax(1), 'YDir', 'reverse'); % Made y axis reversed

% screenCoef = 1 / length(H0) / 10;
screenCoef = 1.0 / 30.0;
xyScreenRatio = 10.0;
sr_visualize_profiles(ax(1), Vn.wndm, Ve.wndm, T.wndm, H0.wind, [1 0 0], screenCoef, xyScreenRatio);
sr_put_scale_vector(ax(1), screenCoef, xyScreenRatio,'task9Style');
datetick(ax(1),'x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
xlabel(ax(1),'Velocity, mm/sec');
set(ax(1),'YGrid','off');
set(ax(1),'YTick',[])

% Other subplots has colorbars so
% to keep time axis equal we need to
% adjust the position (width and height)
% of the first axes.
% Also, we need to update the position if
% the figure has resized.
ax1pos = get(ax(1),'Position');
ax2pos = get(ax(2),'Position');
set(ax(1), 'Position', [ax1pos(1:2) ax2pos(3:4)])

sr_save_figure(fig, 'task_9.tif');
end

function buildContourPlot(ax, T, timeLim, V, H, levelStep, titl)
% @param [in] ax - axes
% @param [in] T  - time vector
% @param [in] timeLim - [tLim0 tLim1]
% @param [in] V  - velocity component
% @param [in] H  - depth
% @param [in] levelStep - how frequencly lines will appeared
% @param [in] titl - title

[M,c] = contourf(ax,T,H,V);
set(c,'ShowText','on');
% c.LineWidth = 0.01;
set(c,'EdgeColor',[0.5 0.5 0.5]);
set(c,'LevelStep',levelStep);
title(ax,titl,'FontSize',8,'FontWeight','normal');
ylabel(ax,'Depth, m');
xlabel(ax,'Velocity, mm/sec');
colorbar(ax);
caxis(ax,[-200 200]);
set(ax,'XLim', timeLim);
set(ax, 'YDir', 'reverse');
datetick(ax,'x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
end