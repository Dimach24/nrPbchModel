classdef ResourceMapper<handle
    % This class provides functionality to map SSBs to 
    % the resource grid it manages
    properties
        resource_grid
    end

    methods
        function obj = ResourceMapper(NgridSize,timespan)
            arguments
                NgridSize (1,1) {mustBeInteger,mustBeNonnegative}
                timespan  (1,1) {mustBeInteger,mustBeNonnegative}
            end
            obj.resource_grid=zeros(NgridSize*12,timespan);
        end


        function  mapBlock(obj,pss,sss,pbch,pbch_dmrs,NCellId,k,l)
            arguments
                obj ResourceMapper %self
                pss {mustBeVector}
                sss {mustBeVector}
                pbch {mustBeVector}
                pbch_dmrs {mustBeVector}
                NCellId (1,1){mustBeInteger,mustBeInRange(NCellId,0,1007)}
                k (1,1){mustBeInteger,mustBeNonnegative} % subcarrier 0
                l (1,1){mustBeInteger,mustBeNonnegative} % ofdm symbol 0
            end
            mapSync(obj,pss,sss,k,l);
            mapPbch(obj,pbch,pbch_dmrs,NCellId,k,l);
        end
        function mapSync(obj,pss,sss,k,l)
            arguments
                obj ResourceMapper %self
                pss {mustBeVector}
                sss {mustBeVector}
                k (1,1){mustBeInteger,mustBeNonnegative} % subcarrier 0
                l (1,1){mustBeInteger,mustBeNonnegative} % ofdm symbol 0
            end
            obj.resource_grid(k+55+1:k+181+1,l+1)=pss;
            if (l+2<=size(obj.resource_grid,2))
                obj.resource_grid(k+55+1:k+181+1,l+2+1)=sss;
            end
        end
        function mapPbch(obj,pbch,pbch_dmrs,NCellId,k,l)
            arguments
                obj ResourceMapper %self
                pbch {mustBeVector}
                pbch_dmrs {mustBeVector}
                NCellId (1,1){mustBeInteger,mustBeInRange(NCellId,0,1007)}
                k (1,1){mustBeInteger,mustBeNonnegative} % subcarrier 0 
                l (1,1){mustBeInteger,mustBeNonnegative} % ofdm symbol 0
            end
            nu=mod(NCellId,4);
            dmrs_pos=(0:4:236)+nu;
            pbch_pos_solid=0:239;
            pbch_pos_split=[0:47 192:239];

            i=1;j=1;
            for kx=pbch_pos_solid
                if ismember(kx,dmrs_pos)
                    obj.resource_grid(k+1+kx,l+2)=pbch_dmrs(j);
                    j=j+1;
                else
                    obj.resource_grid(k+1+kx,l+2)=pbch(i);
                    i=i+1;
                end
            end
            for kx=pbch_pos_split
                if ismember(kx,dmrs_pos)
                    obj.resource_grid(k+1+kx,l+3)=pbch_dmrs(j);
                    j=j+1;
                else
                    obj.resource_grid(k+1+kx,l+3)=pbch(i);
                    i=i+1;
                end
            end
            for kx=pbch_pos_solid
                if ismember(kx,dmrs_pos)
                    obj.resource_grid(k+1+kx,l+4)=pbch_dmrs(j);
                    j=j+1;
                else
                    obj.resource_grid(k+1+kx,l+4)=pbch(i);
                    i=i+1;
                end
            end
            
            assert(i~=length(pbch))
            assert(j~=length(pbch_dmrs))
        end
    end
end

