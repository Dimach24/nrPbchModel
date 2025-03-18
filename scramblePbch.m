function result = scramblePbch(pbch, NCellId, Lbarmax,  block_index)
    arguments
        pbch {mustBeVector,mustBeMember(pbch,[0,1])}
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
        Lbarmax (1,1) {mustBeInteger,mustBeNonnegative}
        block_index (1,1) {mustBeInteger,mustBeNonnegative}
    end
    block_index=mod(block_index,8);
    M=nrCom.Nbits_pbch;
    c = pseudoRandomSequence(NCellId,M*Lbarmax);
    result = mod(pbch(1:M)+ c((1:M)+block_index*M),2);
end