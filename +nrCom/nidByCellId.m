function [Nid1,Nid2] = nidByCellId(NCellId)
    % See TS 38.211 clause 7.4.2.1
    arguments
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
    end
    Nid2=mod(NCellId,3);
    Nid1=round((NCellId-Nid2)/3);
end