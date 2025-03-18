function tests=massive_test
    tests = functiontests(localfunctions);
end
function setupOnce(~)
    cd ../
end
function teardownOnce(~)
    cd Tests
end
function pld=pld
    pld=[0   0   0   0   0   0   0   1   0   1   1   1   0   0   1   1   0   0   1   1   1   0   1   0   0   0   0   0   1   1   0   0];
end
function verifyEqualIgnoringType(testCase, actual, expected,diagnostic)
    arguments
        testCase 
        actual 
        expected 
        diagnostic='' 
    end
    testCase.verifyEqual(double(actual), double(expected),diagnostic);
end

function bin_test(tc)
    kssb=23;
    NCellID=17;
    freq=4e9;
    half_frame=1;
    mib=struct();
    mib.SFN=0;
    block_index=1;

    mib.subCarrierSpacingCommon=nrCom.SCSCommon.scs30or120;
    mib.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos2;
    mib.pdcch_ConfigSIB1=103;
    mib.cellBarred=nrCom.CellBared.barred;
    mib.intraFreqReselection=nrCom.IntraFreqReselection.notAllowed;
    [~,Lbarmax]=nrCom.blocksByCase('B',freq,false);
    pld=genPayload(Lbarmax,block_index,kssb,0,mib.SFN,half_frame,mib.subCarrierSpacingCommon,mib.dmrsTypeAPosition,mib.pdcch_ConfigSIB1,mib.cellBarred,mib.intraFreqReselection,0);
    pbch = interleavePbchPayload(pld);
    pbch = scramblePbchPayload(pbch,NCellID,Lbarmax);
    pbch = attachParityBits(pbch,nrCom.PbchCrcType);
    pbch = polarCoding(pbch);
    pbch = rateMatching(pbch);
    ref_pbch=nrBCH(pld(1:24).',mib.SFN,half_frame,Lbarmax,kssb,NCellID);
    verifyEqualIgnoringType(tc,pbch.',ref_pbch);
end

function full_pbch_stream_test(tc)
    kssb=23;
    NCellID=17;
    freq=4e9;
    half_frame=1;
    mib=struct();
    mib.SFN=0;
    block_index=1;

    mib.subCarrierSpacingCommon=nrCom.SCSCommon.scs30or120;
    mib.dmrsTypeAPosition=nrCom.DmrsTypeAPosition.pos2;
    mib.pdcch_ConfigSIB1=103;
    mib.cellBarred=nrCom.CellBared.barred;
    mib.intraFreqReselection=nrCom.IntraFreqReselection.notAllowed;
    [~,Lbarmax]=nrCom.blocksByCase('B',freq,false);
    pld=genPayload(Lbarmax,block_index,kssb,0,mib.SFN,half_frame,mib.subCarrierSpacingCommon,mib.dmrsTypeAPosition,mib.pdcch_ConfigSIB1,mib.cellBarred,mib.intraFreqReselection,0);
    pbch = interleavePbchPayload(pld);
    pbch = scramblePbchPayload(pbch,NCellID,Lbarmax);
    pbch = attachParityBits(pbch,nrCom.PbchCrcType);
    pbch = polarCoding(pbch);
    pbch = rateMatching(pbch);
    ref=nrPBCH(pbch.',NCellID,mod(block_index,min(8,Lbarmax)));
    pbch = scramblePbch(pbch,NCellID,Lbarmax,block_index);
    pbch= qpskModulate(pbch);



    ours=genPbch(pld,NCellID,Lbarmax,block_index);
    verifyEqual(tc,pbch.',ref,'abstol',1e-15);
    verifyEqual(tc,qpskModulate(ours).',ref,'abstol',1e-15)
    % ref_pld=nrBCHDecode(nrPBCHDecode(ref,NCellID,block_index),Lbarmax);
    % verifyEqualIgnoringType(tc,pld.',ref_pld);
end

function between_CRC_test(tc)
    NCellId=17;
    Lbarmax=64;
    for i=1:50
       data=randi([0,1],1,56);
       polar_coded=polarCoding(data);
       rate_matched=rateMatching(polar_coded);
       scrambled=scramblePbch(rate_matched,NCellId,Lbarmax,mod(i,8));
       modulated=qpskModulate(scrambled);
       demodulated=qpskDemodulate(modulated);
       descrambled=scramblePbch(demodulated,NCellId,Lbarmax,mod(i,8));
       rate_recovered=rateRecovery(descrambled);
       actual=polarDecoding(rate_recovered);
       verifyEqual(tc,demodulated,scrambled,'abstol',1e-15);
       verifyEqual(tc,descrambled,rate_matched);
       verifyEqual(tc,rate_recovered,polar_coded);
       verifyEqual(tc,actual,data);
    end

end