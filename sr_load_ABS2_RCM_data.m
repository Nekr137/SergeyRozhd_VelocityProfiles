function [Vn, Ve, T, H0] = sr_load_ABS2_RCM_data(filename)

if ~exist('filename', 'var')
    filename = 'ABS2_RCM_184_20210809_1333.txt';
end

[head, data] = sr_parse_ABS2_RCM_file(filename);

for headIdx = 1:length(head)
   headStr = cell2mat(head(headIdx));
   if strcmp(headStr, 'Time tag (Gmt)')
       T = data(:, headIdx);
   end
   if strcmp(headStr, 'Depth(m)')
       H0 = data(:, headIdx);
   end
   if strcmp(headStr, 'North(cm/s)')
       Vn = data(:, headIdx);
   end
   if strcmp(headStr, 'East(cm/s)')
       Ve = data(:, headIdx);
   end
end
Ve = Ve';
Vn = Vn';
T = T';
end
