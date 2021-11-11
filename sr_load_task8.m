function [Vn, Ve, T, H0] = sr_load_task8(fname)

% Check if cached data is already exists.
cachedFilename = [fname '_cached_in_matlab_by.mat'];
if isfile(cachedFilename) % Cache data using matlab `.mat` extension.
    % Reading the data from cache
    load(cachedFilename, 'Vn', 'Ve', 'T', 'H0');
    return;
end

data = sr_parse_time_speed_dir(fname);

speed = data(:,1);
dir = data(:,2);
T = data(:,3);

angles = deg2rad(dir);

Vn = cos(angles) .* speed;
Ve = sin(angles) .* speed;
H0 = 1.0;
Vn = Vn';
Ve = Ve';

save(cachedFilename, 'Vn', 'Ve', 'T', 'H0'); % Cache data

end