function dmrs=genPbchDmRs(NCellId,block_index)
    % generates PBCH DM-RS according SSB index and BS ID
    arguments
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
        block_index (1,1) {mustBeInteger,mustBeNonnegative} % must be at least 3 LSB
    end
    block_index = mod(block_index,8);
    cinit=2^11*(block_index+1)*(floor(NCellId/4)+1)+2^6*(block_index+1)+mod(NCellId,4);
    c = pseudoRandomSequence(cinit,288);
    dmrs=1/sqrt(2)*(1-2*c(1:2:end))+1j/sqrt(2)*(1-2*c(2:2:end));
end


