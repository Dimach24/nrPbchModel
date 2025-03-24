function pld=polarDecoding(likehood_ratios)
    K = 56;
    N = 512;
    Q_0_Nmax = nrCom.PolarSequenceReliability;
    j = 1;
    for i = 1:1024
        if Q_0_Nmax(i)<N
            Q_0_N(j) = Q_0_Nmax(i);
            j=j+1;
            if j > N
                break
            end
        end
    end
    Q_I_N = Q_0_N((end-K+1):end);

    likehood_ratios=likehood_ratios(bitrevorder(1:N));
    decision=nan(1,N);
    K=56; % payload size
    pld=nan(1,K);
    n=log2(N)+1;
    k=1;
    for i=1:N
        if ismember(i-1,Q_I_N)
            lr=calculateLikehood(likehood_ratios,i,decision);
            decision(i)=lr<1;
            pld(k)=decision(i);
            k=k+1;
        else
            decision(i)=0;
        end
    end
    pld=deinterleave(pld);
end


function lr= calculateLikehood(LR,i,u)
    N=length(LR);
    if N==1 % channel-layer
        lr=LR;
    else
        if mod(i,2)==1 %i is odd
            uo=u(1:2:i-1); % odd subvector
            ue=u(2:2:i-1); % even subvector
            % fprintf("fa\t%2d\n",N/2)
            a=calculateLikehood(LR(1:N/2),(i+1)/2,xor(ue,uo));
            % fprintf("fb\t%2d\n",N/2)
            b=calculateLikehood(LR(N/2+1:N),(i+1)/2,ue);
            lr=f(a,b);
        else % i is even
            uo=u(1:2:i-2); % odd subvector
            ue=u(2:2:i-2); % even subvector
            % fprintf("ga\t%2d\n",N/2)
            a=calculateLikehood(LR(1:N/2),i/2,xor(ue,uo));
            % fprintf("gb\t%2d\n",N/2)
            b=calculateLikehood(LR(N/2+1:N),i/2,ue);
            lr=g(u(i-1),a,b);
        end
    end
    % fprintf("return\t%2d\n",N);
end

function res=f(a,b)
    res=(1+a*b)/(a+b);
end
function res=g(s,a,b)
    if length(s)~=1
        error("s must be a scalar")
    end
    if isnan(s)
        error("s must be not NaN")
    end
    res=a.^(1-2*s)*b;
end

function out_seq = deinterleave(bits)
    % deinterleave process of reverse interleaving
    % after polar decoding [7.1.4, TS 38.212]

    arguments
        bits (1,:) % sequence of bits
    end

    % initializing
    K = length(bits);
    out_seq = zeros(1,length(bits));
    INTERLEAVING_PATTERN = nrCom.PolarCodingInterleaverPattern;
    k = 0;
    for m = 0:163
        if INTERLEAVING_PATTERN(1+m) >= 164 - K
            INTERLEAVING_PATTERN(1+k) = INTERLEAVING_PATTERN(1+m) - (164 - K);
            k = k+1;
        end
    end

    % main procedure
    for i = 1:K
        out_seq(INTERLEAVING_PATTERN(i)+1) = bits(i);
    end
end