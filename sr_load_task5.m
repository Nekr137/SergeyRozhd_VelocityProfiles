function [Vn, Ve, T, H0] = sr_load_task5(filename)

[T, speed, dir] = sr_parse_task5(filename);

angles = deg2rad(dir);

Vn = cos(angles) .* speed;
Ve = sin(angles) .* speed;
H0 = 1.0;
Vn = Vn';
Ve = Ve';

end