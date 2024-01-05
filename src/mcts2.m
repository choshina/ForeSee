classdef mcts2 < handle
    properties
        root
            
        phi
        seq
        scalar
        
        %sim related params
        br
        
        budget_t
        budget_p
%         cp
%         input_name
%         input_range
        
        %results
        falsified
        num_sim
        time_cost
        
    end
    
    methods
        function this = mcts2(phi, br, b_t, b_p, sc)
            this.phi = phi;
            this.seq = Sequence(phi);
            this.root = Node(this.seq);
            
            
            %sim related params
%             this.br = BreachSimulinkSystem(mdl);
%             this.br.Sys.tspan = st;
%             input_gen.type = 'UniStep';
%             input_gen.cp = cp;
% 			if strcmp(interp, 'linear')
% 				input_gen.method = 'linear';
% 			end
%             this.br.SetInputGen(input_gen);
%             
%             for cpi = 0: cp - 1
%                 for ini = 0: numel(in)-1
%                     in_name = in(ini + 1);
%                     this.br.SetParamRanges({strcat(in_name, '_u', num2str(cpi))}, ir(ini + 1, :));
%                 end
%             end

            this.br = br;
            
            this.budget_t = b_t; % by total time 
            this.budget_p = b_p; % by #sim
            
            %results
            this.falsified = 0;
            this.num_sim = 0;
            this.time_cost = 0;
            
            %params
            this.scalar = sc;
            
            tmcts = tic;
            
            while true
                this.exec(this.root);
                this.time_cost = toc(tmcts);
                
                if this.root.reward >= 1
                    this.falsified = 1;
                    break;
                end
                
                if this.time_cost > this.budget_t 
                    %stop
                    break;
                end
            end
        end
        
        function exec(this, node)
            if node.has_child()
                if node.all_expanded()
                    child_node = this.ucb_select(node);
                else
                    child_node = node.expand();
                end
                
                this.exec(child_node);
                node.update_statistic();
            else
                node.playout(this.br, this.phi, this.budget_p);
            end
            node.incre_visit();
        end
        
        function selected = ucb_select(this, parent)
            best_score = intmin;
            best_children = [];
            for c = parent.children_list
                exploitation = c.reward;
                exploration = sqrt(2.0*log(parent.visit)/c.visit);
                score = exploitation + this.scalar*exploration;
                if score == best_score
                    best_children = [best_children c];
                end
                if score > best_score
                    best_children = c;
                    best_score = score;
                end
            end
            
            n = numel(best_children);
            if n > 1
                selected = best_children(randi(n));
            else
                selected = best_children(1);
            end
        end
        
    end
    
end
