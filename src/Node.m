classdef Node < handle
    properties
        visit
        reward
        seq
        
        

        children_list %node list
        
        sub_forms
        expanded %bool array

        objective

        new_run
        restart
        solver_options
        x0
        
        %simulation
        
        br
        phi
        
        %logging (leaf only)
        num_sim
        num_simhis
        x_best
        obj_best
        large_rob
    end
    
    methods
        function this = Node(seq)
            this.visit = 0;
            this.reward = 0;
            this.seq = seq;
            this.num_sim = 0;
            this.num_simhis = 0;
            
            this.children_list = [];
            this.sub_forms = My_STL_Break(seq.rear());
            this.expanded = false(1, numel(this.sub_forms));
            
            this.large_rob = intmin;
            this.obj_best = intmax;

            this.new_run = true;
            this.restart = false;
            
            rng('default');
            rng(round(rem(now, 1)*1000000));
        end
        
        function child = expand(this)
            idx_list = find(this.expanded == false);
            c_idx = randi(numel(idx_list));
            
            child = Node(this.seq.append(this.sub_forms(idx_list(c_idx))));
            this.children_list = [this.children_list child];
            this.expanded(idx_list(c_idx)) = true;
        end
        
        function yes = has_child(this)
            yes = (numel(this.sub_forms) > 1);
        end
        
        function yes = all_expanded(this)
            yes = all(this.expanded);
        end
        
        function incre_visit(this)
            this.visit = this.visit + 1;
        end
        
        function update_statistic(this)
            %reward, num_sim
            tnsim = 0;
            for c = this.children_list
                if c.reward > this.reward
                    this.reward = c.reward;
                end
                if c.reward > 1
                    this.x_best = c.x_best; 
                end
                %this.num_sim = this.num_sim + c.num_sim;
                tnsim = tnsim + c.num_sim;
            end
            this.num_sim = tnsim;
        end
        
        function compute_reward(this, rob)
            if rob < 0
                this.reward = 100;
            elseif this.large_rob == intmin
                this.reward = 0;
            else
                this.reward = (this.large_rob - rob)/this.large_rob;
            end
        end
        
        function playout(this, br, phi, budget)
            
            if this.new_run
                this.new_run = false;
                
                %setup for simulation
                this.br = br.copy();
                this.phi = phi;
                this.objective = @(x)(objective_wrapper(this, x));
                
                %setup for cmaes
                
                
                params = this.br.GetSysVariables();
                ranges = this.br.GetParamRanges(params);
                lb__ = ranges(:,1);
                ub__ = ranges(:,2);
                

                
                
                this.solver_options = cmaes();
                this.solver_options.Resume = 0;
                this.solver_options.LBounds = lb__;
                this.solver_options.UBounds = ub__;
                this.x0 = this.init_x_generator();
                
                this.solver_options.Seed = round(rem(now, 1)*1000000);
                this.solver_options.SaveFilename = strcat('variablescmaes_', this.seq.to_string(), '.mat');
                this.solver_options.StopIter = budget;

            elseif this.restart % assign a new x0 and run again
                this.num_sim = this.num_simhis;
                this.solver_options.Resume = 0;
                this.solver_options.StopIter = budget;
                this.x0 = this.init_x_generator();
                this.restart = false;
            else
                this.num_sim = this.num_simhis;
                this.solver_options.Resume = 1;
                this.solver_options.StopIter = this.solver_options.StopIter + budget;
            end
            
            [this.x0, fval, counteval, stopflag, out, bestever] = cmaes(this.objective, this.x0', [], this.solver_options);
            
            
            this.num_sim = this.num_sim + counteval;
            this.obj_best = bestever.f;
            this.x_best = bestever.x;
            
            stopflag_str = cell2mat(stopflag);
            if contains(stopflag_str, 'equalfunvals') && this.obj_best > 0
                this.restart = true;
                this.num_simhis = this.num_sim;
            end
            %update reward
            this.compute_reward(this.obj_best);
        end
        
        function x0 = init_x_generator(this)
            x0 = [];
            lb__ = this.solver_options.LBounds;
            ub__ = this.solver_options.UBounds;
            num = numel(lb__);
            for i = 1: num
                is__ = lb__(i) + rand()*(ub__(i) - lb__(i));
                x0 = [x0 is__];
            end
        end
        
        function fval = objective_wrapper(this, x)
            if this.obj_best < 0
                fval = this.obj_best;
            else
                fval = this.obtain_robustness(x);
                

                this.logX(x, fval);
                
            end
        end
        
        function logX(this, x, fval)

            [fmin , imin] = min(fval);
            x_min =x(:, imin);
            
            if fmin < this.obj_best
                this.x_best = x_min;
                this.obj_best = fmin;
            end
            
            [fmax, ~] = max(fval);
            if fmax > this.large_rob && fmax~= intmax % only when fmax is not infty
                this.large_rob = fmax;
            end
        end
        
        function rob = obtain_robustness(this, x)
            %set up simulation
            this.br.SetParam(this.br.GetSysVariables(), x);
            
            this.br.Sim(this.br.Sys.tspan);
            rob = this.qb_robustness(this.br, this.seq.suffix());
        end
        
        function rob = qb_robustness(this, br, seq)
            rob_ = sub_STL_Eval(br.Sys, this.phi, br.P, br.P.traj{1}, seq);
            rob = rob_(1);
        end

    end
end