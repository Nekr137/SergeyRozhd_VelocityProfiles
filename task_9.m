function task_9

% U = load('task_9_U(ABS1).txt');
% V = load('task_9_V(ABS1).txt');

[Vn.ABS1, Ve.ABS1, T.ABS1, H0.ABS1] = sr_load_abs_data('ABS1_adcp300_dir.txt', 'ABS1_adcp300_mag.txt');
[Vn.ABS2, Ve.ABS2, T.ABS2, H0.ABS2] = sr_load_abs_data('ABS2_dvs1_dir3.txt', 'ABS2_dvs1_mag3.txt');

step.ABS1 = 50.0;
step.ABS2 = 10.0;

buildContourPlot(subplot(512), T.ABS1, Vn.ABS1, H0.ABS1, step.ABS1, 'ABS1, U-component');
buildContourPlot(subplot(513), T.ABS1, Ve.ABS1, H0.ABS1, step.ABS1, 'ABS1, V-component');
buildContourPlot(subplot(514), T.ABS2, Vn.ABS2, H0.ABS2, step.ABS2, 'ABS2, U-component');
buildContourPlot(subplot(515), T.ABS2, Ve.ABS2, H0.ABS2, step.ABS2, 'ABS2, V-component');



end

function buildContourPlot(ax, T, V, H, levelStep, titl)
% @param [in] ax - axes
% @param [in] T  - time vector
% @param [in] V  - velocity component
% @param [in] titl - title

[M,c] = contourf(ax,T,H,V);
% 'ShowText','on'
% c.LineWidth = 0.01;
set(c,'EdgeColor',[0.5 0.5 0.5]);
set(c,'LevelStep',levelStep);
title(titl);
ylabel('Depth, m');



end