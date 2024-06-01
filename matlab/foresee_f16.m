clear;
addpath(genpath('/home/zhenya/ForeSee'));
InitBreach;
warning('off', 'f16:no_analysis');


T = 15;
altg = 4040;
Vtg = 540;

range_phig = [0.6283    0.8901];
range_thetag = [-1.2566   -1.0996];
range_psig = [-1.1781   -0.3927];
ranges = [range_phig; range_thetag; range_phig];


var(1:3) = {'phig', 'thetag', 'phig'};

Bcar = BreachSystem('sim_f16', ...
    {'altitude'}, ...
    var, ...
    zeros(1, 3), ...
    @sim_car);
Bcar.SetTime(0:0.1:15);
for i = 1: numel(var)
    Bcar.SetParamRanges(var{i}, ranges(i, :));
end

budget_t = 1500;
scalar = 0.2;
budget_p = 10;
trials = 10;

falsified = [];
time = [];
num_sim = [];
sim_cost = [];
x_bests = [];
obj_bests = [];
phi = STL_Formula('', 'alw_[0,15](altitude[t] > 0)');

global simm
for n = 1:trials
    simm = 0;
    m = mcts2(phi, Bcar, budget_t, budget_p, scalar);
    falsified = [falsified; m.falsified];
    time = [time;m.time_cost];
    num_sim = [num_sim;simm];
    x_bests = [x_bests; m.root.x_best'];
    obj_bests = [obj_bests; m.root.obj_best];
end

result = table(falsified, time, num_sim, obj_bests);
writetable(result,'foresee_f16.csv','Delimiter',';');
