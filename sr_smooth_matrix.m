function resultMatrix = sr_smooth_matrix(M, nPoints)
% param[in] M        A 2D matrix for smoothing
% param[in] nPoints  The size 1x2 of the `resultMatrix` matrix
% param[out] resultMatrix  Smoothed matrix with the nPoints(1) x nPoints(2)
%                          size
% testing/usage:
% m = [1 1 1 1 1
%      2 2 2 2 2
%      3 3 3 3 3
%      4 4 4 4 4]
% sr_smooth_matrix(m, [2 3])
% ans =
%  1.5000  1.5000  1.5000
%  3.5000  3.5000  3.5000


n = size(M);
assert(n(1) >= nPoints(1), 'nPoints(1) must be <= than horizontal size of the matrix!');
assert(n(2) >= nPoints(2), 'nPoints(2) must be <= than vertical size of the matrix!');
w = fix(n./nPoints);
rem = mod(n,nPoints); % remedy
resultMatrix = zeros(nPoints);
for k1 = 1:nPoints(1)
for k2 = 1:nPoints(2)
    stIdx = ([k1 k2]-1).*w + 1 + round(rem/2);
    enIdx = min(n, stIdx+w-1);
    if k1 == 1; stIdx(1) = 1; end
    if k2 == 1; stIdx(2) = 1; end
    if k1 == nPoints(1); enIdx(1) = n(1); end
    if k2 == nPoints(2); enIdx(2) = n(2); end
    minorMatrix = M(stIdx(1):enIdx(1),stIdx(2):enIdx(2));
    resultMatrix(k1,k2) = mean(mean(minorMatrix, 'omitnan'), 'omitnan');
%     M(stIdx(1):enIdx(1),stIdx(2):enIdx(2)) = 0;
%     disp(M);
end
end
end