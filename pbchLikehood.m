function lr=pbchLikehood(pbch,dmrs,ref_dmrs)
    dmrs=dmrs/mean(abs(dmrs));
    [~,sigma2]=measureSNR(dmrs,ref_dmrs);
    lr=nan(1,length(pbch)*2);
    for i=1:length(pbch)
        [lr(2*i-1), lr(2*i)]=awgnQpskLR(pbch(i),sigma2);
    end
end

function w=awgnW(actual,expected,sigma2)
    w=exp(-1*abs(actual-expected).^2/sigma2);
end
function [LR1, LR2]=awgnQpskLR(actual,sigma2)
    w01=awgnW(actual,qpskModulate([0 0]),sigma2)+awgnW(actual,qpskModulate([0 1]),sigma2);
    w02=awgnW(actual,qpskModulate([0 0]),sigma2)+awgnW(actual,qpskModulate([1 0]),sigma2);
    w11=awgnW(actual,qpskModulate([1 0]),sigma2)+awgnW(actual,qpskModulate([1 1]),sigma2);
    w12=awgnW(actual,qpskModulate([0 1]),sigma2)+awgnW(actual,qpskModulate([1 1]),sigma2);
    disp(w01==1-w11)
    LR1=w01/w11;
    LR2=w02/w12;
end
function [SNR,sigma2]=measureSNR(dmrs_actual,dmrs_expected)
    noise=dmrs_actual-dmrs_expected;
    sigma2=sum(abs(noise).^2);
    SNR=sum(abs(dmrs_expected).^2)/sigma2;
end