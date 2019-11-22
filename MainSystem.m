% clc;
clear all;

addpath(genpath('Blocks'));

%% System Initialisation
% Random seed set to 100
% rng(100);
% Initialising System Parameters
txParams = txConfig();

%% Power Allocation
% We calculate the optimal values for power allocation coefficients using
% the method of Lagrange Multipliers. This approach is known as the water
% filling algorithm.

% The total power available for allocation
txParams.sysPower = 17.5; 

% The noise variance is assumed to be 1 but it is later scaled to the
% meet the SNR criteria.

%% Calculating the optimal power levels for each user

%% Method 1 - Channel Inversion
for iter_user = 1: txParams.numUsers
    txParams.powerLevels(iter_user) = iter_user * 2 / txParams.CSI(iter_user);
end

txParams.powerLevels = [4 1];

%% Generating Data

% Generating random data
txBitStreamMat = randi([0, 1], txParams.dataLength - txParams.coding.cc.tbl, txParams.numUsers);
txBitStreamMat = [txBitStreamMat; zeros(txParams.coding.cc.tbl, txParams.numUsers)];
txParams.test = txBitStreamMat;
%% Data Processing at Tx
% Passing the data for transmissioned.

txOut = Transmitter(txBitStreamMat, txParams);

%% Channel Model

% We assume that the CSI is perfectly known at the Tx
txDataStreamMat = txParams.CSI' .* txOut;

% Noise and Channel Tap

SNR = 10 ^ (txParams.SNRdb / 10);
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
