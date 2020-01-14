function srates = sumRatePwr()
%     rng(101);

    % Min Sum Rate
    Rmin = 1;

    % Noise Variance set at -70 dbm
    SNR = 1e10;
    
    % Number of users
    numUsers = 3;
    
    
    numTrails = 100000;
    
    pwrsDBM = -20:2:26;
    pwrs = 0.001 .* (10 .^ (pwrsDBM ./ 10));
    srates = zeros(length(pwrs), 1);
    cvar = 0.01;
    for iter_pwr = 1:length(pwrs)
        
        for iter = 1:numTrails
            % CSI
            CSI = (1 / (sqrt(2))) * (randn(numUsers, 1) + 1i * (randn(numUsers, 1)));
            [~, sortIdx] = sort(abs(CSI) .^ 2, 'ascend');
            CSI = CSI(sortIdx);

            % Power Allocation    
            minRate = [2 ^ Rmin; 2 ^ Rmin; 2 ^ Rmin];
            
            sysPower = pwrs(iter_pwr);
            powerLevels = zeros(numUsers, 1);
            for iter_user = 1:numUsers - 1
                t1 = ((minRate(iter_user) - 1) * sysPower);
                for iter_t1 = iter_user:-1:1
                    t1 = t1 / minRate(iter_t1);
                end
                
                t2 = (minRate(iter_user) - 1) * (sysPower * cvar + (1 / SNR)) / ((abs(CSI(iter_user)) .^ 2) * minRate(iter_user));
                
                t3 = 0;
                
                for iter_t3Sum = iter_user - 1:-1:1
                    t3Tmp = (minRate(iter_user) - 1) * (sysPower * cvar + (1 / SNR)) * (minRate(iter_t3Sum) - 1) / (abs(CSI(iter_t3Sum) .^ 2));
                    
                    for iter_t3Mul = iter_user:-1:iter_t3Sum
                        t3Tmp = t3Tmp / (minRate(iter_t3Mul));
                    end
                    
                    t3 = t3 + t3Tmp;
                end
                
                powerLevels(iter_user) = t1 + t2 - t3;
                if (powerLevels(iter_user) > sysPower)
                    powerLevels(iter_user) = sysPower;
                    break;
                end
            end
            
            powerLevels(numUsers) = sysPower - sum(powerLevels);
            powerLevels(powerLevels < 0) = 0;
            
            tmpRate = 0;
            
            for iter_user = 1:numUsers
                tmpRate = tmpRate + log2(1 + ((abs(CSI(iter_user)) .^ 2) * powerLevels(iter_user)) / ((1/SNR) + sysPower * cvar + ((abs(CSI(iter_user)) .^ 2) * sum(powerLevels(iter_user + 1:end)))));
            end
 
            srates(iter_pwr, 1) = srates(iter_pwr, 1) + tmpRate;
        end
    end
    
    srates = srates ./ numTrails;     
    
%  figure;
% hold on;
% plot(pwrsDBM, m2, '-or');
% plot(pwrsDBM, m3, '-og');
% plot(pwrsDBM, m4, '-ob');    
%     
% plot(pwrsDBM, m2c, '-*r');
% plot(pwrsDBM, m3c, '-*g');
% plot(pwrsDBM, m4c, '-*b');
end