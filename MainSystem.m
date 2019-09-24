clc;
clear all;

% Random seed set to 100
rng(100);
% Initialising System Parameters
txParams = txConfig();
% Generating random data
txBitStream = randi([0, 1], txParams.dataLength, 1);

% Passing the data for transmission
txDataStream = Transmitter(txBitStream, txParams);

% Noise and Channel Tap
rxDataStream = txDataStream;

% Detecting the information from received signal
rxBitStream = Receiver(rxDataStream, txParams);

% Error in received bitstream
errBits = sum(bitxor(txBitStream, rxBitStream));

if (~errBits)
    disp('Successful Transmission');
else
    disp('Failure');
end