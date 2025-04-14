Synthetic Neural Network - SB5

Reference: Y. Yan, D. Lyu, Z. Zhang, P. Arcaini and J. Zhao, "Automated Generation of Benchmarks for Falsification of STL Specifications," IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems

Model name: phi1_m2_vr001_k5_2
Matlab version >= 2024b

Inputs:
- u: Input signal

Outputs:
- b_1: Output signal 1
- b_2: Output signal 2

Requirements in STL:
SB5:	□_[0, 17] (◊_[0, 2] ¬((□_[0, 1] b_1 >= 9) ∨ (□_[1, 5] b_2 >= 9)))

Minimum simulation time: 24s

Input range:
- u: 0 <= u_1 <= 1

Instance 1: Not available.

Instance 2: The input signal must be piecewise constant functions with consecutive discontinuities at least 6s apart.