close all;

data = randi([0 1], 200, 1);
modData = qammod(data, 4, 'InputType', 'bit');

x1 = ZCSeq(3, 100, 0, 0);
x2 = ZCSeq(7, 100, 0, 0);
x3 = ZCSeq(11, 100, 0, 0);
x4 = ZCSeq(13, 100, 0, 0);
x = x1 .* modData + x2 .* modData + x3 .* modData + x4 .* modData;
n = (1 / sqrt(2)) * randn(47, 1) + 1i * randn(47, 1);
h = (1 / sqrt(2)) * randn(1, 1) + 1i * randn(1, 1);
y = h .* x;

cx1 = xcorr(y, x1);
plot(abs(cx1));

