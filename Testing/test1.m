clc;
clear all;
close all;

rng(2020);

seq1 = zadoffChuSeq(3, 47);
seq2 = zadoffChuSeq(5, 47);
seq3 = zadoffChuSeq(7, 47);

x1 = randi([0 1], 2 * 47, 1);
x2 = randi([0 1], 2 * 47, 1);
x3 = randi([0 1], 2 * 47, 1);

% z1 = qammod(x1, 4, 'InputType', 'bit', 'UnitAveragePower', 1);
% z2 = qammod(x2, 4, 'InputType', 'bit', 'UnitAveragePower', 1);
% z3 = qammod(x3, 4, 'InputType', 'bit', 'UnitAveragePower', 1);

z1 = 1 + 1i;
z2 = 2 + 2i;
z3 = 3 + 3i;

m1 = z1 .* seq1;
m2 = z2 .* seq2;
m3 = z3 .* seq3;

y = m1 + m2 + m3;
