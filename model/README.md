# Models

This file documents the sources of the concrete models imported here,
and where they originate from. 

## Automatic Transmission

Source: Breach `Examples/Simulink/brdemo_models/brdemo_autotrans.mdl`

References
  
- B. Hoxha, H. Abbas, and G. Fainekos:
  Benchmarks for Temporal Logic Requirements for Automotive Systems, HSCC'14.
- MathWorks: Modeling an Automatic Transmission Controller,
  <https://www.mathworks.com/help/simulink/examples/modeling-an-automatic-transmission-controller.html>

## Abstract Fuel Control

Source: Breach `Ext/Models/AbstractFuelControl.slx`

Note that this model has a long trail of who said it was proposed where:
Adimoolam CAV 17 -> Dreossi NFM 15 ->  Duggirala HSCC 14 (Powertrain benchmark)

Original Source of the Powertrain benchmark seems to be
P. R. Crossley and J. A. Cook. A nonlinear engine model for
drivetrain system development. In International Conference
on Control, volume 2, pages 921–925, 1991.

Needs setup:
  val vars = Seq(
    "fuel_inj_tol" -> "1.0",
    "MAF_sensor_tol" -> "1.0",
    "AF_sensor_tol" -> "1.0",
    "pump_tol" -> "1.0",
    "kappa_tol" -> "1",
    "tau_ww_tol" -> "1",
    "fault_time" -> "50",
    "kp" -> "0.04",
    "ki" -> "0.14")


References

- B. Hoxha, H. Abbas, and G. Fainekos:
  Benchmarks for Temporal Logic Requirements for Automotive Systems, HSCC'14.
- X. Jin, J. V. Deshmukh, J.Kapinski, K. Ueda, and K. Butts:
  Powertrain Control Verification Benchmark, HSCC'2014.
- Mathworks: Modeling a Fault-Tolerant Fuel Control System,
  <https://www.mathworks.com/help/simulink/examples/modeling-a-fault-tolerant-fuel-control-system.html>