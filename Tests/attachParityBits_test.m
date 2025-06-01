function tests=attachParityBits_test
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
        data=randi([0,1],1,39);
        recovered=verifyParity(attachParityBits(data,'crc24c'),'crc24c');
        verifyEqual(tc,recovered,data);
    end
end