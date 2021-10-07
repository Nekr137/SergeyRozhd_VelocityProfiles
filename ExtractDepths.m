function [oVe, oVn, oH] = ExtractDepths(iVe, iVn, iH, aDepthIndices)

[~, existingIndices] = find(aDepthIndices <= length(iH) & aDepthIndices >=1);
aDepthIndices = aDepthIndices(existingIndices);

lenDepth = length(aDepthIndices);
[~, lenTime] = size(iVe);

oVe = zeros(lenDepth,  lenTime);
oVn = zeros(lenDepth,  lenTime);
oH  = zeros(lenDepth, 1);

oVe = iVe(aDepthIndices, :);
oVn = iVn(aDepthIndices, :);
oH  = iH(aDepthIndices);

end