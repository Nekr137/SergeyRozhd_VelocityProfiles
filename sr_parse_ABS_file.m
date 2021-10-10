function [head, data] = sr_parse_ABS_file(filename)
f = fopen(filename);

headFound = 0;
head = [];
data = [];
maxCnt = 1e5;
cols = 0;
dataIdx = 1;
for lineIdx = 1:maxCnt
   line = fgetl(f); 
   if ~ischar(line)
       break;
   end
   if contains(line, '"') || isempty(line)
       continue;
   end

   if ~headFound
       headFound = 1;
       head = split(line);
       cols = length(head);
       data = zeros(maxCnt, cols);
       continue;
   end
   
   d = str2num(strrep(line, ',', '.'));
   if length(d) ~= cols
       disp('data cnt error');
       disp(['line: ' line]);
       continue;
   end
   
   data(dataIdx, :) = d;
   dataIdx = dataIdx + 1;
 
end

if dataIdx > 1
    data = data(1:dataIdx-1, :);
end

end