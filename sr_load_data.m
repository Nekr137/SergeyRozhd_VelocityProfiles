function [Vns, Ves, Ts, Depth] = sr_load_data(fname)


cachedFilename = [fname '_cached_in_matlab_by.mat'];
if isfile(cachedFilename) % Cache data using matlab `.mat` extension.
    % Reading the data from cache
    load(cachedFilename, 'Vns', 'Ves', 'Ts', 'Depth');
    return;
end

ADCP = rdpadcp(fname, 1, 'ref', 'bottom', 'des', 'yes');
Depth=ADCP.config.range+ADCP.config.adcp_depth; %cell depth=ADCP depth+offsets

% Smoothing and rearrange the data
sl = 2; % smoothing level
newSize = round(length(ADCP.mtime) / sl);
Vns = ones(length(Depth), newSize); % Creating the matrix of ones in order to dedicate memory fro Vn
Ves = ones(length(Depth), newSize); % Creating the matrix of ones in order to dedicate memory fro Ve
Ts  = ones(newSize, 1);             % Creating the matrix of ones in order to dedicate memory fro Ts

% Smoothing cycle.
% We are smoothing the data using `mean` function.
for i = 1:newSize
    lIdx = i * sl - sl + 1;                    % left index
    rIdx = min(lIdx + sl, length(ADCP.mtime)); % right index
    Ts(i)  = mean(ADCP.mtime(lIdx:rIdx));      % mean Ts is the sum of ADCP.mtime from lIdx to rIdx devided by (rIdx-lIdx)
    for hIdx = 1:length(Depth)                 % Smoothing the Vns and Ves like we smoothed the Ts
        Vns(hIdx, i) = mean(ADCP.north_vel(hIdx, lIdx:rIdx));
        Ves(hIdx, i) = mean(ADCP.east_vel(hIdx, lIdx:rIdx));    
    end
end

save(cachedFilename, 'Vns', 'Ves', 'Ts', 'Depth'); % Cache data
end
