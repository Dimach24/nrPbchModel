function result = interleavePbchPayload(pbch)
    %See TS 38.212 clause 7.1.1
    arguments
        pbch {mustBeVector,mustBeMember(pbch,[0,1])}
    end
    A = length(pbch);
    A_ = A-8;
    G = nrCom.PbchPayloadInterleaverPattern;
    jSFN = 0;
    jHRF = 10;
    jSSB = 11;
    jOTHER = 14;
    result = zeros(1,32);
    for i=1:A
        if (i >= 2 && i <= 7)||(i >= A_+1 && i <= A_+4) %SFN bits
            result(G(jSFN+1)+1)=pbch(i);
            jSFN = jSFN+1;
        elseif i == A_+5 %HRF
            result(G(jHRF+1)+1)=pbch(i);
        elseif i >= A_+6 && i<=A+8 % L_massive
            result(G(jSSB+1)+1)=pbch(i);
            jSSB = jSSB+1;
        else
            result(G(jOTHER+1)+1)=pbch(i);
            jOTHER = jOTHER+1;
        end
    end
end