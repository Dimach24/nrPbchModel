function c = pseudoRandomSequence(c_init, M_PN)
    % pseudoRandomSequence generates Gold sequence [TS 38.211, clause 5.2.1]
    arguments
    c_init (1,1){mustBeInteger}%  init sequence
    M_PN (1,1) {mustBeInteger}% pseudo-random sequence size
    end
    N_C = 1600;
    x1 = zeros(1,N_C+M_PN);
    x2 = zeros(1,N_C+M_PN);
    x1(1) = 1;
    x1(2:31) = 0;
    x2(1:31) = fliplr(dec2bin(c_init,31)); %c_init
    for n = 1:M_PN+N_C-31
        x1(n+31) = mod(x1(n+3)+x1(n),2);
        x2(n+31) = mod(x2(n+3)+x2(n+2)+x2(n+1)+x2(n),2);
    end
    n1 = 1:M_PN;
    c(n1) = mod(x1(n1+N_C)+x2(n1+N_C),2);
end