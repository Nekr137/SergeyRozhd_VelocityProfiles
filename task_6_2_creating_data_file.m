function task_6_2_creating_data_file()

% The task from 2021-10-07
% Placed smoothing vectors on the MAP

% Creating the intersting ranges
filename1 = 'DATA_000p.000';
filename2 = 'DATA_003p.000';

[ranges1, ranges2, stations1, stations2, figureTitle1, figureTitle2] = sr_get_ranges_and_stations();
coordinates = sr_get_station_coordinates();

depth = [1:100];

fid1_n = fopen('output_task_creating_data1_n.txt','wt');
fprintf(fid1_n, 'Depth\tSt1\tSt2\tSt3\tSt4\tSt5\tSt6\tSt7\tSt8\n');

fid1_e = fopen('output_task_creating_data1_e.txt','wt');
fprintf(fid1_e, 'Depth\tSt1\tSt2\tSt3\tSt4\tSt5\tSt6\tSt7\tSt8\n');

fid2_n = fopen('output_task_creating_data2_n.txt','wt');
fprintf(fid2_n, 'Depth\tSt16\tSt17\tSt18\tSt19\tSt20\tSt21\tSt22\tSt23\n');

fid2_e = fopen('output_task_creating_data2_e.txt','wt');
fprintf(fid2_e, 'Depth\tSt16\tSt17\tSt18\tSt19\tSt20\tSt21\tSt22\tSt23\n');

Write(fid1_n, fid1_e, depth, filename1, ranges1);
Write(fid2_n, fid2_e, depth, filename2, ranges2);

fclose(fid1_n);
fclose(fid1_e);
fclose(fid2_n);
fclose(fid2_e);
end

function Write(fid_n, fid_e, depthIndices, filename, ranges) 

% Parsing the file
[Vn, Ve, T, H0] = sr_load_data(filename);
[Vn, Ve, H0] = sr_extract_depths(Vn, Ve, H0, depthIndices);
rangesCnt = length(ranges);
depthCnt = length(H0);

data.n = zeros(rangesCnt, length(H0));
data.e = zeros(rangesCnt, length(H0));
data.t = zeros(rangesCnt, length(H0));

for stationIdx = 1:rangesCnt 
    [stationVn, stationVe, stationT] = sr_extract_time_interval(Vn, Ve, T, ranges(stationIdx, :));
    [vn, ve, t] = sr_smooth_data(stationVn, stationVe, stationT);   
    for depthIdx = 1:length(t)
        data.n(stationIdx, :) = vn;
        data.e(stationIdx, :) = ve;
    end
end
data.n = data.n';
data.e = data.e';


for depthIdx = 1:depthCnt
    fprintf(fid_n, '%6.10f\t', H0(depthIdx));
    fprintf(fid_e, '%6.10f\t', H0(depthIdx));
    for stationIdx = 1:rangesCnt
        fprintf(fid_n, '%6.10f\t', data.n(depthIdx, stationIdx));
        fprintf(fid_e, '%6.10f\t', data.e(depthIdx, stationIdx));        
    end
    fprintf(fid_n, '\n');
    fprintf(fid_e, '\n');
end

end
