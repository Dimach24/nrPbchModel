function rg=ofdmDemodulator(waveform,Fs,NRB,mu,isCpExt,kmu0)
    arguments
        waveform {mustBeVector,mustBeNonempty}
        Fs (1,1){mustBeInteger,mustBePositive}
        NRB (1,1){mustBeInteger,mustBePositive}
        mu (1,1){mustBeInteger,mustBeInRange(mu,0,6)}
        isCpExt (1,1)logical
        kmu0 (1,1){mustBeInteger}=0
    end
    waveform=reshape(waveform,1,[]);
    Nfft=Fs/(2^mu*nrCom.dFref);
    rg=[];

    NsymbSubframe=nrCom.Nsymb_slot*nrCom.Nslot_subframe(mu);
    cpLen=zeros(1,NsymbSubframe);
    for symb_i=1:NsymbSubframe
        if ~isCpExt
            l=symb_i-1;
            if l==0 || l==7*2^mu
                cpLen(symb_i)=floor((9+2^mu)*Nfft/128);
            else
                cpLen(symb_i)=floor(9*Nfft/128);
            end
        else
            cpLen(symb_i)=floor(Nfft/4);
        end
    end


    l=1;
    i=0;
    while i+Nfft+cpLen(l)<=length(waveform)
        symb=waveform(i+cpLen(l)+1:i+Nfft+cpLen(l));
        rg=[rg fft(symb,Nfft).'];
        i=i+Nfft+cpLen(l);
        l=l+1;
        l=mod(l-1,NsymbSubframe)+1;  
        
    end
    rg=circshift(rg,-Nfft/2,1);
    Nsc=NRB*12;
    zeros_left=(Nfft-Nsc)/2+kmu0;
    zeros_rigth=(Nfft-Nsc)/2-kmu0;
    rg=rg(zeros_left+1:end-zeros_rigth,:);
end







% function rg=ofdmDemodulator(waveform,Fs,NRB,mu,isCpExt)
%     arguments
%         waveform {mustBeVector}
%         Fs (1,1) {mustBeNumeric, mustBePositive}
%         NRB (1,1) {mustBeInteger,mustBePositive}
%         mu (1,1) {mustBeInteger,mustBeInRange(mu,0,6)}
%         isCpExt logical
%     end
%     Fref=15000;
%     Nfref=2048;
%     if Fs~=Fref*Nfref*2^mu
%         waveform=resample(waveform,Fref*Nfref*2^mu,Fs);
%     end
%     symbs=removeCp(waveform,mu,isCpExt);
%     rg=fft(symbs,Nfref,1);
%     rg=fftshift(rg,1);
%     zeros_count=Nfref-NRB*12;
%     rg=rg(zeros_count/2+1:end-zeros_count/2,:);
% end
% 
% function symbs=removeCp(waveform,mu,isCpExt)
%     arguments
%         waveform {mustBeVector}
%         mu (1,1) {mustBeInteger,mustBeInRange(mu,0,6)}
%         isCpExt logical
%     end
%     symbs=[];
%     if isCpExt
%         NsymbSubframe=12*2^mu; % symb per subframe
%     else
%         NsymbSubframe=14*2^mu;
%     end
%     symbStart=1;
%     Nu=2048;
%     l=0;
%     if isCpExt
%         Ncp = 512; % CP length (in samples)
%     else
%         Ncp = 144+2^mu*16*(l == 0 || l == 7*2^mu);
%     end
%     while (symbStart+Ncp+Nu-1<=length(waveform))
%         l = mod(l,NsymbSubframe); % in subframe index
%         if isCpExt
%             Ncp = 512; % CP length (in samples)
%         else
%             Ncp = 144+2^mu*16*(l == 0 || l == 7*2^mu);
%         end
%         symb=waveform(symbStart+Ncp:symbStart+Ncp+Nu-1);
%         symb=reshape(symb,[Nu,1]);
%         symbs=[symbs,symb];
%         symbStart=symbStart+Ncp+Nu;
%         l=l+1;
%     end
% end