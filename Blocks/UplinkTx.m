% UplinkTx - Uplink Transmission
% Performs OFDM Modulation of ZC Sequences for each users meant for uplink
% transmission. This will be used as Reference signal for CSI Estimation
function ULTX_Stream = UplinkTx(txParams)
    % Number of users being served by Base Station (BS)
    numUsers = txParams.numUsers;
    
    % OFDM Modulation parameters
    OFDM = txParams.OFDM;
    N = OFDM.N;
    cp = OFDM.cp;
    ULTx = txParams.ULTx;
    
    % Buffers for OFDM Frame and Datastream
    ULTX_Frame = zeros(N, numUsers);
    ULTX_Stream = zeros((N + cp), numUsers);
    
    % OFDM Modulation
    ULTX_Frame(OFDM.DataCarriers, :) = ULTx.zcSeq;
    ULTX_Frame = circshift(ULTX_Frame, N / 2);
    ULTX_Frame = ifft(ULTX_Frame, N);
    
    for iter_user = 1: numUsers 
        ULTX_Stream(1: cp, iter_user) = ULTX_Frame(end - cp + 1: end, iter_user);
        ULTX_Stream(cp + 1: N + cp, iter_user) = ULTX_Frame(:, iter_user);
    end
end