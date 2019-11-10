function txParams = txConfig()
    txParams.QAM = 2;
    txParams.softQAM = 1;
    
    % SNR in db
    txParams.SNRdb = 10;
    
    % Trellis Structure for 1/2 code rate convolution coder obtained from
    % a MATLAB tutorial on channel coding. (Constraint length, M = 7)
    txParams.coding.cc.trellis = poly2trellis(7, {'1 + x^3 + x^4 + x^5 + x^6', '1 + x + x^3 + x^4 + x^6'});
    txParams.coding.cc.tbl = 32;
    txParams.coding.codeRate = 1/2;
    
    % Length of each message of every user
    txParams.dataLength = 960;
    
    % Number of users
    txParams.numUsers = 2;
    
    % Assuming the CSI (Rayleigh Fading)
    txParams.CSI = randn(1, txParams.numUsers) + 1i * (randn(1, txParams.numUsers));
    [~, sortIdx] = sort(abs(txParams.CSI));
    txParams.CSI = txParams.CSI(sortIdx);
    
    % Allocating buffer space for power allocation coefficients
    txParams.powerLevels = zeros(txParams.numUsers, 1);

end