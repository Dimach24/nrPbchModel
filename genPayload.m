function payload = genPayload(  ...
    Lbarmax,                    ...
    block_index,                ...
    kssb,                       ...
    choice_bit,                 ...
    SFN,                        ...
    half_frame_bit,             ...
    subCarrierSpacingCommon,    ...
    dmrsTypeAPosition,        ...
    pdcch_ConfigSIB1,           ...
    cellBarred,                 ...
    intraFreqReselection,       ...
    spare                       ...
    )
    arguments
        Lbarmax (1,1) {mustBeInteger,mustBeNonnegative}
        block_index (1,1) {mustBeInteger,mustBeNonnegative}
        kssb (1,1) {mustBeInteger,mustBeNonnegative}
        choice_bit (1,1) {mustBeMember(choice_bit,[0,1])}
        SFN (1,1) {...
            mustBeInteger,...
            mustBeNonnegative...
            }
        half_frame_bit (1,1) {mustBeMember(half_frame_bit,[0,1])}
        subCarrierSpacingCommon (1,1) {mustBeMember(subCarrierSpacingCommon,[0,1])}
        dmrsTypeAPosition (1,1) {mustBeMember(dmrsTypeAPosition,[0,1])}
        pdcch_ConfigSIB1 (1,1) {mustBeInteger}
        cellBarred (1,1) {mustBeMember(cellBarred,[0,1])}
        intraFreqReselection (1,1) {mustBeMember(intraFreqReselection,[0,1])}
        spare (1,1)
    end
    % Turns arguments into array of bits
    
    SFN=int2bit(SFN,10,false).';
    block_index=int2bit(block_index,6,false).';
    kssb=int2bit(kssb,5,false).';
    pdcch_ConfigSIB1=int2bit(pdcch_ConfigSIB1,8,false).';
    
    payload=horzcat(...
        choice_bit,...
        SFN(10:-1:5),...
        int8(subCarrierSpacingCommon),...
        kssb(4:-1:1),...
        int8(dmrsTypeAPosition),...
        pdcch_ConfigSIB1(8:-1:1),...
        int8(cellBarred),...
        int8(intraFreqReselection),...
        spare,...
        SFN(4:-1:1),...
        half_frame_bit...
        );
    
    if (Lbarmax==10)
        payload=[payload kssb(5) 0 block_index(4)];
    elseif (Lbarmax==20)
        payload=[payload kssb(5) block_index(5:-1:4)];
    elseif (Lbarmax==64)
        payload=[payload block_index(6:-1:4)];
    else
        payload=[payload kssb(5) 0 0];
    end
end

