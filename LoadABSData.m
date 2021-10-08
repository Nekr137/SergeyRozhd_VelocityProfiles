function [Vn, Ve, T, H0] = LoadABSData(dirFilename, magFilename)

[headForDir, directions] = ParseABSFile(dirFilename);
[headForMag, magnitudes] = ParseABSFile(magFilename);

[Time1, dirPerDepth] = ConvertABSData(headForDir, directions);
[Time2, magPerDepth] = ConvertABSData(headForMag, magnitudes);

assert(length(Time1) == length(Time2));
angles = deg2rad(dirPerDepth);

[s1, s2] = size(angles);
% Uncomment to validate the visualization
% angles = 30 / 180 * pi * ones(s1, s2);

Vn = cos(angles) .* magPerDepth;
Ve = sin(angles) .* magPerDepth;
T = 0.5 * (Time1 + Time2);
H0 = 0.5 * 1:s2 + 3.0;
Vn = Vn';
Ve = Ve';
end