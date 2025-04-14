Synthetic Neural Network - SB4

Reference: Y. Yan, D. Lyu, Z. Zhang, P. Arcaini and J. Zhao, "Automated Generation of Benchmarks for Falsification of STL Specifications," IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems

Model name: phi1_m2_vr001_k5_2
Matlab version >= 2024b

Inputs:
- u_1: Input signal 1
- u_2: Input signal 2

Outputs:
- b_1: Output signal 1
- b_2: Output signal 2

Requirements in STL:
SB4:	□_[0, 19] ((□_[0, 5] b_1 <= 20) ∨ (◊_[0, 5] b_2 >= 40))

Minimum simulation time: 24s

Input range:
- u_1: 0 <= u_1 <= 1
- u_2: 0 <= u_2 <= 1

Instance 1: Not available.

Instance 2: Both input signals must be piecewise constant functions with consecutive discontinuities at least 6s apart.