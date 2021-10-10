function [time, speed, dir] = sr_parse_task5(filename)

f = fopen(filename);

line = fgetl(f); % skip the head
maxCnt = 1e5;
for rowIdx = 1:maxCnt
   line = fgetl(f);
   if ~ischar(line)
       break;
   end
   
   line = strrep(line, ',', '.');
   row = strsplit(line, '\t');
   
   if length(row) ~= 3
       continue;
   end
   
   digitRow = zeros(length(row), 1);
   
   for colIdx = 1:length(row)
       str = cell2mat(row(colIdx));
       if contains(str, ':')
           digitRow(colIdx) = datenum(cell2mat(row(colIdx)), 'yyyy-mm-ddTHH:MM:SS.9');
           continue;
       end
       
       value = str2num(str);
       if length(value) == 1
           digitRow(colIdx) = value;
       end
   end

   data(rowIdx, :) = digitRow;
 
end

if rowIdx > 1
    data = data(1:rowIdx-1, :);
end

time = data(:, 1);
speed = data(:, 2);
dir = data(:, 3);

end