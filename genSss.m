function sss = genSss(NCellId)
    % generates SSS
    arguments
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
    end
    x0=mSequence(7,[1,0,0,0,0,0,0],[0,1,0,0,0,1,0,0]);
    x1=mSequence(7,[1,0,0,0,0,0,0],[0,1,1,0,0,0,0,0]);
    % extracting ID's from NCellID
    [Nid1,Nid2]=nrCom.nidByCellId(NCellId);
    % memory allocation
    sss=zeros(1,127);
    % computing array
    for n=0:126
        % index of shift for the 1st M-seq
        m0=15*floor(Nid1/112)+5*Nid2;
        % same for 2nd
        m1=mod(Nid1,112);
        
        % shifting indexes
        m0=mod(m0+n,127);
        m1=mod(m1+n,127);

        % computing code according to indexes
        sss(n+1)=(1-2*x0(m0+1))*(1-2*x1(m1+1));
    end
end

