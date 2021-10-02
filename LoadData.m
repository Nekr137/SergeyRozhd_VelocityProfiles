function [Vns, Ves, Ts, Depth] = LoadData(fname)

ADCP = rdpadcp(fname, 1, 'ref', 'bottom', 'des', 'yes');
Depth=ADCP.config.range+ADCP.config.adcp_depth; %cell depth=ADCP depth+offsets

% Smoothing and rearrange the data
sl = 2; % smoothing level
newSize = round(length(ADCP.mtime) / sl);
Vns = ones(length(Depth), newSize);
Ves = ones(length(Depth), newSize);
Ts  = ones(newSize);
for i = 1:newSize
    lIdx = i * sl - sl + 1;
    rIdx = min(lIdx + sl, length(ADCP.mtime));
    Ts(i)  = mean(ADCP.mtime(lIdx:rIdx));
    for hIdx = 1:length(Depth)
        Vns(hIdx, i) = mean(ADCP.north_vel(hIdx, lIdx:rIdx));
        Ves(hIdx, i) = mean(ADCP.east_vel(hIdx, lIdx:rIdx));    
    end
end
end
