function task_9

[Vn.ABS1, Ve.ABS1, T.ABS1, H0.ABS1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.ABS2, Ve.ABS2, T.ABS2, H0.ABS2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');

step.ABS1 = 40.0;
step.ABS2 = 10.0;

timeLim = [
    min([T.ABS1(1) T.ABS2(1)])
    max([T.ABS1(end) T.ABS2(end)])
];

buildContourPlot(subplot(512), T.ABS1, timeLim, Vn.ABS1, H0.ABS1, step.ABS1, 'ABS1, U-component');
buildContourPlot(subplot(513), T.ABS1, timeLim, Ve.ABS1, H0.ABS1, step.ABS1, 'ABS1, V-component');
buildContourPlot(subplot(514), T.ABS2, timeLim, Vn.ABS2, H0.ABS2, step.ABS2, 'ABS2, U-component');
buildContourPlot(subplot(515), T.ABS2, timeLim, Ve.ABS2, H0.ABS2, step.ABS2, 'ABS2, V-component');

colormap jet

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
% 'ShowText','on'
% c.LineWidth = 0.01;
set(c,'EdgeColor',[0.5 0.5 0.5]);
set(c,'LevelStep',levelStep);
title(titl,'FontSize',10,'FontWeight','normal');
ylabel('Depth, m');
% colorbar;
caxis([-200 200]);

set(ax,'XLim', timeLim);
datetick('x', 'mm/dd HH:MM', 'keeplimits', 'keepticks');

end