function [fig, C] = LoadCoastLineMap()
% fig - figure handler
% C - coordinates
% y = kx+b, so: xK, xB, yK, yB - conversion coefficients

rgb = imread('map_cut.png');
xLimReal = [36.3 36.7];
yLimReal = [45.4 45];

gray = rgb2gray(rgb);
f1 = imagesc(gray);
colormap bone
hold on;

xLimMap = get(gca, 'XLim');
yLimMap = get(gca, 'YLim');

set(gca, 'XTick', linspace(xLimMap(1), xLimMap(end), 5));
set(gca, 'YTick', linspace(yLimMap(1), yLimMap(end), 5));

xLimMap = get(gca, 'XLim');
yLimMap = get(gca, 'YLim');

xK = diff(xLimReal) ./ diff(xLimMap);
yK = diff(yLimReal) ./ diff(yLimMap);

xB = xLimReal(2) - xK * xLimMap(2);
yB = yLimReal(2) - yK * yLimMap(2);

xTicksReal = get(gca, 'XTick') .* xK + xB;
yTicksReal = get(gca, 'YTick') .* yK + yB;

xTicksReal = round(xTicksReal .* 1000) ./ 1000;
yTicksReal = round(yTicksReal .* 1000) ./ 1000;

set(gca, 'XTickLabel', num2cell(xTicksReal));
set(gca, 'YTickLabel', num2cell(yTicksReal));

C = 1.0e+03 .* [
   0.898649338374292   0.603741509433962
   1.001836483931947   0.687816981132075
   1.109235349716446   0.771892452830189
   1.214528355387524   0.860171698113207
   1.319821361058601   0.948450943396226
   1.410373345935728   1.045137735849057
   1.496713610586011   1.146028301886792
   1.593583175803403   1.234307547169811
   0.942872400756144   1.667296226415094
   1.029212665406428   1.633666037735849
   1.182940453686200   1.608443396226414
   1.292445179584121   1.587424528301887
   1.418796786389414   1.549590566037735
   1.549360113421550   1.524367924528301
   1.682029300567108   1.503349056603773
   1.802063327032136   1.486533962264151
];

plot(C(:, 1), C(:, 2), '.', 'MarkerSize', 10);
grid on;
fig = gcf;
end

