function [samples,sr] = ofdmModulator( ...
        rg, NGridStart, mu, isCpExtended, ...
        mu_maxSCS,NGridStart_maxSCS,Nsc_maxSCS)
    arguments
        rg {mustBeNumeric}
        NGridStart (1,1) {mustBeInteger,mustBeNonnegative}
        mu (1,1) {mustBeInteger,mustBeInRange(mu,0,6)}
        isCpExtended (1,1) logical
        mu_maxSCS = -1
        NGridStart_maxSCS = -1
        Nsc_maxSCS = -1
    end

    Nsc=size(rg,1);

    if (mu_maxSCS == -1)
        mu_maxSCS=mu;
        NGridStart_maxSCS=NGridStart;
        Nsc_maxSCS=Nsc;
    end


    Nsc_rb=nrCom.Nsc_rb;
    Nsymb=size(rg,2);
    k0 = Nsc_rb*NGridStart + Nsc/2 - ...
        (NGridStart_maxSCS*Nsc_rb + Nsc_maxSCS/2)*2^(mu_maxSCS-mu);

    Nfft=2^ceil(log2(Nsc+abs(k0)));
    rg=[zeros((Nfft-Nsc)/2+k0,Nsymb); rg ;zeros((Nfft-Nsc)/2-k0,Nsymb)];
    rg=circshift(rg,Nfft/2,1);
    symbs=ifft(rg,Nfft,1);
    cpLen=zeros(1,Nsymb);
    for i=1:Nsymb
        if isCpExtended
            cpLen(i)=floor(Nfft/4);
        elseif mod(i-1,14*2^mu)==0 || mod(i-1,14*2^mu)==7*2^mu
            cpLen(i)=floor((9+2^mu)*Nfft/128);
        else
            cpLen(i)=floor(9*Nfft/128);
        end
    end
    samples=zeros(1,Nfft*Nsymb+sum(cpLen));
    start=1;
    for i=1:Nsymb
        samples(start:(start+Nfft+cpLen(i)-1))=[ symbs(end-cpLen(i)+1:end,i).' symbs(:,i).'];
        start=start+Nfft+cpLen(i);
    end
    sr=Nfft*2^mu*nrCom.dFref;
end
