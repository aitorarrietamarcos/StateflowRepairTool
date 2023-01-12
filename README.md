# StateflowRepairTool

This repository is a research-purpose repository aiming at researching methods to repair stateflow models. 

## Status

The current status is preliminary. A set of mutation operators are being implemented in the form of Insertion (I), Replace (R) or Delete (D) actions. These are implemented inside the Miscellanous folder and encompass the following operators:

### Relational Operator Replacement (R):

### Conditional Operator Replacement (R):

### Mathematical Operator Replacement (R):

### Change of unit in the after (R):

### Numerical Replacement Operator in Transition (R):

### Numerical Replacement Operator in State (R):

### Transition Destination Replacement (R):

### Transition Root Replacement (R):

### Initial Transition Change (R):

### Action State Replacment (R):

### Delete State (D):

### Delete Transition (D):

### Delete Variable from a State (D):

### Delete Condition from a Transition (D):

### Insert Mathematical Operator (I):

### Variable Insertion In State (I):

### Insert New Condition (I):

## Current identified problems:

* The mutator generates some times after(0,sec), which is non-compilable.
