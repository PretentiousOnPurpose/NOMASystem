clc;
clear all;
close all;

N = 16;

users = 1:1:N;

CSI = (1 / sqrt(2)) * (randn(N, 1) + 1i * randn(N, 1));
CSI = sort(CSI);

sets = paircombs(N);
sumRates = zeros(size(sets, 1), 1);

for iter_sets = 1: size(sets, 1)
    for iter_pairs = 1:2:N
        m = sets(iter_sets, iter_pairs);
        n = sets(iter_sets, iter_pairs + 1);
        
        if (n < m)
            tmp = m;
            m = n;
            n = tmp;
        end
        
        a = (sqrt(1 + abs(CSI(m)) .^ 2) - 1) / (abs(CSI(m)) .^ 2);
        Rm = log2(1 + (abs(CSI(m)) .^ 2) * (1 - a) / (abs(CSI(m)) .^ 2) * a + 1);
        Rn = log2(1 + (abs(CSI(n)) .^ 2) * a);
        sumRates(iter_sets) = sumRates(iter_sets) + Rm + Rn;
    end
end

bestCombo = find(sumRates == max(sumRates));
disp(sets(bestCombo, :));