function MainSystem()

    sysPower = 1;
    addpath(genpath('Blocks'));

    %% System Initialisation
    % Random seed set to 2020
    rng(2020);

    % Initialising System Parameters
    txParams = txConfig();
    txParams.sysPower = sysPower;
    
    %% Uplink Channel Estimation

    % Simulate UE Uplink Tx
    N = txParams.OFDM.N;
    cp = txParams.OFDM.cp;
    
    ULTx_Stream = UplinkTx(txParams);
    
    % Adding a Single Tap Rayleigh fading channel and AWGN Noise
    txParams.CSI = (1 / sqrt(2)) * (randn(1, txParams.numUsers) + 1i * randn(1, txParams.numUsers));
    UL_Noise = (1 / sqrt(2 * txParams.SNR * N)) * (randn((N + cp), txParams.numUsers) + 1i * randn((N + cp), txParams.numUsers));
    ULRx_Stream = ULTx_Stream .* txParams.CSI + UL_Noise;
    
    % Estimating CSI
    txParams.est_CSI = UplinkRx(ULRx_Stream, txParams);
    [~, txParams.sorted_CSI_Idx] = sort(txParams.est_CSI, 'descend');
    
    %% Generating Data

    % Generating random data
    txBitStreamMat = randi([0, 1], txParams.dataLength - txParams.coding.cc.tbl, txParams.numUsers);
    txBitStreamMat = [txBitStreamMat; zeros(txParams.coding.cc.tbl, txParams.numUsers)];
    %% Data Processing at Tx
    % Passing the data for transmission

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
        disp('Successful Transmission');
    else
        disp(['Err Bits: ', num2str(errBits)]);
    end


end