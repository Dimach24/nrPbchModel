function n=Nslot_subframe(mu)
    % number of slots per subframe
    arguments
        mu (1,1) {mustBeInteger, mustBeInRange(mu,0,6)}
    end
    n=2^mu;
end