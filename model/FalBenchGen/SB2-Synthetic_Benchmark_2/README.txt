Synthetic Neural Network - SB2

Reference: Y. Yan, D. Lyu, Z. Zhang, P. Arcaini and J. Zhao, "Automated Generation of Benchmarks for Falsification of STL Specifications," IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems

Model name: phi2_m1_vr01_k2_2
Matlab version >= 2024b

Inputs:
- u: Input signal

Outputs:
- b: Output signal

Requirements in STL:
SB2:	□_[0, 18] (b > 90 ∨ ◊_[0, 6] b < 50)

Minimum simulation time: 24s

Input range:
- u: 0 <= u <= 1

Instance 1: Not available.

Instance 2: The input signal must be piecewise constant functions with consecutive discontinuities at least 6s apart.