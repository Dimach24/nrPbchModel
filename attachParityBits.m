function [data_with_crc,crc]=attachParityBits(bitstream,crc_type,attach_zeros)
    % Attaches parity bits according to chosen poly (see 5.1 TS38.212). If attach_zeros=false,
    % algo interprets last bits as an parity bits mask
    arguments
        % data to validate
        bitstream {mustBeVector,mustBeMember(bitstream,[0,1])}
        % must be "crc<length><?letter>" letter is only necessary crc24_.
        crc_type (1,1) nrCom.CrcType
        attach_zeros=true   % use last <length> symbs as a mask or attach zeros before calculating
    end
    
    % poly initializing
    switch(crc_type)
        case "crc6"
            Dpos=[5 0]+1;
            N=6;
        case "crc11"
            Dpos=[10 9 5 0]+1;
            N=11;
        case "crc16"
            Dpos=[12 5 0]+1;
            N=16;
        case "crc24a"
            Dpos=[23 18 17 14 11 10 7 6 5 4 3 1 0]+1;
            N=24;
        case "crc24b"
            Dpos=[23 6 5 1 0]+1;
            N=24;
        case "crc24c"
            Dpos=[23 21 20 17 15 13 12 8 4 2 1 0]+1;
            N=24;
        otherwise
            throw(MException('crcTypeErr',...
                "Invalid crc type. Must be one of {crc6, crc11," + ...
                "crc16, crc24a, crc24b, crc24c}."))
    end
    
    % reverse of the indexes (indexes are in
    % the least significant order, but bits
    % are in the most significant order).
    Dpos=N+1-Dpos;
    L=length(bitstream);
    
    if attach_zeros
        bitstream=[bitstream, zeros(1,N)];
    else
        L=L-N;
    end
    
    % shift registers word
    crc=bitstream(1:N);
    for n=1:L
        pulled_bit=crc(1);
        % shifting the word
        crc=circshift(crc,-1);
        crc(N)=bitstream(n+N);
        % subtraction (using XOR)
        if pulled_bit
            crc(Dpos)=~crc(Dpos);
        end
    end
    % attach the word instead of last N bits (zeros or mask)
    data_with_crc=[bitstream(1:L), crc];
end