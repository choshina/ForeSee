function [tout, yout] =  sim_f16(phig, thetag, psig)
	altg = 4040;
	Vtg = 540;
	T = 15;
	[tout, yout] = run_f16(altg, Vtg, phig, thetag, psig, T);
end
