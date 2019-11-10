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

function modDataStream = Transmitter(data, txParams)  
    %% Channel Coding
    
    % Allocating buffer for encoding
    encodedData = zeros(length(data) / txParams.coding.codeRate, txParams.numUsers);
    
    for iter_user = 1:txParams.numUsers
        encodedData(:, iter_user) = channelEncoding(data(:, iter_user), txParams);
    end
    %% QAM
    
    modData = qammod(encodedData, txParams.QAM, 'InputType', 'bit', 'UnitAveragePower', 1);
       
    %% Power Allocation    
    
    % Allocating required buffer space
    modDataStream = zeros(length(modData), 1);
    
    % Iterating over each user and raising the power of the
    % respective signal
    for iter_user = 1:txParams.numUsers
        modDataStream = modDataStream + txParams.powerLevels(iter_user) .* modData(:, iter_user);
    end
    
end