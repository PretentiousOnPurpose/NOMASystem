function srates = sumRate()
    % System Power
    sysPower = 0.1;

    % Noise Variance set at -70 dbm
    SNR = 1e10;
    
    % Number of users
    numUsers = 2;
    
    numTrails = 10000;
    
    Rmins = 0.5:0.25:5;
    srates = zeros(length(Rmins), 1);
    cvar = 0;
    for iter_Rmin = 1:length(Rmins)
        for iter = 1:numTrails
            % CSI
            CSI = (1 / (sqrt(2))) * (randn(numUsers, 1) + 1i * (randn(numUsers, 1)));
            [~, sortIdx] = sort(abs(CSI) .^ 2, 'ascend');
            CSI = CSI(sortIdx);

            % Power Allocation    
            w1 = 2 ^ Rmins(iter_Rmin);
            powerLevels(1) = ((w1 - 1) / w1) * (sysPower + (1 / ((abs(CSI(1)) .^ 2) * SNR)));

            if (powerLevels(1) <= 0)
                powerLevels(1) = 0.1;
            elseif (powerLevels(1) > sysPower)
                powerLevels(1) = sysPower - 0.1;
            end

            powerLevels(2) = sysPower - powerLevels(1);

            tmpRate = log2(1 + ((abs(CSI(2)) .^ 2) * powerLevels(2) * SNR) / (1 + sysPower * cvar)) + log2(1 + ((abs(CSI(1)) .^ 2) * powerLevels(1) * SNR) / (1 + (abs(CSI(1)) .^ 2) * powerLevels(2) + sysPower * cvar));
            srates(iter_Rmin, 1) = srates(iter_Rmin, 1) + tmpRate;
        end
    end
    
    srates = srates ./ numTrails;     
end