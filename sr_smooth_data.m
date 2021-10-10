function [oVn, oVe, oT] = sr_smooth_data(iVn, iVe, iT)
% Smoothing the data skipping all NAN`s
%
% input: iVn[depthCnt, timeCnt], iVe[depthCnt, timeCnt], iT[timeCnt]
% output: oVn[depthCnt], oVe[depthCnt], iT[depthCnt]
%
% !nb: The `oT` is a vector of size [depthCnt] like the oVn or oVe
%      due to different positions of nan elements in each velocity
%      array!

[depthCnt, timeCnt] = size(iVn);
oVn = zeros(depthCnt, 1);
oVe = zeros(depthCnt, 1);
oT = zeros(depthCnt, 1);
for depthIdx = 1:depthCnt
   cnt = 0;
   for timeIdx = 1:timeCnt
       vn = iVn(depthIdx, timeIdx);
       ve = iVe(depthIdx, timeIdx);
       if ~isnan(vn) && ~isnan(ve)
           oVn(depthIdx) = oVn(depthIdx) + vn;
           oVe(depthIdx) = oVe(depthIdx) + ve;
           oT(depthIdx) = oT(depthIdx) + iT(timeIdx);
           cnt = cnt + 1;
       end
   end
   oVe(depthIdx) = oVe(depthIdx) / cnt;
   oVn(depthIdx) = oVn(depthIdx) / cnt;
   oT(depthIdx) = oT(depthIdx) / cnt;
end
end

