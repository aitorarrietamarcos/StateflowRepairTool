# StateflowRepairTool

## General Information

This research-purpose repository aims to research methods to repair stateflow models. 

## Repository Structure
The package is structured as follows:

* [__Fault Localization__](/FaultLocalization) contains the necessary scripts to measure the suspiciousness of transitions and states in a stateflow model.
* [__Miscellanous__](/Miscellanous) TBD.
* [__Models With Real Faults__](/ModelsWithRealFaults) contains the test cases used in our evaluation. 
* [__Mutators__](/Mutators) contains a set of mutation operators.

_Note:_ Each sub-package contains further specific instructions.

## Usage

For the baseline algorithm run ```Replication_main_RepairAlgorithm_Baseline_v2.m``` and for the approach algorithm run ```Replication_main_RepairAlgorithm_GlobLocal_V2.m```. <br />
Each algorithm generates a folder inside the _Results_ folder and the results are stored as follows:

```
Results\{Algorithm}\{model}\{Algorothm}_seed_{number of seed}\
```

_Note:_ The first time you run one of the algorithms, the folder results will be created.

## Result analyzing

To compare results, run ```AnalyzeResults.py```. Remember to change the Initial parameters in the script properly (model, seeds and execution time).

This will generate a plot comparing the baseline algorithm against our Approach.


## Reference

## Contact

For any related question, please contact:<br /> Aitor Arrieta ([aarrieta@mondragon.edu](mailto:aarrieta@mondragon.edu))<br /> Pablo Valle ([pablo.valle@alumni.mondragon.edu](mailto:pablo.valle@alumni.mondragon.edu)) <br /> Shaukat Ali ([shaukat@simula.no](mailto:shaukat@simula.no))



