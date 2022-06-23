function task_12_read_structure()

global DEBUG
DEBUG = true;

myDir = 'task13_data';
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
   
   isNewStyleTreatment = true;
   [H0s, Ves, Vns, Ts] = treatData(H0, Ve, Vn, T, isNewStyleTreatment);
   
   if DEBUG && min(size(Vns)) > 1
    figure(1); subplot(211); mesh(Vn); subplot(212); mesh(Vns);
   end
   
   writeADCPData([fullFileName '_output_task_13.txt'], H0s, Ves, Vns, Ts);
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
Vn = ADCP.north_vel;
Ve = ADCP.east_vel;
T = ADCP.mtime;
try
  H0=ADCP.config.range+ADCP.config.adcp_depth;
catch
  H0 = ADCP.depth;
end
if ~all(H0) % just make H0 having 1:length(H0) array if all
            % of elements are zeros.
  H0 = 1:length(H0); 
end
if size(H0,2) == 1 && size(H0,1) ~= 1
    H0 = H0';
end
if (length(H0) == size(Vn,2)) && (length(H0) ~= size(Vn,1))
    Vn = Vn';
end
if (length(H0) == size(Ve,2)) && (length(H0) ~= size(Ve,1))
    Ve = Ve';
end
end


function [H0, Ve, Vn, T] = treatData(H0, Ve, Vn, T, isNewStyleTreatment, coef)
if isNewStyleTreatment
    coef.horizontal = 20;
    coef.vertical = 20;
    [H0, Ve, Vn, T] = preformNewStyleTreatment(H0, Ve, Vn, T, coef);
else
    % `rdi_read_moored_plotout_ADCP_BLackSea_Feodosiya_03092019.m`
    L0 = 60;
    Vn(L0+1:end,:)=[];
    Ve(L0+1:end,:)=[];
    H0(L0+1:end)=[];
    Ves = smoothdata(Ve,2,'movmean',73,'omitnan');
    Vns = smoothdata(Vn,2,'movmean',73,'omitnan');
    Vn = Vns;
    Ve = Ves;
end
end


function writeADCPData(fullFileName, H0, Ve, Vn, T)
assert(size(Ve,1) == size(Vn,1));
assert(size(Ve,2) == size(Vn,2));
assert(length(H0) == size(Ve,1));
assert(length(T) == size(Ve,1) || length(T) == size(Ve,2));
isTimeHasDepthSize = length(H0) == length(T);
fprintf(1, 'Saving %s\n', fullFileName);
f = fopen(fullFileName,'w');
fprintf(f, '%-10s%-10s%-24s%-20s%-20s\n', "station", "depth", "date", "Vn", "Ve");
for k1 = 1:length(H0)
    depth = H0(k1);
    aEastVel = Ve(k1,:);
    aNorthVel = Vn(k1,:);
    for k2 = 1:length(aEastVel)
      if isTimeHasDepthSize; timeIdx = k1; else; timeIdx = k2; end
      dateStr = datestr(T(timeIdx));
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


function [H0s, Ves, Vns, Ts] = preformNewStyleTreatment(H0, Ve, Vn, T, coef)
% param[in] H0, Ve, Vn, T   The data for being smoothed.
% param[in] coef            A structure that contains `horizontal` and `vertical`
%                           fields. The result data will be having `coef` time less
%                           points per array during the smoothing

[lenHorizontal, lenVertical] = size(Vn);
assert(lenHorizontal == length(H0), 'Length of the depth vector `H0` is not equal to the vertical size of the matrix');

lenHorizontalSmoothed = ceil(lenHorizontal * coef.horizontal / 100.0);
lenVerticalSmoothed = ceil(lenVertical * coef.vertical / 100.0);

Ves = sr_smooth_matrix(Ve, [lenHorizontalSmoothed lenVerticalSmoothed]);
Vns = sr_smooth_matrix(Vn, [lenHorizontalSmoothed lenVerticalSmoothed]);
H0s = sr_smooth_matrix(H0, [1 lenHorizontalSmoothed]);

% time vector is different for rdradcp and rdpadcp
assert(length(T) == lenHorizontal || length(T) == lenVertical);
if length(T) == lenVertical
  Ts = sr_smooth_matrix(T, [1 lenVerticalSmoothed]);
end
if length(T) == lenHorizontal
  Ts = sr_smooth_matrix(T, [1 lenHorizontalSmoothed]);
end

end



