function tests=polar_test
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
        data=randi([0,1],1,56);
        recovered=polarDecoding(polarCoding(data));
        verifyEqual(tc,recovered,data);
    end
end