function pbch=genPbch(payload,NCellId,Lbarmax,block_index)
    arguments
        payload {mustBeVector,mustBeMember(payload,[0,1])}
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
        Lbarmax (1,1) {mustBeInteger,mustBeNonnegative}
        block_index (1,1) {mustBeInteger,mustBeNonnegative}
    end
    pbch = interleavePbchPayload(payload);
    pbch = scramblePbchPayload(pbch,NCellId,Lbarmax);
    pbch = attachParityBits(pbch,nrCom.PbchCrcType);
    pbch = polarCoding(pbch);
    pbch = rateMatching(pbch);
    pbch = scramblePbch(pbch,NCellId,Lbarmax,block_index);
end
