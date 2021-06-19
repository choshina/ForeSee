init_neural;
t__ = [0; 10; 20];
u__ = [1;  2;  2];

p = [];
u = [t__, u__];
T = 20;

[tout, yout] = run_neural(p, u, T);