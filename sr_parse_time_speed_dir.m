function data = sr_parse_time_speed_dir(filename)
% Used in the task 5 and task 8

f = fopen(filename);

line = fgetl(f); % skip the head
maxCnt = 1e6;
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

end