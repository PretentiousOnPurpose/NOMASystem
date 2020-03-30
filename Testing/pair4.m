function set = pair4(vec)
    set = zeros(4, 3);
    for iter = 1: 3
        set(:, iter) = [vec(iter, :), vec(length(vec) - iter + 1, :)];
    end
    set = set';
end
