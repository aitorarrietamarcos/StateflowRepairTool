clear;
clc;
rng(3);
addpath('Mutators');
addpath('ModelsWithRealFaults/door_2/')
bdclose('all')

faultyModel = 'ModelsWithRealFaults/door_2/Door_Model_Incorrect';
nonFaultyModel =  'ModelsWithRealFaults/door_2/Door_Model_Correct';
load('ModelsWithRealFaults/door_2/fl_data_states.mat');
load('ModelsWithRealFaults/door_2/fl_data_transitions.mat');

executeTest = @executeTestDoor;

[bestVerdict,bestTimeVerdictActive,bestCriticalityVerdict,bestTimeFirstFailureExhibited] = executeTest(faultyModel);
bdclose(nonFaultyModel);
bdclose(faultyModel);

numOfIterations = 0;
budget = 10000;

numsOfSolsInArchive = 1;
Archive{numsOfSolsInArchive}.modelName = faultyModel;
Archive{numsOfSolsInArchive}.verdict = bestVerdict;
Archive{numsOfSolsInArchive}.timeVerdict = bestTimeVerdictActive;
Archive{numsOfSolsInArchive}.criticality = bestCriticalityVerdict;
Archive{numsOfSolsInArchive}.firstFailureExhibited = bestTimeFirstFailureExhibited;


numsOfPlausiblePatches = 0;

%Archive{numsOfSolsInArchive}.verdict = faultyModel;
plausiblePatchFound = false;

timeBudget = 60*60; %1 hour
tic;



while toc<timeBudget %&& ~plausiblePatchFound
    
    
    %Global search
    verdictEnhanced = false;
    while ~verdictEnhanced && toc<timeBudget
        numOfIterations=numOfIterations+1;
        selectedModelToMutate = randi([1 numsOfSolsInArchive]);
        faultyModel = Archive{selectedModelToMutate}.modelName;
        copyfile([faultyModel '.slx'], [faultyModel '_' num2str(numOfIterations) '.slx']); 
        open_system([faultyModel '_' num2str(numOfIterations) '.slx']);
        done = false;
        while done == false
            [done, statesOrTransitions, stateNum, transNum] = applyGlobalMutations(suspiciousness_transitions,suspiciousness_states);
        end
        
        try
            save_system([faultyModel '_' num2str(numOfIterations) '.slx']);
        catch
            
        end
        bdclose([faultyModel '_' num2str(numOfIterations) '.slx']);
        %bdclose(modelname)
        try
            [verdict,timeVerdictActive,criticalityVerdict,timeFirstFailureExhibited] = executeTest([faultyModel '_' num2str(numOfIterations) ]);
            if sum(verdict)==0
                plausiblePatchFound =true;
                numsOfPlausiblePatches = numsOfPlausiblePatches+1;
                PlausiblePatches{numsOfPlausiblePatches} = [faultyModel '_' num2str(numOfIterations)];
                disp(['Plausible patch found! This one it is = ' [faultyModel '_' num2str(numOfIterations)]]);
            elseif (timeVerdictActive<Archive{selectedModelToMutate}.timeVerdict || criticalityVerdict<Archive{selectedModelToMutate}.criticality || timeFirstFailureExhibited>Archive{selectedModelToMutate}.firstFailureExhibited )...
                    && ~(timeVerdictActive>Archive{selectedModelToMutate}.timeVerdict || criticalityVerdict>Archive{selectedModelToMutate}.criticality || timeFirstFailureExhibited<Archive{selectedModelToMutate}.firstFailureExhibited )
                faultyModel = [faultyModel '_' num2str(numOfIterations)];
                plausiblePatchFound = false;
                numsOfSolsInArchive = numsOfSolsInArchive+1;
                Archive{numsOfSolsInArchive}.modelName = faultyModel;%[faultyModel '_' num2str(numOfIterations)];
                Archive{numsOfSolsInArchive}.timeVerdict = timeVerdictActive;
                Archive{numsOfSolsInArchive}.criticality = criticalityVerdict;
                Archive{numsOfSolsInArchive}.firstFailureExhibited = timeFirstFailureExhibited;
                verdictEnhanced = true;
            end
        catch
           disp('non-compilable model'); 
        end
        bdclose(nonFaultyModel);
        bdclose([faultyModel '_' num2str(numOfIterations)]);
        bdclose('all')
    end
    
    %Local search
    numOfLocalTries = 0;
    totalLocalTries = 30;
    modelToPerformLocalMutations = numsOfSolsInArchive;
    
    while numOfLocalTries<totalLocalTries && toc<timeBudget
        numOfLocalTries = numOfLocalTries+1;
        numOfIterations=numOfIterations+1;
        selectedModelToMutate = modelToPerformLocalMutations; % it is the last 
        faultyModel = Archive{modelToPerformLocalMutations}.modelName;
        copyfile([faultyModel '.slx'], [faultyModel '_' num2str(numOfIterations) '.slx']); 
        open_system([faultyModel '_' num2str(numOfIterations) '.slx']);
        done = false;
        while done == false
            [done] = applyLocalMutations(statesOrTransitions, stateNum, transNum);
        end
        %
        try
            save_system([faultyModel '_' num2str(numOfIterations) '.slx']);
        catch
        end
        
        bdclose([faultyModel '_' num2str(numOfIterations) '.slx']);

        %bdclose(modelname)
        try
            [verdict,timeVerdictActive,criticalityVerdict,timeFirstFailureExhibited] = executeTest([faultyModel '_' num2str(numOfIterations) ]);
            if sum(verdict)==0
                plausiblePatchFound =true;
                numsOfPlausiblePatches = numsOfPlausiblePatches+1;
                PlausiblePatches{numsOfPlausiblePatches} = [faultyModel '_' num2str(numOfIterations)];
                disp(['Plausible patch found! This one it is = ' [faultyModel '_' num2str(numOfIterations)]]);
            elseif (timeVerdictActive<Archive{selectedModelToMutate}.timeVerdict || criticalityVerdict<Archive{selectedModelToMutate}.criticality || timeFirstFailureExhibited>Archive{selectedModelToMutate}.firstFailureExhibited )...
                    && ~(timeVerdictActive>Archive{selectedModelToMutate}.timeVerdict || criticalityVerdict>Archive{selectedModelToMutate}.criticality || timeFirstFailureExhibited<Archive{selectedModelToMutate}.firstFailureExhibited )
                faultyModel = [faultyModel '_' num2str(numOfIterations)];
                plausiblePatchFound = false;
                numsOfSolsInArchive = numsOfSolsInArchive+1;
                Archive{numsOfSolsInArchive}.modelName = faultyModel;%[faultyModel '_' num2str(numOfIterations)];
                Archive{numsOfSolsInArchive}.timeVerdict = timeVerdictActive;
                Archive{numsOfSolsInArchive}.criticality = criticalityVerdict;
                Archive{numsOfSolsInArchive}.firstFailureExhibited = timeFirstFailureExhibited;
                verdictEnhanced = true;
                %restart
                modelToPerformLocalMutations = numsOfSolsInArchive;
                numOfLocalTries=0;
            end
        catch
           disp('non-compilable model'); 
        end
        bdclose(nonFaultyModel);
        bdclose([faultyModel '_' num2str(numOfIterations)]);
        bdclose('all')
        
    end
    Archive = clearArchive(Archive);
