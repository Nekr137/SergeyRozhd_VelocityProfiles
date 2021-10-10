function [head, data] = sr_parse_ABS2_RCM_file(filename)

f = fopen(filename);
maxCnt = 1e5;

head = [];
data = [];

for lineIdx = 1:maxCnt
   line = fgetl(f); 
   if ~ischar(line)
       break;
   end
   if contains(line, 'North(cm/s)')
       head = strsplit(line, '\t');
       break;
   end
end

data = zeros(maxCnt, length(head));

for rowIdx = 1:maxCnt
   line = fgetl(f); 
   if ~ischar(line)
       break;
   end
   
   row = strsplit(line, '\t');
   assert(length(row) == length(head));
   
   digitRow = zeros(length(row), 1);
   
   for colIdx = 1:length(row)
       str = cell2mat(row(colIdx));
       if contains(str, ':')
           digitRow(colIdx) = datenum(cell2mat(row(colIdx)), 'dd.mm.yy HH:MM:SS');
           continue;
       end
       
       value = str2num(str);
       if length(value) == 1
           digitRow(colIdx) = value;
       end
   end

   data(rowIdx, :) = digitRow;
end

data = data(1:rowIdx-1, :);

end