clc;
clear all;
close all;

N = 1024;
cp = N / 8;

SNRdb = 5;
SNR = 10 ^ (SNRdb / 10);

seq1 = lteZadoffChuSeq(3, (N - 18) / 2);
X1 = [zeros(6, 1); seq1; zeros(6, 1); seq1; zeros(6, 1)];
x1 = ifft(X1, N);
x1_cp = [x1(end - cp + 1: end); x1];

h = (1 / sqrt(2)) * (randn(1, 1) + 1i * randn(1, 1));
noise = (1 / sqrt(2 * SNR * N)) * (randn((N + cp), 1) + 1i * randn((N + cp), 1));

rxSeq = h .* x1_cp + noise;

rxSeq = rxSeq(cp + 1: end);
rxSeq = fft(rxSeq, N);

ref1 = rxSeq(7: 509);
ref2 = rxSeq(516: 1018);

h_hat = mean([mean(ref1 ./ seq1); mean(ref2 ./ seq1)]);



