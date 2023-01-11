clear;
clc;
rng(0);%to debug
name = 'simpleStateflowModel';

budget = 50;
totalMutants = 0;
while totalMutants<budget
   totalMutants=totalMutants+1;
   disp(['Total mutations applied = ' num2str(totalMutants)]);
   copyfile([name '.slx'], [name '_' num2str(totalMutants) '.slx']); 
   open_system([name '_' num2str(totalMutants) '.slx']);
   applyMutations();
   executeTest([name '_' num2str(totalMutants) '.slx']);
   save_system([name '_' num2str(totalMutants) '.slx']);
   close_system([name '_' num2str(totalMutants) '.slx']);
end

function done = applyMutations()
    numOfMutationsDone = 0;
    rt = sfroot;
    while rand<0.5^numOfMutationsDone
        done = false;
        try
            while done == false
                states = getStates(rt);
                transitions = getTransitions(rt);
                statesOrTransitions = 0;%randi([0,1]);
                if statesOrTransitions==1
                      %choose a state
                    chosenState = randi([1,length(states)]);
                else
                %choose a transition
                chosenTrans = transitions(randi([1,length(transitions)]));
                %transitions(chosenTrans);
                selectedOperator = randi([1,11]);
                if selectedOperator==1
                    done = deleteConditionFromTransition(chosenTrans);
                elseif selectedOperator==2
                    done = insertConditionInTransition(chosenTrans,rt);
                elseif selectedOperator==3
                    done = deleteTransition(chosenTrans);
                elseif selectedOperator==4
                    done = numericalChangeInTransition(chosenTrans);
                elseif selectedOperator==5
                    done = relationalOperatorReplacement(chosenTrans);
                elseif selectedOperator==6
                    done = replaceSecMsecInAfter(chosenTrans);     
                elseif selectedOperator==7
                    done = replaceMathematicalOperatorInTransition(chosenTrans);
                elseif selectedOperator==8
                   done = replaceConditionalOperator(chosenTrans); 
                elseif selectedOperator==9
                   done = replaceInitialTransition(transitions,states); 
                elseif selectedOperator==10
                   done = replacementOfTransitionDestination(chosenTrans,states);
                elseif selectedOperator ==11
                    done = replacementOfTransitionSource(chosenTrans,states);
                end
                    
                end
            end
        catch
            disp('problem');
        end
        
        
        numOfMutationsDone = numOfMutationsDone+1;
    end
    

end

function verdict = executeTest(model)
    try
        sim(model);
        verdict = 0;
    catch
       disp('non-compilable model'); 
    end

end

