function result = scramblePbchPayload(payload, NCellId, Lbarmax)
    % Scrambling before CRC attachment [7.1.2, TS 38.212]
    arguments
        payload logical {mustBeVector} % input sequence (boolean vector)
        NCellId (1,1)  {mustBeInteger} % cell ID
        Lbarmax (1,1)    {mustBeInteger}% maximum number of candidate SS/PBCH blocks in half frame [4.1, TS 38.213]
    end

    % init
    A = length(payload);
    s = zeros(1,A);
    M = A-3 - (Lbarmax == 10) - 2*(Lbarmax == 20) - 3*(Lbarmax == 64);

    % nu = [payload(1+6) payload(1+24)]; % 3rd & 2nd LSB of SFN are stored in
    % nu = bit2int(nu.',2);           % bits 6 & 24 of interleaved sequence
    nu = payload(1+6)*2 + payload(1+24);

    % determination of c
    c = pseudoRandomSequence(NCellId,160);

    % determination of s
    i = 0;
    j = 0;
    while i < A
        s_null_cond = i == 6 || i == 24 || ...
            i == 0 || (i == 2)&&(Lbarmax == 10) || ...
            ((i == 2)||(i == 3))&&(Lbarmax == 20) || ...
            ((i == 2)||(i == 3)||(i == 5))&&(Lbarmax == 64);
        if  ~s_null_cond
            s(1+i) = c(1+j+nu*M);
            j = j+1;
        else
            s(1+i) = 0;
        end
        i = i+1;
    end

    % scrambling procedure
    result = zeros (1,A);
    for i = 1:A
        result(i) = mod(payload(i)+ s(i),2);
    end
end