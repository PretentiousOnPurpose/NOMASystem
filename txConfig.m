function txParams = txConfig()
    txParams.bandWidth = 30e6;
    txParams.QAM = 64;
    txParams.softQAM = 0;
    txParams.SNRdb = 10;
    
    txParams.coding.cc.k = 1;
    txParams.coding.cc.n = 2;
    
    txParams.dataLength = 960;
    
    txParams.numUsers = 5;
    
    % Allocate Power levels
    txParams.powerLevels = linspace(1, txParams.numUsers, txParams.numUsers)';
    
end