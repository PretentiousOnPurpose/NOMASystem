% Generates root Zadoff-Chu Sequence 
function seq = ZCSeq(u, Nzc, q, grph)
    seq = zeros(Nzc, 1);
    cf = mod(Nzc, 2);
    
    for iter_n = 0:1:Nzc-1
        seq(iter_n + 1, 1) = exp((-1i) * pi * iter_n * u * (iter_n + cf + q) / Nzc);
    end
    
    if (grph)
        figure;
        hold on;
        subplot(2, 1, 1);
        plot(real(seq));
        subplot(2, 1, 2);
        plot(imag(seq));
    end
    
end