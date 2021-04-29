classdef Sequence < handle
    properties
        seq
    end
    
    methods
        function this = Sequence(phi)
            this.seq = phi;
        end
        
        function seq = append(this, phi)
            n_seq = [this.seq phi];
            seq = Sequence(n_seq);
        end
        
        function r = rear(this)
            r = this.seq(end);
        end
        
        function h = head(this)
            if numel(this.seq) == 0
                this.seq
            end
            h = this.seq(1);
        end
        
        function suf = suffix(this)
            if numel(this.seq) > 1
                suf = Sequence(this.seq(2:end));
            else
                suf = Sequence([]);
            end
        end
        
        function str = to_string(this)
            str = [];
            for s = this.seq
                str = [str '_' get_id(s)];
            end
        end

    end
end