function tests=payload_test
    tests = functiontests(localfunctions);
end
function setupOnce(~)
    cd ../
end
function teardownOnce(~)
    cd Tests
end
function l64Test(tc)
    MIB=struct();
    MIB.SFN=121;
    MIB.subCarrierSpacingCommon=nrCom.SCSCommon.scs30or120;
    MIB.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos3;
    MIB.pdcch_ConfigSIB1=120;
    MIB.cellBarred=nrCom.CellBared.notBarred;
    MIB.intraFreqReselection=nrCom.IntraFreqReselection.allowed;
    Lmax=64;
    block_index=17;
    kssb=11;
    half_frame=1;
    pld=genPayload( ...
        Lmax,block_index,kssb,0,MIB.SFN, half_frame, ...
        MIB.subCarrierSpacingCommon, MIB.dmrsTypeAPosition, ...
        MIB.pdcch_ConfigSIB1, MIB.cellBarred, MIB.intraFreqReselection, 0 ...
        );
    pld=parsePayload(pld,Lmax);
    verifyEqualIgnoringType(tc,pld.choiceBit,0,"choice bit");
    verifyEqualIgnoringType(tc,pld.SFN,MIB.SFN,"SFN");
    verifyEqualIgnoringType(tc,pld.halfFrame,half_frame,"half-radio-frame bit");
    verifyEqualIgnoringType(tc,pld.kssb,kssb,'kssb');
    verifyEqualIgnoringType(tc,pld.blockIndexMsb,bitand(block_index,0x38),'ibarssb MSB');
    verifyEqualIgnoringType(tc,pld.dmrsTypeAPosition,MIB.dmrsTypeAPosition,'mib data');
    verifyEqualIgnoringType(tc,pld.cellBared,MIB.cellBarred,'mib data');
    verifyEqualIgnoringType(tc,pld.intraFreqReselection,MIB.intraFreqReselection,'mib data');
    verifyEqualIgnoringType(tc,pld.pdcch_ConfigSIB1,MIB.pdcch_ConfigSIB1,'mib data');
    verifyEqualIgnoringType(tc,pld.subCarrierSpacingCommon,MIB.subCarrierSpacingCommon,'mib data');
end

function l20Test(tc)
    MIB=struct();
    MIB.SFN=121;
    MIB.subCarrierSpacingCommon=nrCom.SCSCommon.scs30or120;
    MIB.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos3;
    MIB.pdcch_ConfigSIB1=120;
    MIB.cellBarred=nrCom.CellBared.notBarred;
    MIB.intraFreqReselection=nrCom.IntraFreqReselection.allowed;
    Lmax=20;
    block_index=17;
    kssb=22;
    half_frame=1;
    pld=genPayload( ...
        Lmax,block_index,kssb,0,MIB.SFN, half_frame, ...
        MIB.subCarrierSpacingCommon, MIB.dmrsTypeAPosition, ...
        MIB.pdcch_ConfigSIB1, MIB.cellBarred, MIB.intraFreqReselection, 0 ...
        );
    pld=parsePayload(pld,Lmax);
    verifyEqualIgnoringType(tc,pld.choiceBit,0,"choice bit");
    verifyEqualIgnoringType(tc,pld.SFN,MIB.SFN,"SFN");
    verifyEqualIgnoringType(tc,pld.halfFrame,half_frame,"half-radio-frame bit");
    verifyEqualIgnoringType(tc,pld.kssb,kssb,'kssb');
    verifyEqualIgnoringType(tc,pld.blockIndexMsb,bitand(block_index,0x38),'ibarssb MSB');
    verifyEqualIgnoringType(tc,pld.dmrsTypeAPosition,MIB.dmrsTypeAPosition,'mib data');
    verifyEqualIgnoringType(tc,pld.cellBared,MIB.cellBarred,'mib data');
    verifyEqualIgnoringType(tc,pld.intraFreqReselection,MIB.intraFreqReselection,'mib data');
    verifyEqualIgnoringType(tc,pld.pdcch_ConfigSIB1,MIB.pdcch_ConfigSIB1,'mib data');
    verifyEqualIgnoringType(tc,pld.subCarrierSpacingCommon,MIB.subCarrierSpacingCommon,'mib data');
