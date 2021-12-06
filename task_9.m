function task_9

[Vn.ABS1, Ve.ABS1, T.ABS1, H0.ABS1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.ABS2, Ve.ABS2, T.ABS2, H0.ABS2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');

step.ABS1 = 120.0;
step.ABS2 = 40.0;

timeLim = [
    min([T.ABS1(1) T.ABS2(1)])
    max([T.ABS1(end) T.ABS2(end)])
];

fig = figure;
% sz = get(0, 'ScreenSize'); % Getting your screen size
% set(fig, 'Position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size
% set(gcf,'Position', [1367 -271 1920 963]);
% set(gcf,'Position',[1 41 1366 651]);

ax(1) = subplot(511);
ax(2) = subplot(512);
ax(3) = subplot(513);
ax(4) = subplot(514);
ax(5) = subplot(515);

% Used the getHeight(), setHeight() and moveVertically() to adjust the position
gap = 0.06;
p5 = 0.05;
h45 = 0.095;
h23 = h45 * 2.0;
h01 = h45;
p4 = p5+h45+gap;
p3 = p4+h45+gap;
p2 = p3+h23+gap;
p1 = p2+h23+gap;


set(ax(1),'Position',[0.1300    p1    0.7444    h01]);
set(ax(2),'Position',[0.1300    p2    0.7444    h23]);
set(ax(3),'Position',[0.1300    p3    0.7444    h23]);
set(ax(4),'Position',[0.1300    p4    0.7444    h45]);
set(ax(5),'Position',[0.1300    p5    0.7444    h45]);

buildContourPlot(ax(2), T.ABS1, timeLim, Vn.ABS1, H0.ABS1, step.ABS1, 'ABS1, U-component');
buildContourPlot(ax(3), T.ABS1, timeLim, Ve.ABS1, H0.ABS1, step.ABS1, 'ABS1, V-component');
buildContourPlot(ax(4), T.ABS2, timeLim, Vn.ABS2, H0.ABS2, step.ABS2, 'ABS2, U-component');
buildContourPlot(ax(5), T.ABS2, timeLim, Ve.ABS2, H0.ABS2, step.ABS2, 'ABS2, V-component');

colormap redbluecmap

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
screenCoef = 1.0 / 130.0;
pp1 = get(ax(1),'Position');
pp2 = get(fig,'Position');
xyScreenRatio = pp1(3) / pp1(4) * pp2(3) / pp2(4);
sr_visualize_profiles(ax(1), Vn.wndm, Ve.wndm, T.wndm, H0.wind, [1 0 0], screenCoef, xyScreenRatio);
sr_put_scale_vector(ax(1), screenCoef, xyScreenRatio,'task9Style');
datetick(ax(1),'x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
xlabel(ax(1),'Velocity, mm/s');
ylabel(ax(1),'\tau, N/m^2','FontSize',11)
set(ax(1),'YGrid','off');
set(ax(1),'YTick',[])

axes(ax(1));
colorbar;
set(colorbar,'visible','off');

% sr_save_figure(fig,'task_9.jpeg');

end



function buildContourPlot(ax, T, timeLim, V, H, levelStep, titl)
% @param [in] ax - axes
% @param [in] T  - time vector
% @param [in] timeLim - [tLim0 tLim1]
% @param [in] V  - velocity component
% @param [in] H  - depth
% @param [in] levelStep - how frequencly lines will appeared
% @param [in] titl - title

conversionCoef = 1e-3; % from mm to meters

[M,c] = contourf(ax,T,H,V .* conversionCoef);
set(c,'ShowText','on');
set(c, 'LineWidth', 1e-5);
set(c,'EdgeColor',[0.5 0.5 0.5]);
set(c,'LevelStep',levelStep * conversionCoef);
set(c,'TextStep',levelStep/2 * conversionCoef);
clabel([],c,'Color','k','FontSize',6,'LabelSpacing',2000,'EdgeColor','none');

title(ax,titl,'FontSize',8,'FontWeight','bold');
ylabel(ax,'Depth, m');
xlabel(ax,'Velocity, m/s');
colorbar(ax);
caxis(ax,[-200.0 200.0] .* conversionCoef);
set(ax,'XLim', timeLim);
set(ax,'YDir', 'reverse');
set(ax,'YGrid','on');
yl = get(ax,'YLim');
set(ax,'YTick',[yl(1):0.5:yl(2)]);
datetick(ax,'x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
set(ax,'FontSize',9);
end

function setHeight(ax,height)
    pos = get(ax,'Position');
    pos(4) = height;
    set(ax,'Position',pos);
end

function height = getHeight(ax)
    pos = get(ax,'Position');
    height = pos(4);
end

function moveVertically(ax, dist)
    pos = get(ax,'Position');
    pos(2) = pos(2) + dist;
    set(ax,'Position',pos);
end