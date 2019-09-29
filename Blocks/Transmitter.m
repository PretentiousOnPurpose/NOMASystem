% Transmitter: Performs data processing operations like scrambling,
%              channel coding, qam modulation, etc.
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
    % ccCode = CCEncoder(data, txParams);
    ccCode = data;
    
    %% QAM
    modData = qammod(ccCode, txParams.QAM, 'InputType', 'bit', 'UnitAveragePower', 1);
       
    %% Power Allocation    
    modDataStream = zeros(txParams.numUsers * length(modData), 1);

    for iter_user = 1:txParams.numUsers
        modDataStream((iter_user - 1) * length(modData) + 1 : iter_user * length(modData), 1) = ...
            txParams.powerLevels(iter_user) .* modData(:, iter_user);
    end
    
end