clc;
clear all;
close all;

rng(2020);

seq1 = exp(1i * 2 * pi * 3 * (0:1:99)' / 100);
x1 = randi([0 3], 100, 1);
y1 = qammod(x1, 4, 'UnitAveragePower', 1);
z1 = y1 .* seq1;

seq2 = exp(1i * 2 * pi * 20 * (0:1:99)' / 100);
x2 = randi([0 3], 100, 1);
y2 = qammod(x2, 4, 'UnitAveragePower', 1);
z2 = y2 .* seq2;

z = z1 + z2;
y1_hat = z .* conj(seq1);
y1_hat = lowpass(y1_hat, 5, 100);
x1_hat = qamdemod(y1_hat, 4, 'UnitAveragePower', 1);
