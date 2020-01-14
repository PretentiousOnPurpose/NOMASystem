function ULTX_Stream = UplinkTx(txParams)
    numUsers = txParams.numUsers;
    OFDM = txParams.OFDM;
    N = OFDM.N;
    cp = OFDM.cp;
    ULTx = txParams.ULTx;
    
    ULTX_Frame = zeros(N, numUsers);
    ULTX_Stream = zeros((N + cp), numUsers);
    
    ULTX_Frame(OFDM.DataCarriers, :) = ULTx.zcSeq;
    ULTX_Frame = fftshift(ULTX_Frame);
    ULTX_Frame = ifft(ULTX_Frame, N);
    
    for iter_user = 1: numUsers 
        ULTX_Stream(1: cp, iter_user) = ULTX_Frame(end - cp + 1: end, iter_user);
        ULTX_Stream(cp + 1: N + cp, iter_user) = ULTX_Frame(:, iter_user);
    end
end