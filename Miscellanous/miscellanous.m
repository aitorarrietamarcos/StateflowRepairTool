%% Miscellanous

clear;
clc;
%start

%open('simpleStateflowModel.slx')
rt = sfroot;
states = getStates(rt);%find(rt,'-isa','Stateflow.State'); % get all states from the stateflow model
transitions = getTransitions(rt);%find(rt,'-isa','Stateflow.Transition');
data = find(rt,'-isa','Stateflow.Data');
inputs = getInputs(rt);
outputs = getOutputs(rt);
hasIt = checkStateContainsVariable(states(1),outputs(1));
variablesInState = getVariablesInState(getOutputs(rt),states(1));

done = numericalReplacementOfVariableInState(states(1),outputs(1))
%done = replacementOfTransitionSource(transitions(2),states);

function done = replacementOfTransitionDestination(trans,states)
    done = false;
    if size(states,1)>1
        stateSame = true;
        while stateSame
            newDestinationState = randi([1 size(states,1)]);
            stateSame = trans.Destination == states(newDestinationState);
            if stateSame == false
                trans.Destination = states(newDestinationState);
                done = true;
            end
        end
    end
    
end

function done = replacementOfTransitionSource(trans,states)
    done = false;
    if size(states,1)>1
        stateSame = true;
        while stateSame
            newSourceState = randi([1 size(states,1)]);
            stateSame = trans.Source == states(newSourceState);
            if stateSame == false
                trans.Source = states(newSourceState);
                done = true;
            end
        end
    end
    
end

function done = numericalReplacementOfVariableInState(state,var)
    done = false;
    if checkStateContainsVariable(state,var)
       str = split(convertCharsToStrings(state.Label),newline);
       for jj=1:size(str,1)
           if contains([str{jj} ' '],var.Name)|| contains([str{jj} '='],var.Name) % can be problematic
               stringOfVar = str(jj);
               numberStr =  split(stringOfVar,'=');
               number =  str2num(numberStr(2));
               numberSel = rand;
               if numberSel < 0.33
                   newNum = 1; % I want 1/3 of the time the num to be 1
               elseif numberSel < 0.66
                   newNum = 0; % I want 1/3 of the time the num to be 0
               else
                    newNum = randi([number-100 number+100 ]); % TODO -> polish this
               end
               str(jj) = strcat(numberStr(1), '=', num2str(newNum),';');
               done = true;
               break; % we supose only once is declared the variable
           end
       end
       if done
           lab = '';
           for jj=1:size(str,1)
              lab =  lab + str(jj) + newline;
           end
           state.Label = lab;
       end
    end

end


function vars = getVariablesInState(variablesToLookAt,state)
    numOfVars = 0;
    for ii=1:size(variablesToLookAt,1)
        if checkStateContainsVariable(state,variablesToLookAt(ii))
            numOfVars = numOfVars+1;
            vars(numOfVars) =  variablesToLookAt(ii);         
        end
    end
end

function state = getStates(rt)
    state= find(rt,'-isa','Stateflow.State');
end

function transitions = getTransitions(rt)
    transitions = find(rt,'-isa','Stateflow.Transition');
end

function inputs = getInputs(rt)
    data = find(rt,'-isa','Stateflow.Data');
    numOfInputs = 0;
    
    for ii=1:size(data,1)
        if strcmp(data(ii).Scope,'Input')
            numOfInputs = numOfInputs+1;
            inputs(numOfInputs,1) = data(ii);            
        end
    end
end

function outputs = getOutputs(rt)
    data = find(rt,'-isa','Stateflow.Data');
    numOfOutputs = 0;
    
    for ii=1:size(data,1)
        if strcmp(data(ii).Scope,'Output')
            numOfOutputs = numOfOutputs+1;
            outputs(numOfOutputs,1) = data(ii);            
        end
    end
end

function variableInState = checkStateContainsVariable(state,variable)
    strState = state.Label;
    strVariable = variable.Name;
    variableInState = contains(strState,strVariable);
end