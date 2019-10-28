clc;
clear all;

%% System Initialisation
% Random seed set to 100
rng(100);
% Initialising System Parameters
txParams = txConfig();

%% Generating Data

% Generating random data
txBitStream = randi([0, 1], txParams.dataLength, txParams.numUsers);

%% Data Processing at Tx
% Passing the data for transmission
txDataStream = Transmitter(txBitStream, txParams);

%% Channel Model



% Noise and Channel Tap

SNR = 10 ^ (txParams.SNRdb / 10);
noise = (1 / sqrt(2 * SNR)) .* (randn(length(txDataStream), 1) + (1i) * randn(length(txDataStream), 1));
rxDataStream = txDataStream + noise;

%% Receiver
% Detecting the information from received signal
rxBitStream = Receiver(rxDataStream, txParams);

% Error in received bitstream
errBits = sum(bitxor(txBitStream, rxBitStream));

if (~errBits)
    disp('Successful Transmission');
else
    disp('Err Bits:');
    disp(errBits);
end