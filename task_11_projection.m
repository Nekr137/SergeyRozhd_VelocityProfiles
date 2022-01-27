function task_11_projection()
% A continueation of the task_2:
% Export of the Vn component to the file for all the
% depths and stations.
% (see task_11_projection.info)
% The function creates two files - for all data within the intervals,
% another - one smoothed value per each the interval.
% Nan values are skipped.

% For filenames and ranges info see task_2
[filename1, filename2] = sr_get_test_filenames();
[ranges1, ranges2, stationsNames1, stationsNames2, figureTitle1, figureTitle2] = sr_get_ranges_and_stations();

treatFile(filename1, ranges1, stationsNames1);
treatFile(filename2, ranges2, stationsNames2);

end


function treatFile(filename, dateRanges, stationNames) 
[Vn, Ve, T, H0] = sr_load_data(filename);

f.notSmoothed = fopen(['output_task_11_' filename '_not_sm.txt'],'w');
f.smoothed = fopen(['output_task_11_' filename 'sm.txt'],'w');

fprintf(f.notSmoothed, "%-10s%-10s%-24s%-10s\n", "station", "depth","date", "Vn");
fprintf(f.smoothed, "%-10s%-10s%-24s%-10s\n", "station", "depth","date", "Vn");

for datesIdx = 1:length(dateRanges)
    daterange = dateRanges(datesIdx,:);
    stationName = stationNames(datesIdx);
    [intvl.Vn, intvl.Ve, intvl.T] = sr_extract_time_interval(Vn, Ve, T, daterange);

    for depthIdx = 1:length(H0)
        depth = H0(depthIdx);
        meanVel.value = 0;
        meanVel.cnt = 0;
        for vIdx = 1:length(intvl.T)
            dateStr = datestr(intvl.T(vIdx));
            vn = intvl.Vn(depthIdx,vIdx);
            if ~isnan(vn)
                fprintf(f.notSmoothed,"%-10s%-10.4f%-24s%-10.8f\n", cell2mat(stationName), depth, dateStr, vn);
                meanVel.value = meanVel.value + vn;
                meanVel.cnt = meanVel.cnt + 1;
            end
        end
        if meanVel.cnt
            fprintf(f.smoothed,"%-10s%-10.4f%-24s%-10.8f\n", cell2mat(stationName), depth, dateStr, meanVel.value / meanVel.cnt);
        end
    end
end
end
