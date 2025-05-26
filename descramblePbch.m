function softbits = descramblePbch(softbits, NCellId, Lbarmax,  block_index)
    arguments
        softbits {mustBeVector}
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
        Lbarmax (1,1) {mustBeInteger,mustBeNonnegative}
        block_index (1,1) {mustBeInteger,mustBeNonnegative}
    end
    % softbits=reshape(softbits, 1, nrCom.Nbits_pbch);
    block_index=mod(block_index,8);
    M=nrCom.Nbits_pbch;
    c = logical(pseudoRandomSequence(NCellId,M));
    softbits(c)=1./softbits(c);
end