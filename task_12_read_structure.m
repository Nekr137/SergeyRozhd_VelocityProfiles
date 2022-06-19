function task_12_read_structure()
% Программа сканирует все файлы в `myDir` директории.

myDir = 'task13_data'; % указываем имя директории, где ищем файлы для конвертации
myFiles = dir(fullfile(myDir,'*.000')); % извлекаем все пути до файлов, оканчивающихся на .000

for k = 1:length(myFiles) % цикл по всем файлам, `k` - индекс цикла
   baseFileName = myFiles(k).name; % берём имя `k`-того имя файла
   fullFileName = fullfile(myDir, baseFileName); % полный путь до этого файла
   fprintf(1, 'Now converting %s\n', fullFileName); % вывод в консоль матлаба


   %% конвертация с помощью rdradcp (расскомментировать, чтобы работало)
   % convertFile(fullFileName); 

   %% конвертация с помощью rdpadcp
   convertFile2(fullFileName);
end
end

function convertFile2(fname)
% Функция, конвертирующая данные с помощью подпрограммы rdpadcp
% Часть кода взята из программы
% rdi_read_moored_plotout_ADCP_BLackSea_Feodosiya_03092019.m

if (~exist(fname, 'file')) % Если вдруг файл `fname` не существует
    disp('Failed to find a file'); % выводим это в консоль матлаба
end


% try-блок. Если что-то случится в этом блоке (например файл не существует или повреждён)
% то будет выполнен catch-блок
try 
    % Здесь мы пытаемся загрузить данные. 
    % Файл данных тяжелый, поэтому, один раз загрузив,
    % мы можем его сохранить в виде *.mat файла.
    % И при следущей попытки загрузить этот же файл мы
    % просто загружаем этот *.mat файл, который загрзуится быстро.
    % Это что-то типа кэша.

    cachedFilename = [fname '_cached_task13.mat']; % придумаем имя кэш-файла
    
    if isfile(cachedFilename) % если кэш файл уже имеется, 
        load(cachedFilename, 'ADCP'); % то загружаем кэш
    else                                                  % иначе
        ADCP=rdpadcp(fname,1,'ref','bottom','des','yes'); % грзуим сам файл. 
        save(cachedFilename, 'ADCP');                     % И сохраняем (кэшируем)
    end
catch % если что-то случилось
    disp(['failed to proc ' fname ' using the rdpadcp']); % то выводим в консоль
end

% Извлекаем данные из структуры ADCP
% Код ниже скопирован из функции
% `rdi_read_moored_plotout_ADCP_BLackSea_Feodosiya_03092019.m`

Vn=ADCP.north_vel; % Извлекаем из структуры north_vel
Ve=ADCP.east_vel;% Извлекаем из структуры east_vel
Vz=ADCP.vert_vel;% Извлекаем из структуры vert_vel
t=ADCP.mtime; % извлекаем из структуры mtime
L0=60;
H0=ADCP.config.range+ADCP.config.adcp_depth; % глубина (равна `range` + `adcp_depth` из настроек)
Vn(L0+1:end,:)=[]; % обрезаем последние глубины, оставляем только `L0` первых штук
Ve(L0+1:end,:)=[]; % обрезаем последние глубины, оставляем только `L0` первых штук
Vz(L0+1:end,:)=[]; % обрезаем последние глубины, оставляем только `L0` первых штук
H0(L0+1:end)=[]; % обрезаем последние глубины, оставляем только `L0` первых штук
V=sqrt(Vn.*Vn+Ve.*Ve); % амплитуда скорости (здесь не используется сейчас)
Ves=smoothdata(Ve,2,'movmean',73,'omitnan'); % сглаживание Ve скользящее среднее, игнорируем NaN
Vns=smoothdata(Vn,2,'movmean',73,'omitnan'); % cглаживание Vn скользящее среднее, игнорируем NaN
Vs=sqrt(Vns.*Vns+Ves.*Ves); % амплитуда скорости (здесь не используется сейчас)

f = fopen([fname '_output_task_13.txt'],'w'); % открываем файл на запись
fprintf(f, "%-10s%-10s%-24s%-20s%-20s\n", "station", "depth", "date", "Vn", "Ve"); % пишем столбцы-шапку

for k1 = 1:length(H0) % цикл по глубинам, индекс - `k1`
    depth = H0(k1); % берём `k1`-ю глубину
    dateStr = datestr(t(k1)); % конвертируем utc формат даты в строку
    aEastVel = Ves(k1,:);     % берём `e` скорости для `k1`-й глубины
    aNorthVel = Vns(k1,:);    % берём `n` скорости для `k1`-й глубины
    for k2 = 1:length(aEastVel)  % цикл по скоротям, индекс - `k2`
      eastVel = aEastVel(k2); % берём `k2`-ю `e` скорость `k1`-й глубины
      northVel = aNorthVel(k2); % берём `k2`-ю `n` скорость `k1`-й глубины
      number = 1; % просто номер 1, чтобы было что вывести здесь. Можно вставить станции какие-нибудь, например.
      fprintf(f,"%-10s%-10.4f%-24s%-20.8f%-20.8f\n", num2str(number), depth, dateStr, northVel, eastVel); % пишем строку в файл
    end
end
fclose(f); % закрываем файл
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
