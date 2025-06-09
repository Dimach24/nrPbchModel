clc;close all;clear all;
% waveform =awgn(load("waveform.mat").waveform,-10,"measured");
waveform=load("waveform.mat").waveform;
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

%%
close all
winsize=round(length(waveform)/560/200)*2;
win=hamming(winsize);
[s_, f_, t_]=spectrogram(waveform,win,ceil(winsize/200),1024,2048*15000*2^round(log2(subcarrierSpacing/15)));
imagesc(t_*1e3, f_/1e6, abs(s_));
ax=gca;
ax.YDir="normal";
xlim([0 3]);
ylim([70 120]);
colorbar off
ylabel("Частота, МГц")
xlabel("Время, мс")
figure
pcolor(abs(received)); shading flat;
xlabel("OFDM-символы")
ylabel("Поднесущие")
xlim([1 560/10*3])
%%
k0=22;
l0=5;
% k0=79;
% l0=5;
ssb=received(k0:k0+239,l0:l0+4-1);


[~,Lbarmax]=nrCom.blocksByCase('B',carrierFrequency,0);
[sym,dmrs]=parseSsb(ssb,0,0,NCellID);
ibarSsb=extractBlockIndex(dmrs,NCellID);
%%
close all;
figure
myscatter(sym(1:20),1.1);
t = sqrt(2)/2;
hold on
scatter([t -t -t t], [t t -t -t],20, Marker="o",MarkerEdgeColor="blue",MarkerFaceColor="blue")
hold off
clear t;
xlabel("Re(A)")
ylabel("Im(A)")
grid on
%%
softbits=pbchLikehood(sym,dmrs,genPbchDmRs(NCellID,ibarSsb).');
softbits=descramblePbch(softbits,NCellID,Lbarmax,ibarSsb);
softbits=rateRecovery(softbits);
pbch=polarDecoding(softbits);

[pbch,validation_success]=verifyParity(pbch,nrCom.CrcType.crc24c);
if(validation_success)
    fprintf("Validation success\n")
else
    fprintf("Validation failure\n")
end
pbch=scramblePbchPayload(pbch,NCellID,Lbarmax);
pbch=deinterleavePbchPayload(pbch);
pld=parsePayload(pbch,Lbarmax);
disp(pld);