clc;
clear all;

% rng(2020);

SNR_Rangedb = -10:1:15;
SNR_Range = 10 .^ (SNR_Rangedb ./ 10);
numTrails = 2500;

mse = zeros(length(SNR_Range), 2);

for iter_trail = 1: numTrails
    for iter_SNR = 1: length(SNR_Range)
        txParams = txConfig();
        
        N = txParams.OFDM.N;
        cp = txParams.OFDM.cp;
        CSI = txParams.CSI;
        

            UL_Noise = (1 / sqrt(2 * SNR_Range(iter_SNR) * N)) * (randn((N + cp), txParams.numUsers) + 1i * randn((N + cp), txParams.numUsers));
            ulRx = ulTx .* CSI' + UL_Noise;

        CSI_hat = UplinkRx(ulRx, txParams);   

        err = (abs(CSI - CSI_hat) .^ 2);
        mse(iter_SNR, 1) = mse(iter_SNR, 1) + err(1);
        mse(iter_SNR, 2) = mse(iter_SNR, 2) + err(2);
    end    
end

mse = mse ./ numTrails;

plot(SNR_Rangedb, mse(:, 1));
hold on;
plot(SNR_Rangedb, mse(:, 2));
saveas(gcf, 'CSIErr');
