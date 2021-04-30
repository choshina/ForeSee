# ForeSee

This repository is for the artifact evaluation of the paper "Effective Hybrid System Falsification Using Monte Carlo Tree Search Guided by QB-Robustness" accepted by CAV 2021.
***

## System requirement

- Operating system: Linux or MacOS;

- Matlab (Simulink/Stateflow) version: >= 2020a. (Matlab license needed)

- Python version: >= 3.3

## Installation

- Clone the repository.
  1. `git clone https://github.com/choshina/ForeSee.git`
  2. `git submodule init`
  3. `git submodule update`

- Install Breach.
  1. start matlab, set up a C/C++ compiler using the command `mex -setup`. (Refer to [here](https://www.mathworks.com/help/matlab/matlabexternal/changing-default-compiler.html) for more details.)
  2. navigate to `breach/` in Matlab commandline, and run `InstallBreach`

- Install our tool ForeSee.
  1. in terminal navigate to ForeSee home, and run `sh InstallForeSee.sh`

***
## Reproduce the Results in Paper
### Evaluation Metrics
In the following, we call one algorithm (out of the baseline breach and the proposed approach ForeSee) solving one specification (out of the ones in Table 1 in our paper) as a *problem instance*. Since the optimization algorithms used in our experiments are stochastic, we repeated each falsification trial for 30 times, and count the *success rate*, i.e., how many trials out of the 30 trials succeeded, as the indicator of the effectiveness of different techniques; for each trial, we set 900 seconds as the timeout. Therefore, the worst case for each problem instance is 900*30 seconds (7.5 hours). 

In our script, we make *the number of trials* configurable. Therefore, it is not needed to run 30 trials for each problem instance; the user can input a smaller number, e.g., 10, and check if the success rate is similar to what has been presented in Table 2 of our paper.

### Usage
Run `python foresee.py [RQ1|RQ2|RQ3]`, then the script will ask users to specify experiment settings.
Users can specify 3 settings:
- specification ID
  - for RQ1: select one from `AT[1-22]|AFC[1-6]|FFR[1-2]`, e.g., `AT6`
  - for RQ2: select one from `AT1|AT3|AT4|AT9|AT15|AFC3`
  - for RQ3: select one from `AT17|AT19|AT21`
- falsification algorithm
  - select one from `breach|foresee`, e.g., `foresee`
- the number of trials
  - specify a natural number, e.g., `10` 
- (RQ2 only) rescaling factors for specific signals
- (RQ3 only) the hyperparameters `c` and `B`<sub>P</sub>
  - select one for `c` from `0|0.02|0.2|0.5|1.0`
  - select one for `B`<sub>P</sub> from `2|5|10|15|20`

Then users can wait until the results display.

***
## Use ForeSee for Other Models
In general, the usage of ForeSee for a new Simulink model consists of 3 steps:
- write a configuration file `new` in `test/conf/`
- generate test script by `python test/foresee_gen.py test/conf/new`
- run test by `make`

### Example
We use the Simulink model "narmamaglev_v1" (See [here](https://www.mathworks.com/help/deeplearning/ug/design-narma-l2-neural-controller-in-simulink.html) for details) as an example to show how ForeSee runs new model.
- we prepared an example configuration file `test/conf/NN_example`. Users can specify specifications, the number of trials, scalars, and etc by editting this file. Be sure to change the `addpath` item as the ForeSee home.
- navigate to `test/`, and run `python foresee_gen.py conf/NN_example`.
- navigate to ForeSee home, and run `make`.

### Syntax of Configuration Files
The configuration file contains a number of items. 
For each item, the syntax is as follows:
 
 `item n`
 
  `line 1`
  
  `line 2`
  
  `...`
  
  `line n`
  
The number of lines is consistent with the value of `n`.
