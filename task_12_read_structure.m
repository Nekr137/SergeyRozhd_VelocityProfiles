function task_12_read_structure()
myDir = 'task12_data';
myFiles = dir(fullfile(myDir,'*.000'));

for k = 1:length(myFiles)
   baseFileName = myFiles(k).name;
   fullFileName = fullfile(myDir, baseFileName);
   fprintf(1, '\nWorking with %s\n', fullFileName);
   adcpStruct = extractADCP(fullFileName);
   if length(adcpStruct) == 0 % if failed to extract
     continue;
   end
   [Vn, Ve, T, H0] = extractDataFromADCP(adcpStruct);
   writeADCPData([fullFileName '_output_task_13.txt'], H0, Ve, Vn, T);
end
end

function adcpStruct = extractADCP(fullFileName)
fprintf(1, 'Extracting %s\n', fullFileName);
adcpStruct = {};
if (~exist(fullFileName, 'file'))
    disp(['Failed to find a file: ' fullFileName]);
    return
end
cachedFilename = [fullFileName '_cached_task13.mat'];
if isfile(cachedFilename)
    load(cachedFilename, 'adcpStruct');
else                        
    adcpStruct = loadADCP(fullFileName);
    save(cachedFilename, 'adcpStruct');                   
end
end

function [Vn, Ve, T, H0] = extractDataFromADCP(ADCP)
% `rdi_read_moored_plotout_ADCP_BLackSea_Feodosiya_03092019.m`
L0 = 60;
Vn = ADCP.north_vel;
Ve = ADCP.east_vel;
T = ADCP.mtime;
try
  H0=ADCP.config.range+ADCP.config.adcp_depth;
catch
  H0 = ADCP.depth;
end
figure(1);
subplot(121);
image(Vn + 1e3);
subplot(122);
image(Ve + 1e3);
Vn(L0+1:end,:)=[];
Ve(L0+1:end,:)=[];
H0(L0+1:end)=[];
Ves = smoothdata(Ve,2,'movmean',73,'omitnan');
Vns = smoothdata(Vn,2,'movmean',73,'omitnan');
Vn = Vns;
Ve = Ves;
subplot(121);
image(Vn + 1e3);
subplot(122);
image(Ve + 1e3);
title('Showing degenerated data');
end


function writeADCPData(fullFileName, H0, Ve, Vn, T)
fprintf(1, 'Saving %s\n', fullFileName);
f = fopen(fullFileName,'w');
fprintf(f, '%-10s%-10s%-24s%-20s%-20s\n', "station", "depth", "date", "Vn", "Ve");
for k1 = 1:length(H0)
    depth = H0(k1);
    dateStr = datestr(T(k1));
    aEastVel = Ve(k1,:);
    aNorthVel = Vn(k1,:);
    for k2 = 1:length(aEastVel)
      eastVel = aEastVel(k2);
      northVel = aNorthVel(k2);
      number = 1;
      fprintf(f,'%-10s%-10.4f%-24s%-20.8f%-20.8f\n', num2str(number), depth, dateStr, northVel, eastVel);
    end
end
fclose(f);
end


function ADCP = loadADCP(fullFileName)
ADCP = {};
try
  ADCP = rdpadcp(fullFileName,1,'ref','bottom','des','yes');
catch
  disp(['Failed to use the rdpadcp for a file: ' fullFileName]);
  disp('Trying to use the rdradcp');
end
if length(ADCP) ~= 0
    return 
end
try
  ADCP = rdradcp(fullFileName);
catch
  disp(['Failed to use the rdradcp for a file: ' fullFileName]);
end
end

