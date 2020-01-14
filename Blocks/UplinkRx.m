function CSI = UplinkRx(ULRx_Stream, txParams)
    numUsers = txParams.numUsers;
    N = txParams.OFDM.N;
    cp = txParams.OFDM.cp;
    DataCarriers = txParams.OFDM.DataCarriers;
    
    CSI = zeros(numUsers, 1); 
    
    for iter_user = 1: numUsers
        ULRx_User = ULRx_Stream(cp + 1: N + cp, iter_user);
        ULRx_User = fft(ULRx_User);
        ULRx_User = fftshift(ULRx_User);
        ULRx_User_Data = ULRx_User(DataCarriers, 1);
        CSI(iter_user, 1) = mean(ULRx_User_Data ./ txParams.ULTx.zcSeq(:, iter_user));
    end
    
end