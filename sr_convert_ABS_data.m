function [Time, DataPerDepth] = sr_convert_ABS_data(head, data)

[rowCnt, colCnt] = size(data);
assert(length(head) == colCnt);

% Building the Time array
Time = datenum(datetime(...
    data(:, 2) + 2000,... % year
    data(:, 3),...        % month
    data(:, 4),...        % day
    data(:, 5),...        % hh
    data(:, 6),...        % mm
    data(:, 7),...        % ss
    data(:, 8)));

DataPerDepth = [];
for colIdx = 1:colCnt
    depthIdx = str2double(head(colIdx));
   if isnan(depthIdx)
       continue;
   end
   DataPerDepth(:, depthIdx) = data(:, colIdx);
end
end