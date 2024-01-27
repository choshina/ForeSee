
n_cp = 5;
time = 0:0.1:20;

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
Bcar.SetParamRanges(var, ranges);
R = BreachRequirement(rnc1);

falsified = [];
time = [];
obj_best = [];
num_sim = [];

for i = 1:10
	pb = FalsificationProblem(Bcar, R);
	pb.setup_solver('cmaes');
	pb.max_obj_eval = inf;
	pb.max_time = 600
	pb.solve();
	if pb.obj_best < 0
	    falsified = [falsified;1];
	else
	    falsified = [falsified;0];
	end
	num_sim = [num_sim;falsif_pb.nb_obj_eval];
	time = [time;falsif_pb.time_spent];
	obj_best = [obj_best;falsif_pb.obj_best];
end

result = table(filename, spec, falsified, time);
writetable(result,'b_rnc1.csv','Delimiter',';');