end

function Archive = clearArchive(Archive)
    %TODO -> Implement function
    Archive = Archive;

end

function selected_index = rouletteWheelSelection(probabilities)
    cumulative_probs = cumsum(probabilities)/sum(probabilities); % Compute cumulative probabilities
    selection = rand(); % Generate a random number between 0 and 1
    
    % Perform Roulette Wheel Selection
    selected_index = find(cumulative_probs >= selection, 1);
end


function [done]= applyLocalMutations(statesOrTransitions, stateNum, transNum)

    numOfMutationsDone = 0;
    rt = sfroot;
 %    while rand<0.5^numOfMutationsDone
%         done = false;
    done = false;    
    while done == false
        states = getStates(rt);
        transitions = getTransitions(rt);
        %this comes now as inputstatesOrTransitions = 2;%randi([1,2]);
        
        if statesOrTransitions==1
              %choose a state
            %stateNumNowComesAsInputstateNum = randi([1,length(states)]);
            try
                if stateNum > size(states,1)
                    done = true;
                    break;
                else
                    chosenState = states(stateNum);
                end
            catch
                disp('Problem when parsing states');
                done = true;
                break;
            end
            %chosenTrans = transitions(randi([1,length(transitions)]));
             selectedOperator = randi([1,8]);
            if selectedOperator==1
                try 
                    done = deleteVariableFromState(chosenState,rt);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==2
                try 
                    done = insertMathematicalOperation(chosenState);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==3
                try 
                    done = deleteVariableFromState(chosenState,rt);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==4
                try 
                    done = deleteState(chosenState,transitions,states);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==5
                try 
                    outputs = getOutputs(rt);
                    
                    done = insertVariableInState(chosenState,outputs(randi(randi([1,length(outputs)]))));
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==6
                try 
                    done = changeAssignation(chosenState);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==7
                try 
                    done = replaceMathematicalOperatorInState(chosenState);
                catch
                    disp('Problem when generating mutation'); 
                end
            elseif selectedOperator==8
                try 
                    outputs = getOutputs(rt);
                    done = numericalReplacementOfVariableInState2(chosenState,outputs);
                catch
                    disp('Problem when generating mutation'); 
                end
            end
                
                
                
        else
            %choose a transition
            %transNum = 12;%randi([1,length(transitions)]);
            if length(transitions) < transNum
                chosenTrans = randi([1,length(transitions)]);
                
            else
                chosenTrans = transitions(transNum);
            end
            %transitions(chosenTrans);
            selectedOperator = randi([1,11]);
            if selectedOperator==1
                try 
                    done = deleteConditionFromTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==2
                try
                    done = insertConditionInTransition(chosenTrans,rt);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==3
                try
                    done = deleteTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==4
                try
                    done = numericalChangeInTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');%bug (reproduced after mutation 32)
                end
            elseif selectedOperator==5
                try
                    done = relationalOperatorReplacement(chosenTrans); % potential bug (reproduced after mutation 14); looks like it comes from another place
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==6
                try
                    done = replaceSecMsecInAfter(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==7
                try
                    done = replaceMathematicalOperatorInTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==8
               try
                    done = replaceConditionalOperator(chosenTrans);
               catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==9
               try
                    done = replaceInitialTransition(transitions,states);
               catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==10
               try
                    done = replacementOfTransitionDestination(chosenTrans,states);
               catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator ==11
                try
                    done = replacementOfTransitionSource(chosenTrans,states);
                catch
                    disp('Problem when generating mutation');
                end
            end

        end
    end
              
        
    numOfMutationsDone = numOfMutationsDone+1;

end


function [done, statesOrTransitions, stateNum, transNum]= applyGlobalMutations(suspiciousness_transitions,suspiciousness_states)
    numOfMutationsDone = 0;
    rt = sfroot;
 %    while rand<0.5^numOfMutationsDone
%         done = false;
    done = false;    
    while done == false
        states = getStates(rt);
        transitions = getTransitions(rt);
        statesOrTransitions = randi([1,2]);
        
        stateNum = 0;
        transNum = 0;
        if statesOrTransitions==1
              %choose a state
            %Uncomment next if you want to do it without considering Fault
            %Localization data
            %stateNum = randi([1,length(states)]);
            if length(states) == length(suspiciousness_states) 
                stateNum = rouletteWheelSelection(suspiciousness_states);
                chosenState = states(stateNum);
            else
                stateNum = randi([1,length(states)]);
            end
            %chosenTrans = transitions(randi([1,length(transitions)]));
             selectedOperator = randi([1,8]);
            if selectedOperator==1
                try 
                    done = deleteVariableFromState(chosenState,rt);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==2
                try 
                    done = insertMathematicalOperation(chosenState);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==3
                try 
                    done = deleteVariableFromState(chosenState,rt);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==4
                try 
                    done = deleteState(chosenState,transitions,states);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==5
                try 
                    outputs = getOutputs(rt);
                    
                    done = insertVariableInState(chosenState,outputs(randi(randi([1,length(outputs)]))));
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==6
                try 
                    done = changeAssignation(chosenState);
                catch
                    disp('Problem when generating mutation');
                end
            
            elseif selectedOperator==7
                try 
                    done = replaceMathematicalOperatorInState(chosenState);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==8
                try 
                    outputs = getOutputs(rt);
                    done = numericalReplacementOfVariableInState2(chosenState,outputs);
                    %done = numericalReplacementOfVariableInState(chosenState,outputs(randi(randi([1,length(outputs)]))));
                catch
                    disp('Problem when generating mutation'); 
                end
            end
                
                
                
        else
            %choose a transition
            %Uncomment next if no Fault Localization data available
            %transNum = %randi([1,length(transitions)]);
            if length(transitions) == length(suspiciousness_transitions)  %added because of a weird bug.
                transNum= rouletteWheelSelection(suspiciousness_transitions);
            else
                transNum = randi([1,length(transitions)]);
            end
            chosenTrans = transitions(transNum);
            %transitions(chosenTrans);
            selectedOperator = randi([1,11]);
            if selectedOperator==1
                try 
                    done = deleteConditionFromTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==2
                try
                    done = insertConditionInTransition(chosenTrans,rt);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==3
                try
                    done = deleteTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==4
                try
                    done = numericalChangeInTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');%bug (reproduced after mutation 32)
                end
            elseif selectedOperator==5
                try
                    done = relationalOperatorReplacement(chosenTrans); % potential bug (reproduced after mutation 14); looks like it comes from another place
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==6
                try
                    done = replaceSecMsecInAfter(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==7
                try
                    done = replaceMathematicalOperatorInTransition(chosenTrans);
                catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==8
               try
                    done = replaceConditionalOperator(chosenTrans);
               catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==9
               try
                    done = replaceInitialTransition(transitions,states);
               catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator==10
               try
                    done = replacementOfTransitionDestination(chosenTrans,states);
               catch
                    disp('Problem when generating mutation');
                end
            elseif selectedOperator ==11
                try
                    done = replacementOfTransitionSource(chosenTrans,states);
                catch
                    disp('Problem when generating mutation');
                end
            end

        end
    end
              
        
        numOfMutationsDone = numOfMutationsDone+1;
end
    

%end
