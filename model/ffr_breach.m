clear;
InitBreach;

mdl = 'free_floating_robot';
Br = BreachSimulinkSystem(mdl);

Br.Sys.tspan = 0:0.01:5;

input_gen.type = 'UniStep';
input_gen.cp = input('\n Please input control points\n');
Br.SetInputGen(input_gen);

for cpi = 0:input_gen.cp-1
    u1_sig = strcat('u1_u', num2str(cpi));
    u2_sig = strcat('u2_u', num2str(cpi));
    u3_sig = strcat('u3_u', num2str(cpi));
    u4_sig = strcat('u4_u', num2str(cpi));
    Br.SetParamRanges({u1_sig},[-10 10]);
    Br.SetParamRanges({u2_sig},[-10 10]);
    Br.SetParamRanges({u3_sig},[-10 10]);
    Br.SetParamRanges({u4_sig},[-10 10]);
end

phi = STL_Formula('phi1','not ev_[0,5](x1[t]>3.9 and x1[t]<4.1 and x2[t]>-1 and x2[t]<1 and x3[t]>3.9 and x3[t]<4.1 and x4[t]>-1 and x4[t]<1)');

%! ◇(0, 5,
%        (x1 in (3.9, 4.1)) && (x2 in (-1, 1))
%          && (x3 in (3.9, 4.1)) && (x4 in (-1, 1))



BreachProblem.list_solvers();
solver_input = input('\n Please input a solver:\n', 's');
IterNum = input('\n Please input the number of trials:\n');


total_time = 0.0;
succ_iter = 0;
succ_trial = 0;


for n = 0:IterNum-1
    
    falsif_pb = FalsificationProblem(Br, phi);
    falsif_pb.max_time = 600;
    %falsif_pb.max_obj_eval = 10;
    falsif_pb.setup_solver(solver_input);
    falsif_pb.solve();
    
    
    if falsif_pb.obj_best < 0
       total_time = total_time + falsif_pb.time_spent;
       succ_iter = succ_iter + falsif_pb.nb_obj_eval;
       succ_trial = succ_trial + 1; 
    end
end

aver_time = total_time/succ_trial
aver_succ_iter = succ_iter/succ_trial
succ_trial

