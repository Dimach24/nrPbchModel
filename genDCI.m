%DCI format 1_0 with CRC scrambled by SI-RNTI
function dci = genDCI(                     ...
    FDRA,                                  ... %FrequencyDomainResourceAssignment
    TDRA,                                  ...%TimeDomainResourceAssignment
    VRB_to_PRB,                            ...%VRB_to_PRB
    ModulationAndCodingScheme,             ...% ModulationAndCodingScheme
    RedundancyVersion,                     ...%RedundancyVersion
    SII,                                   ...%SystemInformationIndicator
    ReservedBits                           ...%ReservedBits
    )
    arguments
        %FrequencyDomainResourceAssignment: ceil(log2(NRB_DLBWP *(NRB_DLBWP + 1) / 2)) = 11
        %NRB_DLBWP = CORESET0 size (48) 
        FDRA (1,1) {mustBeInteger,mustBeNonnegative}

        %5.1.2.1 TS38.214, 4 bits
        TDRA (1,1) {mustBeInteger,mustBeNonnegative}

        %VRB_to_PRB: 0 - non-innterleaved, 1 - interleaved Table
        %7.3.1.2.2-5 TS38.212
        VRB_to_PRB (1,1) {mustBeMember(VRB_to_PRB,[0,1])}

        %Table 5.1.3.1-1 TS38.214, 5 bits.
        ModulationAndCodingScheme (1,1) {mustBeInteger,mustBeNonnegative}

        %rvid версия избыточности
        RedundancyVersion (1,1) {mustBeInteger,mustBeNonnegative}

        %SIB1 transmission
        SII = 0;

        %Reserved bits – 17 bits for operation in a cell with shared spectrum channel access in frequency range 1 
        %or for operation in a cell in frequency range 2-2; otherwise 15 bits
        ReservedBits = zeros(1,15);
    end

    
    FDRA = int2bit(FDRA,11).';
    TDRA = int2bit(TDRA,4).';
    ModulationAndCodingScheme = int2bit(ModulationAndCodingScheme,5).';
    RedundancyVersion = int2bit(RedundancyVersion,2).';

end