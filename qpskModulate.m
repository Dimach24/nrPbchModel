function data=qpskModulate(bits)
    % modulates bits to QPSK complex amplitudes
    % 'bits' must be even-length
    arguments
        bits {mustBeVector,mustBeMember(bits,[0 1]),mustBeEvenLength}
    end
    data = (1-2*bits(2*(0:end/2-1)+1)+1j*(1-2*bits(2*(0:end/2-1)+2)))/sqrt(2);
end

function mustBeEvenLength(arr)
    mustBeInteger(length(arr)/2);
end