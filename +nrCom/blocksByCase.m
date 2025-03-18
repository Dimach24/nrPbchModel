function [blocks_pos,Lbarmax]=blocksByCase(case_letter,carrier,sharedSpec)
    arguments
        case_letter (1,1) {mustBeTextScalar} % see TS 38.213 clause 4.1
        carrier     (1,1) {mustBeInteger}    % frequency in Hz
        sharedSpec  (1,1) logical = false
    end
    switch(upper(case_letter))
        case 'A'
            pattern=[2,8];
            if (carrier<3e9)
                N=0:1;
            else
                N=0:3;
            end
        case 'B'
            pattern=[4,8,16,20];
            if (carrier<3e9)
                N=0;
            else
                N=[0,2];
            end
        case 'C'
            pattern=[2,8];
            if(sharedSpec)
                N=0:9;
            else
                N=0:3;
            end
        case 'D'
            pattern=[4,8,16,20];
            N=(0:18)*2;
        case 'E'
            pattern=[8,12,16,20,32,36,40,44];
            N=(0:8)*4;
        case 'F'
            pattern=[2,9];
            N=0:31;
        case 'G'
            pattern=[2,9];
            N=0:31;
        otherwise
            error('Unexpected case letter');
    end

    blocks_pos=[];
    for n=N
        blocks_pos=[blocks_pos pattern+14*n];
    end
    Lbarmax=length(blocks_pos);
end