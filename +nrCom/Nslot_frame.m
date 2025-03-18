function n=Nslot_frame(mu)
    % number of slots in frame
    arguments
        mu (1,1) {mustBeInteger, mustBeInRange(mu,0,6)}
    end
    n=nrCom.Nslot_subframe(mu)*nrCom.Nsubframe_frame;
end