function task_12_read_structure()
% Scan all files in the `myDir` directory 
% and perform conversion

% Directory name
%myDir = 'task12_data';
myDir = 'task13_data';

% All files to convert
myFiles = dir(fullfile(myDir,'*.000'));

% For each file
for k = 1:length(myFiles)
   baseFileName = myFiles(k).name;
   fullFileName = fullfile(myDir, baseFileName);
   fprintf(1, 'Now converting %s\n', fullFileName);
   
   % convertFile(fullFileName);
   convertFile2(fullFileName); % run conversion
end
end

% Copied some staff from the
% rdi_read_moored_plotout_ADCP_BLackSea_Feodosiya_03092019.m
function convertFile2(fname)

% Print something if filed doesn't exist
if (~exist(fname, 'file'))
    disp('Failed to find a file');
end

% The try block. 
% If something happened in this block the `catch` 
% section will be evaluated
try
    % It takes forewere to read file via ADCP.
    % Therefore we decided to store (cache) read result.
    cachedFilename = [fname '_cached_task13.mat'];
    
    if isfile(cachedFilename) % if cache file exist -> read cache
        load(cachedFilename, 'ADCP');
    else                      % else read file via rdpadcp
        ADCP=rdpadcp(fname,1,'ref','bottom','des','yes');
        save(cachedFilename, 'ADCP'); % cache file
    end
catch
    disp(['failed to proc ' fname ' using the rdpadcp']);
end

% Getting values from ADCP structure.
% The code below was copied from the
% `rdi_read_moored_plotout_ADCP_BLackSea_Feodosiya_03092019.m`
Vn=ADCP.north_vel;
Ve=ADCP.east_vel;
Vz=ADCP.vert_vel;
t=ADCP.mtime;
L0=60;
H0=ADCP.config.range+ADCP.config.adcp_depth;
Vn(L0+1:end,:)=[];Ve(L0+1:end,:)=[];Vz(L0+1:end,:)=[];
H0(L0+1:end)=[];
V=sqrt(Vn.*Vn+Ve.*Ve); % the amplitude of the velocity
Ves=smoothdata(Ve,2,'movmean',73,'omitnan'); % smoothing
Vns=smoothdata(Vn,2,'movmean',73,'omitnan'); % smooxthing
Vs=sqrt(Vns.*Vns+Ves.*Ves);

% Create new file for writing the data
f = fopen([fname '_output_task_13.txt'],'w');
% Writing the head
fprintf(f, "%-10s%-10s%-24s%-20s%-20s\n", "station", "depth", "date", "Vn", "Ve");

for k1 = 1:length(H0) % for each station
    depth = H0(k1);
    dateStr = datestr(t(k1)); % convertint the utc format date to date string
    aEastVel = Ves(k1,:);     % vector of `e` velocities for this depth
    aNorthVel = Vns(k1,:);    % vector of `n` velocities for this depth
    for k2 = 1:length(aEastVel)
      eastVel = aEastVel(k2);
      northVel = aNorthVel(k2);
      number = 1;
      % Writing the row of data
      fprintf(f,"%-10s%-10.4f%-24s%-20.8f%-20.8f\n", num2str(number), depth, dateStr, northVel, eastVel);
    end
end
% Closing the file
fclose(f);
end

function convertFile(fname)
if (~exist(fname, 'file'))
    disp('Failed to find a file');
end

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
