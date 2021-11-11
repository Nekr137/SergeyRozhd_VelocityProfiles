function task7_columns_on_two_figures
% 2021-03-11
% The same as task6_columns, but data was split into two days

% See suspension.docx
Cvv     = [3.48 2.49 1.94 1.41 0.49 0.55 0.36 0.64 1.09 1.18 0.63 0.62 0.88 0.67 1.21 1.56];
Cvmv    = [3.01 2.16 1.66 1.17 0.34 0.4 0.2 0.46 0.88 0.97 0.51 0.47 0.73 0.52 1.01 1.36];
Cvov    = [0.47 0.33 0.28 0.23 0.15 0.15 0.16 0.18 0.21 0.20 0.13 0.15 0.15 0.15 0.20 0.21];
Cvovotn = [13.4 13.2 14.2 16.6 30.1 27.8 44.0 28.3 19.3 17.3 20.0 24.0 17.3 22.2 16.8 13.1];

depth1 = 1;

coo = sr_get_station_coordinates();
[ranges1, ranges2] = sr_get_ranges_and_stations();
[filename1, filename2] = sr_get_test_filenames();

fig(1) = figure;
aAx(1) = axes;
sz = get(0, 'ScreenSize');
set(fig(1), 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]);
sr_load_coastline_map(aAx(1));

fig(2) = figure;
aAx(2) = axes;
sz = get(0, 'ScreenSize');
set(fig(2), 'position', [0 0 min(sz(3),sz(4))*0.9 min(sz(3),sz(4))*0.9]);
sr_load_coastline_map(aAx(2));

ShowColumns(aAx(1), aAx(2), Cvv, Cvmv, Cvov, Cvovotn, coo);

for axIdx = 1:2
    ax = aAx(axIdx);
    
    [Vn, Ve, T, H0] = sr_load_data(filename1);
    [Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depth1);

    % set(get(ax1, 'Title'), 'String', ['10/08/21, depth = ' num2str(H0(depth1))]);
    ShowDayVectors(ax, Vn, Ve, T, ranges1, coo(1:8, :), Cvv(1:8));

    [Vn, Ve, T, H0] = sr_load_data(filename2);
    [Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depth1);
    ShowDayVectors(ax, Vn, Ve, T, ranges2, coo(9:16, :), Cvv(9:16));

    sr_put_scale_vector_on_map(ax);
    sr_put_stations_on_map(ax);
end

sr_save_figure(fig(axIdx), 'output_task_7_suspension_columns_split_day_1');
sr_save_figure(fig(axIdx), 'output_task_7_suspension_columns_split_day_2');
end

function ShowDayVectors(ax, Vn, Ve, T, ranges, coordinates, suspension) 
    [nCoordinates, ~] = size(coordinates);
    for stationIdx = 1:length(ranges)        
        % The case if several vectors at the same coodinate
        coordinateIdx = min(stationIdx, nCoordinates);
        
        [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
        [vn, ve, t] = sr_smooth_data(stationVn, stationVe, stationT);
        depthCnt = length(vn);
        coo = repmat(coordinates(coordinateIdx, :), depthCnt, 1);
        
        sr_show_vector_on_map(ax, coo(:, 1), coo(:, 2), ve, vn, [0 0.7 0], 1.5);
        
        sus = suspension(coordinateIdx);
        ve = ve * sus; % The same as: ve / norm([ve vn]) * (norm([ve vn]) * sus);
        vn = vn * sus; % The same as: ve / norm([ve vn]) * (norm([ve vn]) * sus);
        
        sr_show_vector_on_map(ax, coo(:, 1), coo(:, 2), ve, vn, [1 0 0], 0.5);
    end
end

function ShowColumns(ax1, ax2, Cvv, Cvmv, Cvov, Cvovotn, coo)
nCol = 4;
colWidth = 0.003;
Cvv = Cvv / 100;
Cvmv = Cvmv / 100;
Cvov = Cvov / 100;
Cvovotn = Cvovotn / 1000;
for stationIdx = 1:length(coo)
    if stationIdx < 9
        xsh = -colWidth * 6;
        ysh = 0;
    else
        xsh = -0.1 * colWidth;
        ysh = 4*colWidth;
    end
    BuildColumn(ax1, coo(stationIdx,:) + [-(nCol+1+xsh)*colWidth ysh], colWidth,     Cvv(stationIdx), [0.8 0 0]);
    BuildColumn(ax1, coo(stationIdx,:) + [-(nCol+0+xsh)*colWidth ysh], colWidth,    Cvmv(stationIdx), [0 0.8 0]);
    BuildColumn(ax2, coo(stationIdx,:) + [-(nCol-1+xsh)*colWidth ysh], colWidth,    Cvov(stationIdx), [0 0 0.8]);
    BuildColumn(ax2, coo(stationIdx,:) + [-(nCol-2+xsh)*colWidth ysh], colWidth, Cvovotn(stationIdx), [0.8 0 0.8]);
end

xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
scp = [... % column scale position
    xlim(1) + diff(xlim) * 0.9...
    ylim(1) + diff(ylim) * 0.75];

sch = 0.01; % scale column height

BuildColumn(ax1, scp + [-(nCol+6+xsh)*colWidth ysh], colWidth, sch, [0.8 0 0], 'ׁגג (לד/כ) /100');
BuildColumn(ax1, scp + [-(nCol+0+xsh)*colWidth ysh], colWidth, sch, [0 0.8 0], 'Cגלג (לד/כ) /100');
BuildColumn(ax2, scp + [-(nCol-6+xsh)*colWidth ysh], colWidth, sch, [0 0 0.8], 'ׁגמג (לד/כ) /100');
BuildColumn(ax2, scp + [-(nCol-12+xsh)*colWidth ysh], colWidth, sch, [0.8 0 0.8], ['ׁגמג.מעם ' char(8240)]);
end
    
function BuildColumn(ax, iP2D, iWidth, iHeight, iColor, iLabel)
Y_SCALE = 3.0; % Just a visualization coefficient. It doesn't affect to the correcntess of the data
pos = [     iP2D(1) - 0.5 * iWidth;     iP2D(2);     iWidth;     iHeight * Y_SCALE];
rect = rectangle(ax, 'Position', pos);
set(rect,'EdgeColor', iColor);
set(rect,'FaceColor', iColor);
if exist('iLabel', 'var')
    t = text(ax, iP2D(1) + 1.2 * iWidth, iP2D(2), iLabel);
    set(t,'Rotation',90)
end
end