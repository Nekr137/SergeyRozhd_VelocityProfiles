function sr_load_coastline_map(ax)
% fig - figure handler

rgb = imread('map_cut.png');
xLimReal = [36.3 36.7];
yLimReal = [45.4 45];

gray = rgb2gray(rgb);
im = imagesc(ax, xLimReal, yLimReal, gray);
% im.AlphaData = .5;
axes(ax);
colormap bone;
hold on;
set(ax, 'YDir', 'normal'); % Made y axis normal
grid on;
axis square;
end

