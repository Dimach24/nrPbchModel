function block_index = extractBlockIndex(dmrs, NCellId)
    % finds the block index that corresponds to the reference signal
    arguments
        dmrs {mustBeVector}
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
    end

    
    corr_data=zeros(1,8);
    % correlating signals
    for i=0:7
        corr_data(i+1)=abs(xcorr(genPbchDmRs(NCellId,i),dmrs,0,"normalized"));
    end
    % maximum likehood
    [~,blockIndexLsb]=max(corr_data);
    block_index=blockIndexLsb-1;
end

