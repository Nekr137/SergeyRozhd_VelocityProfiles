function test_sr_smooth_matrix()

test1();
test2();

end

function test1()
m = ones(5);
ms = sr_smooth_matrix(m, [1 1]);
[nx,ny] = size(ms);
assert(nx == 1);
assert(ny == 1);
assert(ms == 1);
end

function test2()
[X,Y] = meshgrid(-8:.1:8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
z = sr_smooth_matrix(Z,[20 20]);

figure;
subplot(211);
mesh(Z);
subplot(212);
mesh(z);

end