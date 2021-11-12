function r = sr_corr(x, y, maxlag)

assert(length(x) == length(y), '[ ! ] Input arrays must have same lengths');

if ~exist('maxlag', 'var')
    maxlag = max(length(x), length(y)) - 1;
end

r = findR(x,y,maxlag);

% subplot(211);
% plot(1:length(x), x, 1:length(y), y);
% 
% subplot(212);
% stem(r);
end

function r = findR(x,y,maxlag)
% r - array 2N-1. N - max length of x or y
Nx = length(x);
Ny = length(y);
N = max(Nx,Ny);
r = zeros(1, 2*maxlag+1);

lags = N-maxlag:N+maxlag;
for k = 1:length(lags)
    lag = lags(k);
    subx = x(max(1,Nx-lag+1):min(Nx,Nx+Nx-lag));
    suby = y(max(1,lag-Ny+1):min(lag,Ny));
    r(k) = foo(subx, suby);
end
end

function r = foo(x,y)
% r - single coef
xm = mean(x);
ym = mean(y);
r = sum((x-xm).*(y-ym)) ./ sqrt(sum((x-xm).^2)*sum((y-ym).^2));
end
