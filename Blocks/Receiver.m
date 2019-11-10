% Receiver: Performs data processing operations like SIC,
%           channel decoding, qam demodulation, etc at the receiver end.
% Input: rxDataStreamMat, txParams
%        rxDataStreamMat - A qam modulated data stream containing information
%                          of multiple users
%        txParams        - A structure containing system parameters like
%                          number of users, code rate, qam alphabet etc.
%
% Output: data -          A matrix containing information of multiple user
%                         where each user is assigned one column.
%

function data = Receiver(rxDataStreamMat, txParams)
    %% Successive Interference Cancellation
    
    % Allocating required buffer size
    data = zeros(txParams.dataLength, txParams.numUsers);
    
    for iter_channel = 1:txParams.numUsers
        rxDataStream = rxDataStreamMat(:, iter_channel);
        for iter_user = 1:iter_channel
            % Detecting the signal in increasing order of the SNR / Channel
            % Conditions
            if (txParams.softQAM)
                decodedData = qamdemod(rxDataStream / (txParams.powerLevels(iter_user) * txParams.CSI(iter_channel)), txParams.QAM, 'OutputType', 'approxllr', 'UnitAveragePower', true);
            else
                decodedData = qamdemod(rxDataStream / (txParams.powerLevels(iter_user) * txParams.CSI(iter_channel)), txParams.QAM, 'OutputType', 'bit', 'UnitAveragePower', true);
            end
            decodedData = channelDecoding(decodedData, txParams);

            % Reconstructing the modulated signal for currently detected
            % baseband user signal
            encodedData = channelEncoding(decodedData, txParams);

            y_hat = qammod(encodedData, txParams.QAM, 'InputType', 'bit', 'UnitAveragePower', 1);
            % Removing intereferring signals  
            rxDataStream = rxDataStream - (txParams.powerLevels(iter_user) * txParams.CSI(iter_channel)) .* y_hat;      

        end
        
        data(:, iter_channel) = decodedData;
    end
end