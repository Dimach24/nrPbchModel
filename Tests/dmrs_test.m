function tests=dmrs_test
    tests = functiontests(localfunctions);
end
function setupOnce(~)
    cd ../
end
function teardownOnce(~)
    cd Tests
end




function fullTest(tc)
    for NCellId=0:1007
        for i=0:7
            verifyEqual(tc, ...
                angle(genPbchDmRs(NCellId,i)), ...
                angle(nrPBCHDMRS(NCellId,i).') ...
                )
        end
    end
end

function fullCheckTest(tc)
    for NCellId=0:1007
        for i=0:7
            verifyEqual( ...
                tc, ...
                extractBlockIndex(genPbchDmRs(NCellId,i),NCellId), ...
                i ...
                )
        end
    end
end