function txParams = txConfig()
    txParams.QAM = 4;
    txParams.softQAM = 1;
    
    % SNR Config
    txParams.SNRdb = 10;
    txParams.SNR = 10 ^ (txParams.SNRdb / 10);
    
    % Trellis Structure for 1/2 code rate convolution coder obtained from
    % a MATLAB tutorial on channel coding. (Constraint length, M = 7)
    txParams.coding.cc.trellis = poly2trellis(7, {'1 + x^3 + x^4 + x^5 + x^6', '1 + x + x^3 + x^4 + x^6'});
    txParams.coding.cc.tbl = 32;
    txParams.coding.codeRate = 1/2;
    
    % Length of each message of every user
    txParams.dataLength = 3000;
    
    
    txParams.slotLen = txParams.dataLength;
    % Number of users
    txParams.numUsers = 2;
    
%     % Assuming the CSI (Rayleigh Fading)
% %     txParams.CSI = randn(txParams.numUsers, 1);
%     txParams.CSI = (1 / (sqrt(2))) * (randn(txParams.numUsers, 1) + 1i * (randn(txParams.numUsers, 1)));
%     [~, sortIdx] = sort(abs(txParams.CSI) .^ 2, 'ascend');
%     txParams.CSI = 1; %txParams.CSI(sortIdx);
% 
% %     disp(['Channel: ', num2str(txParams.CSI')]);
%     
    %% Power Allocation
    % We calculate the optimal values for power allocation coefficients using
    % the method of Lagrange Multipliers. 

    % The total power available for allocation
    txParams.sysPower = 5; 

    % The noise variance is assumed to be 1 but it is later scaled to the
    % meet the SNR criteria.

    txParams.pwrAllocMthd = 2;

    %% OFDM Symbol Structure
    OFDM.N = 64;
    OFDM.cp = OFDM.N / 8;
    OFDM.GuardInt1 = 0;
    OFDM.GuardInt2 = 0;
    OFDM.DCSpacing = 5;
    OFDM.DCSpacingCarriers = OFDM.N / 2 - ((OFDM.DCSpacing - 1) / 2): OFDM.N / 2 + ((OFDM.DCSpacing - 1) / 2); 
    OFDM.numDataCarriers = OFDM.N - OFDM.GuardInt1 - OFDM.GuardInt2 - OFDM.DCSpacing;
    OFDM.DataCarriers = setdiff(1:OFDM.N, OFDM.DCSpacingCarriers);
    
    txParams.OFDM = OFDM;
    
   %% Uplink Transmission Parameters

    ULTx.zcRoots = nthprime(1: txParams.numUsers + 1);
    ULTx.zcLen = OFDM.numDataCarriers;
    ULTx.zcRoots = setdiff(ULTx.zcRoots, [ULTx.zcLen]);
    ULTx.zcSeq = zeros(ULTx.zcLen, txParams.numUsers);
    
    for iter_user = 1: txParams.numUsers
        ULTx.zcSeq(:, iter_user) = lteZadoffChuSeq(ULTx.zcRoots(iter_user), ULTx.zcLen);
    end
 
    txParams.ULTx = ULTx;
    
end