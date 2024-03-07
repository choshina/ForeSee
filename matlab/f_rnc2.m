clear;
addpath(genpath('/home/zhenya/ForeSee'));
InitBreach;

n_cp = 5;

n_vars = 4 + 2 * n_cp;
var = cell(1, n_vars);

var(1:4) = {'x1_0', 'x2_0', 'v1_0', 'v2_0'};
for i=1:n_cp
    var(4 + i) = {strcat('a1_', num2str(i))};
    var(4 + n_cp + i) = {strcat('a2_', num2str(i))};
end

ranges_0 = [45 100; 0 5; 2 27; 2 27];
ranges_a = [-3 3];
ranges = [ranges_0; repmat(ranges_a, 2 * n_cp, 1)];
STL_ReadFile('rss.stl');


Bcar = BreachSystem('car', ...
    {'x1', 'x2', 'v1', 'v2', 'a1', 'a2'}, ...
    var, ...
    zeros(1, n_vars), ...
    @sim_car);
Bcar.SetTime(0:0.1:20);
for i = 1: numel(var)
    Bcar.SetParamRanges(var{i}, ranges(i, :));
end
% Bcar.SetParamRanges(var, ranges);
%R = BreachRequirement(phi1);

% mdl = 'Autotrans_shift';
% Br = BreachSimulinkSystem(mdl);
budget_t = 600;
scalar = 0.2;
% controlpoints = 5;
budget_p = 10;
% input_name = {'throttle','brake'};
% input_range = [[0.0 100.0];[0.0 325.0]];
% spec = 'alw_[0.0, 20.0](speed[t] < 120.0)';
% % phi = STL_Formula('phi',spec);
% T = 0:.01:30;
trials = 2;

falsified = [];
time = [];
num_sim = [];
sim_cost = [];
x_bests = [];
obj_bests = [];

global simm
for n = 1:trials
    simm = 0;
    m = mcts2(rnc2, Bcar, budget_t, budget_p, scalar);
    falsified = [falsified; m.falsified];
    time = [time;m.time_cost];
    num_sim = [num_sim;simm];
    x_bests = [x_bests; m.root.x_best'];
    obj_bests = [obj_bests; m.root.obj_best];
end

result = table(falsified, time, num_sim, obj_bests);
writetable(result,'f_rnc2.csv','Delimiter',';');