end
function l10Test(tc)
    MIB=struct();
    MIB.SFN=121;
    MIB.subCarrierSpacingCommon=nrCom.SCSCommon.scs30or120;
    MIB.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos3;
    MIB.pdcch_ConfigSIB1=120;
    MIB.cellBarred=nrCom.CellBared.notBarred;
    MIB.intraFreqReselection=nrCom.IntraFreqReselection.allowed;
    Lmax=10;
    block_index=9;
    kssb=23;
    half_frame=1;
    pld=genPayload( ...
        Lmax,block_index,kssb,0,MIB.SFN, half_frame, ...
        MIB.subCarrierSpacingCommon, MIB.dmrsTypeAPosition, ...
        MIB.pdcch_ConfigSIB1, MIB.cellBarred, MIB.intraFreqReselection, 0 ...
        );
    pld=parsePayload(pld,Lmax);
    verifyEqualIgnoringType(tc,pld.choiceBit,0,"choice bit");
    verifyEqualIgnoringType(tc,pld.SFN,MIB.SFN,"SFN");
    verifyEqualIgnoringType(tc,pld.halfFrame,half_frame,"half-radio-frame bit");
    verifyEqualIgnoringType(tc,pld.kssb,kssb,'kssb');
    verifyEqualIgnoringType(tc,pld.blockIndexMsb,bitand(block_index,0x38),'ibarssb MSB');
    verifyEqualIgnoringType(tc,pld.dmrsTypeAPosition,MIB.dmrsTypeAPosition,'mib data');
    verifyEqualIgnoringType(tc,pld.cellBared,MIB.cellBarred,'mib data');
    verifyEqualIgnoringType(tc,pld.intraFreqReselection,MIB.intraFreqReselection,'mib data');
    verifyEqualIgnoringType(tc,pld.pdcch_ConfigSIB1,MIB.pdcch_ConfigSIB1,'mib data');
    verifyEqualIgnoringType(tc,pld.subCarrierSpacingCommon,MIB.subCarrierSpacingCommon,'mib data');
end
function l8Test(tc)
    MIB=struct();
    MIB.SFN=121;
    MIB.subCarrierSpacingCommon=nrCom.SCSCommon.scs30or120;
    MIB.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos3;
    MIB.pdcch_ConfigSIB1=120;
    MIB.cellBarred=nrCom.CellBared.notBarred;
    MIB.intraFreqReselection=nrCom.IntraFreqReselection.allowed;
    Lmax=8;
    block_index=6;
    kssb=23;
    half_frame=1;
    pld=genPayload( ...
        Lmax,block_index,kssb,0,MIB.SFN, half_frame, ...
        MIB.subCarrierSpacingCommon, MIB.dmrsTypeAPosition, ...
        MIB.pdcch_ConfigSIB1, MIB.cellBarred, MIB.intraFreqReselection, 0 ...
        );
    pld=parsePayload(pld,Lmax);
    verifyEqualIgnoringType(tc,pld.choiceBit,0,"choice bit");
    verifyEqualIgnoringType(tc,pld.SFN,MIB.SFN,"SFN");
    verifyEqualIgnoringType(tc,pld.halfFrame,half_frame,"half-radio-frame bit");
    verifyEqualIgnoringType(tc,pld.kssb,kssb,'kssb');
    verifyEqualIgnoringType(tc,pld.blockIndexMsb,bitand(block_index,0x38),'ibarssb MSB');
    verifyEqualIgnoringType(tc,pld.dmrsTypeAPosition,MIB.dmrsTypeAPosition,'mib data');
    verifyEqualIgnoringType(tc,pld.cellBared,MIB.cellBarred,'mib data');
    verifyEqualIgnoringType(tc,pld.intraFreqReselection,MIB.intraFreqReselection,'mib data');
    verifyEqualIgnoringType(tc,pld.pdcch_ConfigSIB1,MIB.pdcch_ConfigSIB1,'mib data');
    verifyEqualIgnoringType(tc,pld.subCarrierSpacingCommon,MIB.subCarrierSpacingCommon,'mib data');
end
function verifyEqualIgnoringType(testCase, actual, expected,diagnostic)
    testCase.verifyEqual(double(actual), double(expected),diagnostic);
end