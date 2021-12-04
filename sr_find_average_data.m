function [Dmean] = sr_find_average_data(D, w)
% Finds mean values
% @param [in] w - window
n = length(D);
cnt = ceil(n/w);

Dmean = zeros(1, cnt);

for k = 1:cnt
   f = min(w * k + 1, n);
   s = f - w;
   Dmean(k) = mean(D(s:f)); 
end
end