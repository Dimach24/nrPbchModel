function [pbch,dmrs]=parseSsb(rg,symbols_offset,subcarriers_offset,NCellId)
    % extracts pbch bitstream and dmrs complex
    % amplitudes from the resource grid
    arguments
        rg {mustBeNumeric}
        symbols_offset (1,1) {mustBeInteger,mustBeNumeric}
        subcarriers_offset (1,1) {mustBeInteger,mustBeNumeric}
        NCellId (1,1) {mustBeInteger,mustBeInRange(NCellId,0,1007)}
    end
    nu=mod(NCellId,4);
    dmrs_pos_solid=(0:4:236)+nu;
    dmrs_pos_split=[0:4:44 192:4:236]+nu;
    pbch_pos_solid=setdiff(0:239,dmrs_pos_solid);
    pbch_pos_split=setdiff([0:47 192:239],dmrs_pos_split);
    pbch=zeros(1,432);dmrs=zeros(1,144);
    i=1;j=1;
    for kx=pbch_pos_solid
        pbch(i)=rg(subcarriers_offset+1+kx,symbols_offset+2);
        i=i+1;
    end
    for kx=dmrs_pos_solid
        dmrs(j)=rg(subcarriers_offset+1+kx,symbols_offset+2);
        j=j+1;
    end

    for kx=pbch_pos_split
        pbch(i)=rg(subcarriers_offset+1+kx,symbols_offset+3);
        i=i+1;
    end
    for kx=dmrs_pos_split
        dmrs(j)=rg(subcarriers_offset+1+kx,symbols_offset+3);
        j=j+1;
    end
    for kx=pbch_pos_solid
        pbch(i)=rg(subcarriers_offset+1+kx,symbols_offset+4);
        i=i+1;
    end
    for kx=dmrs_pos_solid
        dmrs(j)=rg(subcarriers_offset+1+kx,symbols_offset+4);
        j=j+1;
    end
    % nu=mod(NCellId,4);
    %
    % % indexes of PBCH DM-Rs
    % dmrs13index=(0:4:236)+nu;
    % dmrs2index=[(0:4:44)+nu, (192:4:236)+nu];
    % % indexes of PBCH DM-RS
    % pbch13index = setdiff(0:239,dmrs13index);
    % pbch2index  = setdiff([0:47 192:239],dmrs2index);
    %
    % rg=rg(subcarriers_offset+1:subcarriers_offset+240 ...
    %     ,symbols_offset+2:symbols_offset+4);
    % % 144 elements of dm-rs
    % dmrs=[rg(dmrs13index+1,1); rg(dmrs2index+1,2); rg(dmrs13index+1,3)];
    % % 540 elements of
    % pbch?????????????????????????????????????????????????????????????????????????????
    % pbch=[rg(pbch13index+1,1); rg(pbch2index+1,2); rg(pbch13index+1,3)];
    dmrs=dmrs.';
    pbch=pbch.';
end