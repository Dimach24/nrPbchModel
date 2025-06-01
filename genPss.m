    function pss = genPss(Nid2)
    % generates PSS
    arguments
        Nid2 (1,1) {mustBeInteger,mustBeNonnegative}
    end
    Nid2=mod(Nid2,3);
    m_seq = mSequence(7, [0, 1, 1, 0, 1, 1, 1],[0,1,0,0,0,1,0,0]);
    pss = zeros([1 127]); 
    for n = 0:126 
        m =  mod(n + 43 * Nid2, 127) + 1; 
        pss(n+1) = 1 - 2 * m_seq(m);     
    end
end

