function [t_out, X, p, status] = sim_car(Sys, t_in, p)
%
% Generic simulator interface from Breach:
% https://github.com/decyphir/breach#interfacing-a-generic-simulator
%

% Getting preliminary values
base_index = Sys.DimX;
n_cp = (size(Sys.ParamList, 2) - base_index) / 2;
T = t_in(end);

x1_0 = 45;
v1_0 = 2;
x2_0 = 5;
v2_0 = 3.5;

% Getting model parameters
a1_raw = p(base_index + 1:base_index +1 + n_cp -1);
a2_raw = p(base_index +1 + n_cp:base_index +1 + n_cp + n_cp -1);

% input signals a1, a2 are controlled by parameters a1_raw, a2_raw
% and interpolated into piecewise-constant signals
%
% TODO: variable-step signal generator.
% It may be realized by adding `a1_dt_i` parameters
a1 = interp1(linspace(0, T * (1 - 1 / n_cp), n_cp), a1_raw, t_in, 'previous', 'extrap');
a2 = interp1(linspace(0, T * (1 - 1 / n_cp), n_cp), a2_raw, t_in, 'previous', 'extrap');

% numerical integrators
v1 = v1_0 + cumtrapz(t_in, a1);
x1 = x1_0 + cumtrapz(t_in, v1);

v2 = v2_0 + cumtrapz(t_in, a2);
x2 = x2_0 + cumtrapz(t_in, v2);

X = [x1; x2; v1; v2; a1; a2];
t_out = t_in;
status = 0;
end
