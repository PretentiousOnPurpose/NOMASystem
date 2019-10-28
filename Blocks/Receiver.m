% Receiver: Performs data processing operations like SIC,
%           channel decoding, qam demodulation, etc at the receiver end.
% Input: rxData, txParams
%        rxData         - A qam modulated data stream containing information
%                         of multiple users
%        txParams       - A structure containing system parameters like
%                         number of users, code rate, qam alphabet etc.
%
% Output: data -          A matrix containing information of multiple user
%                         where each user is assigned one column.
%

function data = Receiver(rxData, txParams)
    %% Successive Interference Cancellation

    decodedSignal = rxData;
    for iter_user = 1:txParams.numUsers
        % Detecting the signal in increasing order of the SNR / Channel
        % Conditions
        decodedData(:, iter_user) = qamdemod(decodedSignal / txParams.powerLevels(iter_user), txParams.QAM, 'OutputType', 'bit', 'UnitAveragePower', true);
        
        decodedData(:, iter_user) = channelDecoding(decodedData(:, iter_user), txParams);
        
        % Reconstructing the modulated signal for currently detected
        % baseband user signal
        
        decodedData(:, iter_user) = channelEncoding(decodedData(:, iter_user), txParams);
        
        y_hat = qammod(decodedData(:, iter_user), txParams.QAM, 'InputType', 'bit', 'UnitAveragePower', 1);
        % Removing intereferring signals  
        decodedSignal = decodedSignal - txParams.powerLevels(iter_user) .* y_hat;        
    end
end