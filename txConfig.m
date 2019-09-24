function txParams = txConfig()
    txParams.bandWidth = 30e6;
    txParams.QAM = 64;
    txParams.softQAM = 0;
    
    txParams.coding.cc.k = 1;
    txParams.coding.cc.n = 2;
    
    txParams.dataLength = 1000;
    
end