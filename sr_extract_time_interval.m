function [oVn, oVe, oT] = sr_extract_time_interval(iVn, iVe, iT, iTimeInterval)
timeIndices = find(iT > iTimeInterval(1) & iT < iTimeInterval(2));
oT = iT(timeIndices);
oVn = iVn(:, timeIndices);
oVe = iVe(:, timeIndices);
end