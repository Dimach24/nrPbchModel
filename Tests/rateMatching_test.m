function tests=rateMatching_test
    tests = functiontests(localfunctions);
end
function setupOnce(~)
    cd ../
end
function teardownOnce(~)
    cd Tests
end


function randTest(tc)
    for i=1:100
        data=randi([0,1],1,512);
        recovered=rateRecovery(rateMatching(data));
        verifyEqual(tc,recovered,data);
    end
end