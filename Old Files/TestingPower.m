function TestingPower()
    powerLevels = 6:2:26;
    powerLevels = (10 .^ (powerLevels ./ 10)) / 1000;
    numIter = 1000;
    
    errBits = zeros(length(powerLevels), 2);

    for iter_pwr = 1:length(powerLevels)
        for iter = 1:numIter
            [tmpErr] = MainSystem(powerLevels(iter_pwr));
            errBits(iter_pwr, :) = errBits(iter_pwr, :) + tmpErr;
        end
        errBits(iter_pwr, :) = errBits(iter_pwr, :) ./ numIter;
    
        disp(['Iter - Power: ', num2str(powerLevels(iter_pwr)), ' done']);
    end

    save('errBits', 'errBits');
    
end