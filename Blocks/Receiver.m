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

function data = Receiver(rxDataStream, txParams)
    
    % System Parameters
    N = txParams.OFDM.N;
    cp = txParams.OFDM.cp;
    numOFDMSyms = txParams.slotLen;

    data = zeros(txParams.dataLength, txParams.numUsers);
    
    % OFDM Demodulator
    modDataMat = zeros(N, numOFDMSyms);
    
    for iter_syms = 1: numOFDMSyms
        currSym = rxDataStream((iter_syms - 1) * (N + cp) + cp + 1: iter_syms * (N + cp), 1);
        modDataMat(:, iter_syms) = currSym;
    end
    
    modDataMat = fft(modDataMat, N) / sqrt(N);
    modDataMat = fftshift(modDataMat);
    
    % Extracting Superposed Signal
    modDataMat = modDataMat(txParams.OFDM.DataCarriers(1: txParams.numUsers / 2), :);

    % SIC
    for iter_pairs = 1: txParams.numUsers / 2
        pair_data = modDataMat(iter_pairs, :)';
        for iter_user = 1: 2
            H = txParams.CSI(txParams.userPairs(iter_pairs, iter_user));
            H_hat = txParams.est_CSI(txParams.userPairs(iter_pairs, iter_user));
            
            pair_data = H * pair_data; % Adding Channel effect
            pair_data = pair_data / H_hat; % Equalising Channel effect
            for iter_sic = 1: iter_user
                P = txParams.powerCoeffs(txParams.userPairs(iter_pairs, iter_sic), 1);

                demodData = qamdemod(pair_data ./ sqrt(P), txParams.QAM, 'UnitAveragePower', 1, 'OutputType', 'approxllr');
                usr_data = channelDecoding(demodData, txParams);

                enc_data = channelEncoding(usr_data, txParams);
                modData = qammod(enc_data, txParams.QAM, 'UnitAveragePower', 1, 'InputType', 'bit');

                pair_data = pair_data - H_hat * sqrt(P) * modData;
            end
            data(:, txParams.userPairs(iter_pairs, iter_user)) = usr_data;
        end
    end
    
end