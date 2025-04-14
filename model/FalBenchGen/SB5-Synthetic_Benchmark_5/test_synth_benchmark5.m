% No variables to initialize

% Define input signals
t = [0; 6; 12; 18; 24];
u = [0.0; 0.25; 0.5; 0.75; 1.0];

% Define total simulation time
p = [];
u = [t, u];
T = 24;

% Run model
[tout, yout] = run_synth_benchmark5(p, u, T);