function r = sr_corr(x, y)

assert(length(x) == length(y), '[ ! ] Input arrays must have same lengths');
r = findR(x,y);

% subplot(211);
% plot(1:length(x), x, 1:length(y), y);
% 
% subplot(212);
% stem(r);
end

function r = findR(x,y)
% r - array 2N-1. N - max length of x or y
Nx = length(x);
Ny = length(y);
N = max(Nx,Ny);
r = zeros(1, 2*N-1);
for lag = 1:2*N-1
    subx = x(max(1,Nx-lag+1):min(Nx,Nx+Nx-lag));
    suby = y(max(1,lag-Ny+1):min(lag,Ny));
    r(lag) = foo(subx, suby);
end
end

function r = foo(x,y)
% r - single coef
xm = mean(x);
ym = mean(y);
r = sum((x-xm).*(y-ym)) ./ sqrt(sum((x-xm).^2)*sum((y-ym).^2));
end
