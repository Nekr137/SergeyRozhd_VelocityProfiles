function [Vn, Ve, T, H0] = sr_load_task5(filename)

data = sr_parse_time_speed_dir(filename);

T = data(:,1);
speed = data(:,2);
dir = data(:,3);

angles = deg2rad(dir);

Vn = cos(angles) .* speed;
Ve = sin(angles) .* speed;
H0 = 1.0;
Vn = Vn';
Ve = Ve';

end