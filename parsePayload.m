function res = parsePayload(bits, Lbarmax)
    % parses payload of PBCH
    % returns structure with next fields:
        % - choice bit (bit)
        % - data (31-length bitstring)
        % - subCarrierSpacingCommon (enum)
        % - dmrsTypeAPosition (enum)
        % - pdcch_ConfigSIB1 (int, 8 bits)
        % - cellBared (enum)
        % - intraFreqReselection (enum)
        % - spare (just a bit)
        % - SFN (int, 10 bits)
        % - halfFrame (bit)
        % - reserved (bits array, vary from 0 to 2)
        % - blockIndexMsb (int, vary, maximum 6 bits)
        % - kssb (int, vary, maximum 5 bits)
    arguments
        bits (1,32) {mustBeMember(bits,[0,1])}
        Lbarmax (1,1) {mustBeInteger}      % SSB per half-frame
    end
    
    res.choiceBit=bits(1);
    res.data=bits(2:end);
    
    SFN_bits_m=bits(2:7);
    res.subCarrierSpacingCommon=nrCom.SCSCommon(bits(8));
    kssb_bits_l=bits(9:12);
    res.dmrsTypeAPosition=nrCom.DmrsTypeAPosition(bits(13));
    res.pdcch_ConfigSIB1=bit2int(bits(14:21).',8);
    res.cellBared=nrCom.CellBared(bits(22));
    res.intraFreqReselection=nrCom.IntraFreqReselection(bits(23));
    res.spare=bits(24);
    SFN_bits=[SFN_bits_m, bits(25:28)];
    res.SFN=bit2int(SFN_bits.',10);
    res.halfFrame=bits(29);
    res.reserved=[];
    switch Lbarmax
        case 10
            kssb_bits=[bits(30) kssb_bits_l];
            res.reserved=bits(31);
            res.blockIndexMsb=bits(32)*8; % 2^3
        case 20
            kssb_bits=[bits(30) kssb_bits_l];
            res.blockIndexMsb=bits(31)*16+bits(32)*8;
        case 64
            res.blockIndexMsb=bits(30)*32+bits(31)*16+bits(32)*8;
            kssb_bits=kssb_bits_l;
        otherwise
            kssb_bits=[bits(30) kssb_bits_l];
            res.reserved=bits(31:32);
            res.blockIndexMsb=0;
    end
    res.kssb=bit2int(kssb_bits.',length(kssb_bits));
end