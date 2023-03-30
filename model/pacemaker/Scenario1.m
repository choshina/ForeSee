%Copyright (c) 2022 Namya Mehan, Ethan Dhanraj, Abdul El-Rahwan, Simon Emil Opalka, Tony Fan, Akil Hamilton, Akshay Mathews Jacob, Rahul Anthony Sundarrajan, Bryan Widjaja, Mostafa Ayesh, and Claudio Menghi

%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


%% Header and File Set-Up
% ----------------------------------------------------------------------- %
% TEACHING ASSIGNMENT 3 – BLACK BOX TEST: LOWER RATE LIMIT (LRL)
% 
% GROUP 6
% PRIMARY AUTHORS: Akil Hamilton,  Rahul A. Sundarrajan
% CO-AUTHORS:      Ethan Dhanraj, Namya Mehan
% 
% SFWRENG 3MD3, W2022
% Dr. Claudio Menghi
% McMaster University
% ----------------------------------------------------------------------- %
% This assignment endeavours to teach students the fundamentals of white 
% and black-box testing techniques using MATLAB Simulink models as a basis.
% This particular file utilizes sTaliro to run a series of black-box tests
% on Group 6's implementation of Boston Scientific's (C) 2007 PACEMAKER 
% specification.
% 
% This test in particular, evaluates the functionality of the PACEMAKER's 
% Lower Rate Limit (LRL). Specifically, it tests whether this value is 
% always within one of the three acceptable programmable value ranges.
% ----------------------------------------------------------------------- %
clear variables;
close all;
clc;
% ----------------------------------------------------------------------- %
%% Model and Predicate Declarations
% ----------------------------------------------------------------------- %
% The model specificied here is the current implementation of the PACEMAKER
% specification in MATLAB Simulink.
model = 'Model1_Scenario1_Faulty';

% The initial pacing conditions in the Simulink model are used.
init_cond = []; 

phi = '([](lrl_restricts_max_number_of_beats) /\ <>(lrl_restricts_min_number_of_beats))';

lrl_preds(1).str = 'lrl_restricts_max_number_of_beats';
lrl_preds(1).A = [0 0 1];   % Selecting for the PACE_COUNT output
lrl_preds(1).b = 15;        % One 6th of the upper range of LRL (90)

lrl_preds(2).str = 'lrl_restricts_min_number_of_beats';
lrl_preds(2).A = [0 0 -1];   % Selecting for the PACE_COUNT output
lrl_preds(2).b = -8;        % Floor of one 6th of the lower range of LRL (50)


input_range = [50 90];      % The input range for the lower rate limit from Pacemaker SRS
cp_array = 5;               % The number of control points we evaluate.

time = 10;                  % The simulation duration.

opt = staliro_options();    % Options initialization.

opt.runs = 1;               % The number of test runs.
opt.optimization_solver = 'UR_Taliro'; % The iterations are uniform random.
% opt.optimization_solver = 'SA_Taliro'; % Each iteration is based on the last.
% opt.optimization_solver = 'MS_Taliro';

opt.runs=50; %number of times to run

opt.interpolationtype = {'pchip'};
opt.optim_params.n_tests=300;

[resultsModel1Scenario1Faulty,history,opt] = staliro(model, init_cond, input_range, ...
                                 cp_array, phi, lrl_preds, time, opt);


save('Model1_Scenario1_Faulty');

model = 'Model1_Scenario1_Correct';
[resultsModel1Scenario1Correct,history,opt]=staliro(model,init_cond,input_range,cp_array,phi,lrl_preds,time,opt);
save('Model1_Scenario1_Correct');