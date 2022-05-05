function task_12_read_structure()

myDir = 'task12_data';
myFiles = dir(fullfile(myDir,'*.000'));
for k = 1:length(myFiles)
   baseFileName = myFiles(k).name;
   fullFileName = fullfile(myDir, baseFileName);
   fprintf(1, 'Now converting %s\n', fullFileName);
   convertFile(fullFileName);
end
end

function convertFile(fname)
if (~exist(fname, 'file'))
    disp('Failed to find a file');
end

% TODO: support `p` files reading
% try
%     ADCP = rdpadcp(fname, 1, 'ref', 'bottom', 'des', 'yes');
%     Depth=ADCP.config.range+ADCP.config.adcp_depth; %cell depth=ADCP depth+offsets
% catch
%     disp(['failed to proc ' fname ' using the rdpadcp']);
% end

try
    ADCP = rdradcp(fname);
catch
    disp(['failed to proc ' fname ' using the rdradcp']);
end

if isempty(ADCP)
    disp(['The file ' fname ' is empty!']);
    return;
end
aDepth = ADCP.depth;
aTime = datestr(ADCP.mtime);
aaEastVel = ADCP.east_vel;
aaNorthVel = ADCP.north_vel;
aNumbers = ADCP.number; % kinda stations here
f = fopen([fname '_output_task_12.txt'],'w');
fprintf(f, "%-10s%-10s%-24s%-20s%-20s\n", "station", "depth", "date", "Vn", "Ve");
for k1 = 1:length(aDepth)
    depth = aDepth(k1);
    dateStr = aTime(k1,:);
    aEastVel = aaEastVel(:,k1);
    aNorthVel = aaNorthVel(:,k1);
    assert(length(aEastVel) == length(aNorthVel));
    number = aNumbers(k1);
    for k2 = 1:length(aEastVel)
      eastVel = aEastVel(k2);
      northVel = aNorthVel(k2);
      fprintf(f,"%-10s%-10.4f%-24s%-20.8f%-20.8f\n", num2str(number), depth, dateStr, northVel, eastVel);
    end
end
fclose(f);

end
