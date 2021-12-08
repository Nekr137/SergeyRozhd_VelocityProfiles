function task_9

[Vn.ABS1, Ve.ABS1, T.ABS1, H0.ABS1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.ABS2, Ve.ABS2, T.ABS2, H0.ABS2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');

abs2Interval = [datenum('2021-08-10, 04:00', 'yyyy-mm-dd, HH:MM') T.ABS2(end)];
[Vn.ABS2, Ve.ABS2, T.ABS2] = sr_extract_time_interval(Vn.ABS2, Ve.ABS2, T.ABS2, abs2Interval);

ABS2_SCALE = 10.0;
Vn.ABS2 = Vn.ABS2 * ABS2_SCALE;
Ve.ABS2 = Ve.ABS2 * ABS2_SCALE;

% Wind
[Vn.wind, Ve.wind, T.wind, ~] = sr_load_task8('task_8_veter(copy).dat');

step.ABS1 = 120.0;
step.ABS2 = 40.0;

timeLim = [
    min([T.ABS1(1) T.ABS2(1) T.wind(1)])
    max([T.ABS1(end) T.ABS2(end) T.wind(end)])
];

fig = figure;
% sz = get(0, 'ScreenSize'); % Getting your screen size
% set(fig, 'Position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]); % Setting the figure size
set(gcf,'Position', [1367 -271 1920 963]);
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

abs1barLim = 400;
abs2barLim = 400;
buildContourPlot(ax(2), T.ABS1, timeLim, Vn.ABS1, H0.ABS1, step.ABS1, 'ABS1, U-component',20,abs1barLim);
buildContourPlot(ax(4), T.ABS2, timeLim, Vn.ABS2, H0.ABS2, step.ABS2, 'ABS2, U-component',5,abs2barLim);
buildContourPlot(ax(3), T.ABS1, timeLim, Ve.ABS1, H0.ABS1, step.ABS1, 'ABS1, V-component',20,abs1barLim);
buildContourPlot(ax(5), T.ABS2, timeLim, Ve.ABS2, H0.ABS2, step.ABS2, 'ABS2, V-component',5,abs2barLim);


%% Time interval

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

% dlmwrite("wind_smoothed_data_output.dat",[T.wndm; Vn.wndm; Ve.wndm],'delimiter','\t');

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
sr_put_scale_vector(ax(1), screenCoef, xyScreenRatio,'task9Style','N/m^2',3.0);
datetick(ax(1),'x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
xlabel(ax(1),'\tau, N/m^2','FontSize',11);
set(ax(1),'YGrid','off');
set(ax(1),'YTick',[]);

axes(ax(1));
colorbar;
set(colorbar,'visible','off');

% sr_save_figure(fig,'task_9.jpeg');

end



function buildContourPlot(ax, T, timeLim, V, H, levelStep, titl,isoCount,caxLimit)
% @param [in] ax - axes
% @param [in] T  - time vector
% @param [in] timeLim - [tLim0 tLim1]
% @param [in] V  - velocity component
% @param [in] H  - depth
% @param [in] levelStep - how frequencly lines will appeared
% @param [in] titl - title

% from mm to meters
mm2m = 1e-3;

% The limit of caxis
caxLimit = caxLimit * mm2m;

% Smoothing the data
[intrp.T,intrp.H,intrp.V] = interp3D(T,H,V,20);

% Plot smoothing data
pcolor(ax, intrp.T, intrp.H, intrp.V * mm2m);
shading(ax,'interp');
setRedBlueSmoothedColormap(ax);

caxis(ax, [-caxLimit caxLimit]);
colorbar(ax,'Ticks',linspace(-caxLimit,caxLimit,9));
hold(ax,'on');
box(ax,'on');

% Plot contour
[M,c]=contourf(ax,T,H,V * mm2m, isoCount, 'Fill','off');
set(c,'ShowText','off');
set(c, 'LineWidth', 1e-5);
set(c,'EdgeColor',[0.8 0.8 0.8]);
set(c,'LevelStep',levelStep * mm2m);
set(c,'TextStep',levelStep * mm2m);
% clabel(M,c,'Color','k','FontSize',6,'LabelSpacing',1000,'EdgeColor','none');
% val = linspace(-caxLimit,caxLimit,5000);
% clabel(M,c,val,'FontSize',6);
% t = clabel(M,c,'manual','FontSize',6);

% putLabels(ax,M,c);

lims = get(ax,'YLim');
title(ax,titl,'FontSize',8,'FontWeight','bold');
ylabel(ax,'Depth, m');
xlabel(ax,'Velocity, m/s');
set(ax,'XLim', timeLim);
set(ax,'YDir', 'reverse');
set(ax,'YGrid','on');
set(ax,'YTick',lims(1):0.5:lims(2));
set(ax,'Layer','top'); % put ticks on top of the `pcolor`
datetick(ax,'x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');
set(ax,'FontSize',9);
axes(ax);
end

function putLabels(ax,M,c)
Co = interpretContour(M);
% for k = 1:length(Co)
%     level = Co(k).level;
%     color = getColorOfColormap(ax, level);
%     plot(ax,Co(k).pnts(1,:),Co(k).pnts(2,:),'LineWidth',1e-5,'Color',color);
% end
ydata = get(c,'YData');
xdata = get(c,'XData');
aTexts = [];
for k = 1:length(Co)
    level = Co(k).level;
    x = Co(k).pnts(1,:);
    y = Co(k).pnts(2,:);
    ctrx = sum(x) / length(x);
    ctry = sum(y) / length(y);
    roundedLevel = round(level*1000.0) / 1000.0;
    if roundedLevel == 0
        continue;
    end
    if abs(ctry - ydata(1)) < 0.05 * (ydata(end) - ydata(1))
        continue;
    end
    if abs(ctry - ydata(end)) < 0.05 * (ydata(end) - ydata(1))
        continue;
    end
    if abs(ctry - xdata(1)) < 0.05 * (xdata(end) - xdata(1))
        continue;
    end
    if abs(ctry - xdata(end)) < 0.05 * (xdata(end) - xdata(1))
        continue;
    end
    str = num2str(roundedLevel);
    t.handle = text(ax,ctrx,ctry,str,'FontSize',6);
    extent = get(t.handle,'Extent');
    pos = get(t.handle,'Position');
    t.position = [pos(1) pos(2) extent(3) extent(4)];
    t.level = level;
    aTexts = [aTexts t];
end

k1 = 1;
n = length(aTexts);
while k1 < n
    inters = logical(zeros(1,n-k1));
    for k2 = k1+1:n
       inters(k2) = isTextsInters(aTexts(k2),aTexts(k1)); 
    end
    toRemove = aTexts(inters);
    for k3 = 1:length(toRemove)
        set(toRemove(k3).handle,'Color','b','EdgeColor','r');
        delete(toRemove(k3).handle);
    end
    aTexts(inters) = [];
    n = n - length(toRemove);
    k1 = k1 + 1;
end

end

function res = isTextsInters(t1,t2)
r1.left = t1.position(1);
r2.left = t2.position(1);
r1.right = t1.position(1) + t1.position(3);
r2.right = t2.position(1) + t2.position(3);
r1.bottom = t1.position(2);
r2.bottom = t2.position(2);
r1.top = t1.position(2) + t1.position(4);
r2.top = t2.position(2) + t2.position(4);
res = ~(r2.left > r1.right || r2.right < r1.left || r2.top < r1.bottom || r2.bottom > r1.top);
end

function Data = interpretContour(M)
idx = 1;
Data = [];
while idx < length(M)
    data.level = M(1,idx);
    data.cnt = M(2,idx);
    data.pnts = M(:,idx+1:idx+data.cnt);
    Data = [Data data];
    idx = idx + data.cnt + 1;
end
end

function [xx,yy,mm] = interp3D(x,y,m,coef)
xPnts = length(x) * coef;
yPnts = length(y) * coef;
pp1 = linspace(min(min(x,[],2)),max(max(x,[],2)),xPnts);
pp2 = linspace(min(min(y,[],1)),max(max(y,[],1)),yPnts);
[xx,yy] = meshgrid(pp1,pp2);
mm = interp2(x,y,m,xx,yy,'spline');
end

function setRedBlueSmoothedColormap(ax)
cm = redbluecmap; 
N = 100;
colormap(ax,[
    interpArray(cm(:,1),N);
    interpArray(cm(:,2),N);
    interpArray(cm(:,3),N)
]');
end

function rgb = getColorOfColormap(ax,value)
    cl = get(ax,'CLim');
    cm = get(ax,'Colormap');
    n = length(cm);
    if value <= cl(1)
        rgb = cm(1,:);
        return
    end
    if value >= cl(2)
        rgb = cm(end,:);
        return;
    end
    v = linspace(cl(1),cl(2),n);
    ind = find(v > value);
    
    rgb = cm(ind(1),:);
end

function yy = interpArray(array, N)
defN = length(array);
xx = linspace(1,defN,N);
yy = interp1(1:defN,array,xx);
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