function tests=interleave_test
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
        data=randi([0, 1],1,32);
        interleaved=interleavePbchPayload(data);
        recovered=deinterleavePbchPayload(interleaved);
        verifyEqual(tc,recovered,data);
    end
end