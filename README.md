# StateflowRepairTool

## General Information

This repository is a research-purpose repository aiming at researching methods to repair stateflow models. 

## Repository Structure
The package is structured as follows:

* [__Fault Localization__](/FaultLocalization) contains the necessary scripts to measure the suspiciousness of transitions and states in a stateflow model.
* [__Miscellanous__](/Miscellanous) TBD.
* [__Models With real Faults__](/ModelsWithRealFaults) contains the test cases used in our evaluation. 
* [__Mutators__](/Mutators) contains a set of mutation operators.

_Note:_ each sub-package contains further specific instructions.

## Usage

For the baseline algorithm run ```Replication_main_RepairAlgorithm_Baseline_v2.m``` and for the approach algorithm run ```Replication_main_RepairAlgorithm_GlobLocal_V2.m```.
Each algorithms generates a folder inside _Results_ folder. Inside the _Results_ folder, the results are stored as follows:

```
Results\{Algorithm}\{model}\{Algorothm}_seed_{number of seed}\
```

_Note:_ the first time you run one of the algorithms, the folder results will be created.

## Result analyzing

To compare results, run ```AnalyzeResults.py```. Remember changing properly the Initial parameters in the script (model, seeds and execution time).

This will generate a plot comparing The baseline algorithm against our Approach.


## Reference

## Contact

For any related question, please contact Aitor Arrieta ([aarrieta@mondragon.edu](mailto:aarrieta@mondragon.edu)), Pablo Valle ([pablo.valle@alumni.mondragon.edu](mailto:pablo.valle@alumni.mondragon.edu)) or Shaukat Ali ([shaukat@simula.no](mailto:shaukat@simula.no)).



