clc;close;clear;

NRB=100;
%% Usefull
% Downlink configuration
cfgDL = nrDLCarrierConfig;
cfgDL.Label = 'Carrier1';
cfgDL.FrequencyRange = 'FR1';
cfgDL.ChannelBandwidth = 60;
cfgDL.NCellID = 17;
cfgDL.NumSubframes = 10;
cfgDL.InitialNSubframe = 0;
cfgDL.WindowingPercent = 0;
cfgDL.SampleRate = [];
cfgDL.CarrierFrequency = 4e9;

% SCS specific carriers
scscarrier = nrSCSCarrierConfig;
scscarrier.SubcarrierSpacing = 30;
scscarrier.NSizeGrid = NRB;
scscarrier.NStartGrid = 3;

cfgDL.SCSCarriers = {scscarrier};

% Bandwidth Parts
bwp = nrWavegenBWPConfig;
bwp.BandwidthPartID = 1;
bwp.Label = 'BWP1';
bwp.SubcarrierSpacing = 30;
bwp.CyclicPrefix = 'normal';
bwp.NSizeBWP = NRB;
bwp.NStartBWP = 3;

cfgDL.BandwidthParts = {bwp};

% Synchronization Signals Burst
ssburst = nrWavegenSSBurstConfig;
ssburst.Enable = true;
ssburst.Power = 0;
ssburst.BlockPattern = 'Case B';
ssburst.TransmittedBlocks = ones([1 8]);
ssburst.Period = 20;
ssburst.NCRBSSB = 19;
ssburst.KSSB = 0;
ssburst.DataSource = 'MIB';
ssburst.DMRSTypeAPosition = 2;
ssburst.CellBarred = false;
ssburst.IntraFreqReselection = false;
ssburst.PDCCHConfigSIB1 = 254;
ssburst.SubcarrierSpacingCommon = 15;

cfgDL.SSBurst = ssburst;
%% SUPER IMPORTANT
cfgDL.CSIRS{1}.Enable=false;
cfgDL.PDSCH{1}.Enable=false;
cfgDL.PDCCH{1}.Enable=false;
%% Generation
[toolbox_waveform,info] = nrWaveformGenerator(cfgDL);

Fs = info.ResourceGrids(1).Info.SampleRate;

%%
mib=struct();
mib.SFN=0;
mib.subCarrierSpacingCommon=nrCom.SCSCommon.scs15or60;
mib.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos2;
mib.pdcch_ConfigSIB1=254;
mib.cellBarred=nrCom.CellBared.notBarred;
mib.intraFreqReselection=nrCom.IntraFreqReselection.notAllowed;
[rg,dbg]=createFrame( ...
    round(log2(scscarrier.SubcarrierSpacing/15)), ...
    NRB, ...
    ssburst.KSSB, ...
    bwp.NStartBWP, ...
    ssburst.NCRBSSB,...
    cfgDL.NCellID, ...
    ones(1,8), ...
    'B', ...
    cfgDL.CarrierFrequency,...
    mib, ...
    0);
%%
figure
subplot(1,2,2)
pcolor(abs(rg)); shading flat;
title("MODEL FRAME RG")
subplot(1,2,1)
pcolor(abs(nrOFDMDemodulate(toolbox_waveform,NRB,15,0))); shading flat;
title("MATLAB TOOLBOX RG")
%%

waveform=ofdmModulator(rg,bwp.NStartBWP,round(log2(scscarrier.SubcarrierSpacing/15)),0);

received=ofdmDemodulator( ...
    waveform, ...
    2048*15000*2^round(log2(scscarrier.SubcarrierSpacing/15)), ...
    NRB, ...
    round(log2(scscarrier.SubcarrierSpacing/15)), ...
    0);
% 
% received=ofdmDemodulator( ...
%     toolbox_waveform, ...
%     Fs, ...
%     NRB, ...
%     round(log2(scscarrier.SubcarrierSpacing/15)), ...
%     0);

% received=ofdmDemodulator( ...
%     load("waveStruct.mat","waveStruct").waveStruct.waveform, ...
%     Fs, ...
%     NRB, ...
%     round(log2(scscarrier.SubcarrierSpacing/15)), ...
%     0);



% received=nrOFDMDemodulate(toolbox_waveform,NRB,scscarrier.SubcarrierSpacing,0,"Nfft",2048);
%%

figure
subplot(1,2,1)
pcolor(abs(rg)); shading flat;
title("SOURCE RG")
subplot(1,2,2)
pcolor(abs(received)); shading flat;
title("DEMODULATED RG")
%%
% close
k0=79;
l0=5;
% ssb=received(k0:k0+239,l0:l0+4);
ssb=received(k0:k0+239,l0:l0+4-1);

figure;pcolor(abs(rg(k0:k0+239,l0:l0+4)));shading flat;xlim([1,5])
title("SSB");
%%
[~,Lbarmax]=nrCom.blocksByCase('B',cfgDL.CarrierFrequency,0);
[sym,dmrs]=parseSsb(ssb,0,0,cfgDL.NCellID);

pbch=qpskDemodulate(sym);

ibarSsb=extractBlockIndex(dmrs,cfgDL.NCellID);
pbch=scramblePbch(pbch,cfgDL.NCellID,Lbarmax,ibarSsb);
pbch=rateRecovery(pbch);
pbch=polarDecoding(pbch);
[pbch,validation_success]=verifyParity(pbch,nrCom.CrcType.crc24c);
pbch=scramblePbchPayload(pbch,cfgDL.NCellID,Lbarmax);
pbch=deinterleavePbchPayload(pbch);
pld=parsePayload(pbch,Lbarmax);
disp(pld);

%% %
% corr=xcorr(waveform,toolbox_waveform,'normalized');
% 
% plot(abs(corr))
% 
% 
