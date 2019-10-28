% Channel Decoder: Performs convolution decoding of the multi-user encoded
%                  data matrix
%
% Input: encodedData, txParams
%        encodedData    - A matrix containing convolutionally encoded 
%                         information of multiple user where each user is 
%                         assigned one column.
%        txParams       - A structure containing system parameters like
%                         number of users, code rate, qam alphabet etc.
%
% Output: data   - A matrix containing information of multiple user
%                         where each user is assigned one column.
%

function data = channelDecoding(encodedData, txParams)   
    % Perform convolutional decoding
    if (txParams.softQAM)
        data = vitdec(encodedData, txParams.coding.cc.trellis, 34, 'cont', 'unquant');
    else
        data = vitdec(encodedData, txParams.coding.cc.trellis, 34, 'trunc', 'hard');
    end
end