function TestingSNR()
    SNRRange = 0:2.5:30;
    numIter = 1000;
    
    errBits = zeros(length(SNRRange), 2);
    empSNR = zeros(length(SNRRange), 1);

    for iter_SNR = 1:length(SNRRange)
        for iter = 1:numIter
            [tmpErr, tmpSNR] = MainSystem(SNRRange(iter_SNR));
            errBits(iter_SNR, :) = errBits(iter_SNR, :) + tmpErr;
            empSNR(iter_SNR, 1) = empSNR(iter_SNR, 1) + tmpSNR;
        end
        errBits(iter_SNR, :) = errBits(iter_SNR, :) ./ numIter;
        empSNR(iter_SNR, 1) = empSNR(iter_SNR, 1) ./ numIter;
    
        disp(['Iter - SNR(db): ', num2str(empSNR(iter_SNR, 1)), ' done']);
    end

    save('empSNR', 'empSNR');
    save('errBits', 'errBits');
    
end