function [errBits] = MainSystem()

    sysPower = 1;
    addpath(genpath('Blocks'));

    %% System Initialisation
    % Random seed set to 100
%     rng(190);
    % Initialising System Parameters
    txParams = txConfig();
    txParams.sysPower = sysPower;
    
    %% Uplink Channel Estimation

    % Simulate UE Uplink Tx
    N = txParams.OFDM.N;
    cp = txParams.OFDM.cp;
    
    ULTx_Stream = UplinkTx(txParams);
    
    % Adding a Single Tap Rayleigh fading channel and AWGN Noise
    UL_Channel = (1 / sqrt(2)) * (randn(1, txParams.numUsers) + 1i * randn(1, txParams.numUsers));
    UL_Noise = 0 * (1 / sqrt(2 * txParams.SNR * N)) * (randn((N + cp), txParams.numUsers) + 1i * randn((N + cp), txParams.numUsers));
    
    ULRx_Stream = ULTx_Stream .* UL_Channel + UL_Noise;
    
    txParams.CSI = UplinkRx(ULRx_Stream, txParams);
    
    x = 10;
    % Detect User signal
    
    % Estimate CSI
    
    %% Calculating the optimal power levels for each user

    % Method 1 - KKT Based Lagrange Multiplier Method

%     w1 = txParams.BWRatio(1);
%     w2 = txParams.BWRatio(2);

    if (txParams.pwrAlloc == 1)

        channelGains = abs(txParams.CSI) .^ 2;
        esp = 0.02;

        w1 = ((channelGains(2) / sum(channelGains))) + esp;
        w2 = ((channelGains(1) / sum(channelGains))) - esp;

        r1 = abs(txParams.CSI(1)) .^ 2;
        r2 = abs(txParams.CSI(2)) .^ 2;

        txParams.powerLevels(2) = txParams.sysPower * ((w1 * r1 - w2 * r2) / (r1 * r2 * (w2 - w1)));
        txParams.powerLevels(1) = txParams.sysPower - txParams.powerLevels(2);

    %% Method 2 - CSI based Power Allocation

    elseif (txParams.pwrAlloc == 2)
    
        for iter_user = 1:txParams.numUsers
            txParams.powerLevels(iter_user) = txParams.sysPower / ((abs(txParams.CSI(iter_user)) .^ 2) * sum(1 ./ (abs(txParams.CSI) .^ 2)));
        end

    %% Method 3 - KKT Optimization with QoS Threshold
       
    elseif (txParams.pwrAlloc == 3)
    
        R1 = 1;
        w1 = 2 ^ R1;

        txParams.powerLevels(1) = ((w1 - 1) / w1) * (txParams.sysPower + (1 / ((abs(txParams.CSI(1)) .^ 2) * txParams.SNR)));

        if (txParams.powerLevels(1) <= 0)
            txParams.powerLevels(1) = 0.1;
        elseif (txParams.powerLevels(1) > txParams.sysPower)
            txParams.powerLevels(1) = txParams.sysPower - 0.1;
        end

        txParams.powerLevels(2) = txParams.sysPower - txParams.powerLevels(1);
    end
    
%     disp(['Power: ', num2str(txParams.powerLevels')]);
    
    txParams.powerLevels = sqrt(txParams.powerLevels);
    
    %% Generating Data

    % Generating random data
    txBitStreamMat = randi([0, 1], txParams.dataLength - txParams.coding.cc.tbl, txParams.numUsers);
    txBitStreamMat = [txBitStreamMat; zeros(txParams.coding.cc.tbl, txParams.numUsers)];
    txParams.test.bits = txBitStreamMat;
    %% Data Processing at Tx
    % Passing the data for transmissioned.

    [txOut, txParams] = Transmitter(txBitStreamMat, txParams);

    %% Channel Model

    % We assume that the CSI is perfectly known at the Tx
    txDataStreamMat = txParams.CSI' .* txOut;

    % Noise and Channel Tap

    SNR = txParams.SNR;
    noiseMat = (max(txParams.powerLevels) / sqrt(2 * SNR)) .* (randn(size(txDataStreamMat)) + (1i) * randn(size(txDataStreamMat)));

    signalPower = norm(txOut) .^ 2;
    noisePower = norm(noiseMat) .^ 2;

    empSNR = signalPower / noisePower;
    empSNRdb = 10 * log10(empSNR);

    rxDataStreamMat = txDataStreamMat + noiseMat;


    %% Receiver
    % Detecting the information from received signal
    rxBitStreamMat = Receiver(rxDataStreamMat, txParams);

    % Error in received bitstream
    errBits = sum(bitxor(txBitStreamMat, rxBitStreamMat));

    if (~errBits)
%         disp('Successful Transmission');
    else
%         disp(['Err Bits: ', num2str(errBits)]);
    end


end