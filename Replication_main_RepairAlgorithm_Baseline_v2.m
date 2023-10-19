clear;
clc;
addpath("Mutators");
seeds=[1,2,3,4,5];
% executeTests={@executeTestDoor,@executeTestDoor,@executeTestFridge,@executeTestFridge,@executeTestFridge,@executeTestFridge,@executeTestFridge,...
%     @executeTestPacemaker,@executeTestPacemaker2};
% faultyModels=["ModelsWithRealFaults/door_1/Door_model_Incorrect","ModelsWithRealFaults/door_2/Door_model_Incorrect",...
%     "ModelsWithRealFaults/fridge_1/Fridge_Faulty","ModelsWithRealFaults/fridge_2/Fridge_Faulty","ModelsWithRealFaults/fridge_2a/Fridge_Faulty",...
%     "ModelsWithRealFaults/fridge_2b/Fridge_Faulty","ModelsWithRealFaults/fridge_3/Fridge_Faulty",...
%     "ModelsWithRealFaults/pacemaker_fault1/Model1_Scenario2_Faulty_2020a","ModelsWithRealFaults/pacemaker_fault2/Model2_Scenario1_Faulty_2020a"];
% nonFaultyModels=["ModelsWithRealFaults/door_1/Door_model_Correct","ModelsWithRealFaults/door_2/Door_model_Correct",...
%     "ModelsWithRealFaults/fridge_1/Fridge_Correct","ModelsWithRealFaults/fridge_2/Fridge_Correct","ModelsWithRealFaults/fridge_2a/Fridge_Correct",...
%     "ModelsWithRealFaults/fridge_2b/Fridge_Correct","ModelsWithRealFaults/fridge_3/Fridge_Correct",...
%     "ModelsWithRealFaults/pacemaker_fault1/Model1_Scenario2_NonFaulty_2020a","ModelsWithRealFaults/pacemaker_fault2/Model2_Scenario1_Correct_2020a"];

executeTests={@executeTestFridge};
faultyModels=["ModelsWithRealFaults/fridge_3/Fridge_Faulty"];
nonFaultyModels=["ModelsWithRealFaults/fridge_3/Fridge_Correct"];
for i=1:length(faultyModels)
     for j=1:length(seeds)

         folders_faulty=split(faultyModels(i), "/");
         folders_Nonfaulty=split(nonFaultyModels(i), "/");

         % Add directory to path
         addpath(strcat(folders_faulty(1), "/",folders_faulty(2)));

         % Make new directory
         newFolder=strcat(folders_faulty(1), "/",folders_faulty(2),"/","Baseline_seed_",num2str(j));
         mkdir(newFolder);

         % Copy Test cases
         newFaultyModel=strcat(newFolder,"/",folders_faulty(3));
         copyfile(strcat(faultyModels(i), ".slx"), strcat(newFaultyModel,".slx"));

         newNonFaultyModel=strcat(newFolder,"/",folders_Nonfaulty(3));
         copyfile(strcat(nonFaultyModels(i), ".slx"), strcat(newNonFaultyModel,".slx"))
         
         %Execute Baseline algorithm
         baselineAlgorithm(seeds(j),newFaultyModel, newNonFaultyModel, executeTests{i},newFolder)
         
         %Remove path
         rmpath(strcat(folders_faulty(1), "/",folders_faulty(2)));
     end
end







