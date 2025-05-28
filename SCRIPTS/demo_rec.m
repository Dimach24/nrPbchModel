clc;close all;clear all;
waveform = load("waveform.mat").waveform;
subcarrierSpacing=60;
NRB=100;
kSSB=0;
NStart=3;
NCRBSSB = 19;
NCellID=17;
carrierFrequency = 4e9;

received=ofdmDemodulator( ...
    waveform, ...
    2048*15000*2^round(log2(subcarrierSpacing/15)), ...
    NRB, ...
    round(log2(subcarrierSpacing/15)), ...
    0);

pcolor(abs(received)); shading flat;
title("DEMODULATED RG")

k0=22;
l0=5;
ssb=received(k0:k0+239,l0:l0+4-1);


[~,Lbarmax]=nrCom.blocksByCase('B',carrierFrequency,0);
[sym,dmrs]=parseSsb(ssb,0,0,NCellID);
ibarSsb=extractBlockIndex(dmrs,NCellID);

softbits=pbchLikehood(sym,dmrs,genPbchDmRs(NCellID,ibarSsb).');
softbits=descramblePbch(softbits,NCellID,Lbarmax,ibarSsb);
softbits=rateRecovery(softbits);
pbch=polarDecoding(softbits);

[pbch,validation_success]=verifyParity(pbch,nrCom.CrcType.crc24c);
if(validation_success)
    printf("Validation success")
else
    printf("Validation failure")
end
pbch=scramblePbchPayload(pbch,NCellID,Lbarmax);
pbch=deinterleavePbchPayload(pbch);
pld=parsePayload(pbch,Lbarmax);
disp(pld);