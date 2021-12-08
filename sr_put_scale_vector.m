function sr_put_scale_vector(ax, screenCoef, xyScreenRatio, textPosStyle, scaleText, arrowLength)
red = [0.8 0 0];

xlim = get(ax, 'XLim');
ylim = get(ax, 'YLim');
x = xlim(1) + 0.05* (xlim(2) - xlim(1));
y = ylim(1) + 0.95* (ylim(2) - ylim(1));

if ~exist('xyScreenRatio','var')
    xyScreenRatio = 1.0;
end
if ~exist('arrowLength','var')
    arrowLength = 1.0
end

sr_visualize_profiles(ax, 0.0, arrowLength, x, y, red, screenCoef, xyScreenRatio);
% sr_visualize_profiles(ax, 1.0, 0.0, x, y, [0 1 0], screenCoef, xyScreenRatio);

if ~exist('textPosStyle', 'var')
    textPosStyle = 'tr';
end

if ~exist('scaleText','var')
   scaleText = '1.0 cm/s';
end

sr_text(ax, x, y, scaleText, textPosStyle, red);
end
