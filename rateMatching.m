function result = rateMatching(pbch)
    % rateMatching Procedure of sub-block interleaving
    % for rate matching of PBCH [TS 38.212, 5.4.1.1]
    arguments
        pbch {mustBeVector,mustBeMember(pbch,[0,1])} % input sequence of bits
    end
    N = length(pbch);
    J = zeros(1,N);
    P = [0 1 2 4 3 5 6 7 8 16 9 17 10 18 11 19 12 20 13 21 14 22 15 ...
        23 24 25 26 28 27 29 30 31]; % interleaving pattern
    i = floor(32*(0:(N-1))/N);
    J(1:N)=P(i+1)*N/32+mod(0:(N-1), N/32);
    sequence(1:N) = pbch(J(1:N)+1); % main procedure
    N = length(sequence); % length of input sequence
    E = 864; % lenght of output sequence [TS 38.212, 7.1.5]
    K = 56; % length of output sequence of polar coder
    if E >= N
        result(1:E) = sequence(mod(0:(E-1),N)+1);
        return
    elseif (K/E) <= (7/16)
        result(1:E) = sequence(1:E+N-E);
        return
    end
    result(1:E) = sequence(1:E);
end