function tests=scrambling_test
    tests = functiontests(localfunctions);
end
function setupOnce(~)
    cd ../
end
function teardownOnce(~)
    cd Tests
end

function payload_scr_rand_test(tc)
    for i=1:100
        data=randi([0,1],1,32);
        NCellId=17;
        for Lmax=[4 8 10 16 20 64]
            seq=scramblePbchPayload(scramblePbchPayload(data,NCellId,Lmax),NCellId,Lmax);
            verifyEqual(tc,seq,data,Lmax);
        end
    end
end
function pbch_scr_rand_test(tc)
    for i=1:20
        data=randi([0,1],1,864);
        NCellId=17;
        for Lmax=[4 8 10 16 20 64]
            for issb=0:Lmax-1
                seq=scramblePbch(scramblePbch(data,NCellId,Lmax,issb),NCellId,Lmax,issb);
                verifyEqual(tc,seq,data,Lmax);
            end
        end
    end
end

%
% function verifyEqualIgnoringType(testCase, actual, expected,diagnostic)
%     testCase.verifyEqual(double(actual), double(expected),diagnostic);
% end