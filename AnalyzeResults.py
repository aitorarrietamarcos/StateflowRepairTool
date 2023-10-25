import pandas as pd
import os, sys
from os import chdir
from os.path import dirname,realpath
chdir(dirname(realpath(__file__)))
sys.path.append('..')
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.ticker import FormatStrFormatter

filter_models= lambda f: f.endswith('.slx')
############################## INITIAL PARAMETERS ################################

folder= "Results\\" # Results folder
model="fridge_3" # Model
seeds=[1,2,3,4,5] # Seeds
execTime=3600 # Execution time in seconds

##################################################################################
patches_baseline=list()
patches_ea=list()
for seed in seeds:
    path_baseline=folder+"Baseline\\"+model+"\Baseline_seed_"+str(seed)
    models_baseline=list(filter(filter_models,os.listdir(path_baseline)))
    totalNumberOfModels_baseline=len(models_baseline)-2
    deltaModels_baseline=execTime/totalNumberOfModels_baseline

    path_ea=folder+"Approach\\"+model+"\Approach_seed_"+str(seed)
    models_ea=list(filter(filter_models,os.listdir(path_ea)))
    totalNumberOfModels_ea=len(models_ea)
    deltaModels_ea=execTime/totalNumberOfModels_ea

    toRead_baseline=open(path_baseline+"\PlausiblePatches.txt","r")
    plausiblePatches_baseline=toRead_baseline.read()
    plausiblePatches_baseline=plausiblePatches_baseline.split("\n") 

    toRead_ea=open(path_ea+"\PlausiblePatches.txt","r")
    plausiblePatches_ea=toRead_ea.read()
    plausiblePatches_ea=plausiblePatches_ea.split("\n") 

    print(plausiblePatches_ea)

    foundIndexes_baseline=list()
    for i in range(0, len(plausiblePatches_baseline)-1):
        splitted=plausiblePatches_baseline[i].split("_")
        to_index_baseline=splitted[-1].split("\t")[0].split("'")[0].split(".")[0]
        if to_index_baseline != 'NaN':
            foundIndexes_baseline.append(to_index_baseline)

    foundIndexes_ea=list()
    for i in range(0, len(plausiblePatches_ea)-1):
        splitted=plausiblePatches_ea[i].split("_")
        to_index_ea=splitted[-1].split("\t")[0].split("'")[0].split(".")[0]
        if to_index_ea != 'NaN' and to_index_ea != 'NOT VALIDATED!' and to_index_ea != 'NOT CHECKED' and to_index_ea != '':
            foundIndexes_ea.append(to_index_ea)

    numOfPlausiblePatches_baseline=list()
    j=0
    for i in range(0,execTime):
        if j<len(foundIndexes_baseline) and i==round(float(foundIndexes_baseline[j])*deltaModels_baseline):
            j=j+1
        numOfPlausiblePatches_baseline.append(j)
    patches_baseline.append(numOfPlausiblePatches_baseline)

    numOfPlausiblePatches_ea=list()
    j=0
    for i in range(0,execTime):
        if j<len(foundIndexes_ea) and i==round(float(foundIndexes_ea[j])*deltaModels_ea):
            j=j+1
        numOfPlausiblePatches_ea.append(j)
    patches_ea.append(numOfPlausiblePatches_ea)


mean_values_baseline=np.mean(patches_baseline, axis=0)
std_values_baseline=np.std(patches_baseline, axis=0)
upperBound_baseline=mean_values_baseline+std_values_baseline
lowerBound_baseline=mean_values_baseline-std_values_baseline
lowerBound_baseline=[0 if x<0 else x for x in lowerBound_baseline] 

plt.plot(mean_values_baseline, label="Baseline")
plt.fill_between(range(0,execTime), lowerBound_baseline,upperBound_baseline, alpha=0.3)


mean_values_ea=np.mean(patches_ea, axis=0)
std_values_ea=np.std(patches_ea, axis=0)
upperBound_ea=mean_values_ea+std_values_ea
lowerBound_ea=mean_values_ea-std_values_ea

lowerBound_ea=[0 if x<0 else x for x in lowerBound_ea] 

plt.plot(mean_values_ea, label="FlowRepair")
plt.fill_between(range(0,execTime), lowerBound_ea,upperBound_ea, alpha=0.3)

plt.xlabel("Execution time (s)",weight='bold')
plt.ylabel("# of plausible patches",weight='bold')
plt.title(model,weight='bold')
plt.gca().yaxis.set_major_formatter(FormatStrFormatter('%.2f'))

plt.legend()
plt.savefig("Figures/"+model+".pdf", format="pdf", bbox_inches="tight")
plt.show()



