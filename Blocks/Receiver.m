% Receiver: Performs data processing operations like descrambling,
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
    
end