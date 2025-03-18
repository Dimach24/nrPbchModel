function tests=crc_test
    tests = functiontests(localfunctions);
end
function setupOnce(~)
    cd ../
end
function teardownOnce(~)
    cd Tests
end


function randPositiveTest(tc)
    for i=1:100
        data=randi([0,1],1,32);
        dataWithCrc=attachParityBits(data,nrCom.CrcType.crc24c);
        [dataWithoutCrc,flag]=verifyParity(dataWithCrc,nrCom.CrcType.crc24c);
        verifyTrue(tc,flag);
        verifyEqual(tc,data,dataWithoutCrc);
    end
end
