function [Vn, Ve, T, H0] = sr_load_abs_data(dirFilename, magFilename,startDepth,depthStep)

if ~exist('startDepth','var')
    startDepth = 3.0;
end
if ~exist('depthStep','var')
    depthStep = 0.5;
end

[headForDir, directions] = sr_parse_ABS_file(dirFilename);
[headForMag, magnitudes] = sr_parse_ABS_file(magFilename);

[Time1, dirPerDepth] = sr_convert_ABS_data(headForDir, directions);
[Time2, magPerDepth] = sr_convert_ABS_data(headForMag, magnitudes);

assert(length(Time1) == length(Time2));
angles = deg2rad(dirPerDepth);

[s1, s2] = size(angles);
% Uncomment to validate the visualization
% angles = 30 / 180 * pi * ones(s1, s2);

Vn = cos(angles) .* magPerDepth;
Ve = sin(angles) .* magPerDepth;
T = 0.5 * (Time1 + Time2);

H0 = depthStep * (1:s2) + startDepth;
Vn = Vn';
Ve = Ve';
end