function setMat = genSets(users)
    if (length(users) == 4)
        comboSet = nchoosek(users, 2);
        setMat = pair4(comboSet);
    else
        numLevels = (length(users) - 6) / 2;
        setMat = zeros(prod(5 + 2 * numLevels:-2:1), length(users));        
        for iter_users = 2: length(users)
            modUserSet = setdiff(users, [users(1); users(iter_users)]);
            if (numLevels > 0)
                pairSet = genSets(modUserSet);
            else
                comboSet = nchoosek(modUserSet, 2);
                pairSet = pair4(comboSet);                
            end
            setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 1) = users(1);
            setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 2) = users(iter_users); 
            setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 3:end) = pairSet;           
        end
    end
end




% function setMat = genSets(users)
%     if (length(users) == 4)
%         comboSet = nchoosek(users, 2);
%         setMat = pair4(comboSet);
%     elseif (length(users) == 6)
%         setMat = zeros(prod(length(users) - 1:-2:1), length(users));
%         for iter_users = 2: length(users)
%             modUserSet = setdiff(users, [users(1); users(iter_users)]);
%             comboSet = nchoosek(modUserSet, 2);
%             pairSet = pair4(comboSet);
%             setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 1) = users(1);
%             setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 2) = users(iter_users); 
%             setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 3:end) = pairSet;
%         end
%     elseif (length(users) > 6)
%         numLevels = (length(users) - 6) / 2;
%         setMat = zeros(prod(5 + 2 * numLevels:-2:1), length(users));        
%         for iter_users = 2: length(users)
%             modUserSet = setdiff(users, [users(1); users(iter_users)]);
%             pairSet = genSets(modUserSet);
%             setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 1) = users(1);
%             setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 2) = users(iter_users); 
%             setMat((iter_users - 2) * size(pairSet, 1) + 1: (iter_users - 1) * size(pairSet, 1), 3:end) = pairSet;           
%         end
%     end
% end
