% Transmitter: Performs data processing operations like power allocation,
%              channel coding, qam modulation, etc. at the Transmitter End
% Input: data, txParams
%        data           - A matrix containing information of multiple user
%                         where each user is assigned one column.
%        txParams       - A structure containing system parameters like
%                         number of users, code rate, qam alphabet etc.
%
% Output: modDataStream - A column vector containing qam modulated information of
%                         the user data (after additional processing like
%                         channel coding, scrambling, etc).
%

function [modDataStream, txParams] = Transmitter(data, txParams)  
    %% Channel Coding
    
    % Allocating buffer for encoding
    encodedData = zeros(length(data) / txParams.coding.codeRate, txParams.numUsers);
    for iter_user = 1:txParams.numUsers
        encodedData(:, iter_user) = channelEncoding(data(:, iter_user), txParams);
    end
    
    %% QAM
    modData = qammod(encodedData, txParams.QAM, 'InputType', 'bit', 'UnitAveragePower', 1);
    
    %% Power Allocation    
    
    % User Pairing
    txParams.userPairs = zeros(txParams.numUsers / 2, 2);
    
    for iter_pairs = 1: txParams.numUsers / 2
        txParams.userPairs(iter_pairs, 1) = txParams.CSI(txParams.sorted_CSI_Idx(iter_pairs), 1);
        txParams.userPairs(iter_pairs, 2) = txParams.CSI(txParams.sorted_CSI_Idx(txParams.numUsers - iter_pairs + 1), 1);
    end
    % Calculate Power coefficients for each pair
    txParams.powerCoeffs = zeros(txParams.numUsers, 1);
    
    if (txParams.pwrAllocMthd == 1)
        for iter_pairs = 1: txParams.numUsers / 2
            txParams.powerCoeffs(txParams.sorted_CSI_Idx(iter_pair, 1), 1) = (sqrt(1 + txParams.sysPower * abs(txParams.est_CSI(txParams.sorted_CSI_Idx(iter_pair, 1), 2)) .^ 2) - 1) / (txParams.sysPower * abs(txParams.est_CSI(txParams.sorted_CSI_Idx(iter_pair, 1), 2)));
            txParams.powerCoeffs(txParams.sorted_CSI_Idx(iter_pair, 2), 1) = txParams.sysPower - txParams.powerCoeffs(txParams.sorted_CSI_Idx(iter_pair, 1), 1);
        end
    elseif (txParams.pwrAllocMthd == 2)
        for iter_pairs = 1: txParams.numUsers / 2
            txParams.powerCoeffs(txParams.sorted_CSI_Idx(iter_pair, 1), 1) = (sqrt(1 + txParams.sysPower * abs(txParams.est_CSI(txParams.sorted_CSI_Idx(iter_pair, 1), 2)) .^ 2) - 1) / (txParams.sysPower * abs(txParams.est_CSI(txParams.sorted_CSI_Idx(iter_pair, 1), 2)));
            txParams.powerCoeffs(txParams.sorted_CSI_Idx(iter_pair, 2), 1) = txParams.sysPower - txParams.powerCoeffs(txParams.sorted_CSI_Idx(iter_pair, 1), 1);
        end        
    end
    
    % Assign them to OFDM 
    N = txParams.OFDM.N;
    cp = txParams.OFDM.cp;
    numDataCarriers = length(txParams.OFDM.DataCarriers);
    
    modDataFrame = zeros(N, modLen / numDataCarriers);
    modDataStream = zeros(N + cp, modLen / numDataCarriers);    
    
    
end