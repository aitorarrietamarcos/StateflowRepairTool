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
done = replaceMathematicalOperatorInTransition(transitions(2));

done = replaceConditionalOperator(transitions(2));

done = insertVariableInState(states(1),outputs(1));
hasIt = checkStateContainsVariable(states(1),outputs(1));
variablesInState = getVariablesInState(getOutputs(rt),states(1));

done = changeAssignation(states(1));

done = numericalReplacementOfVariableInState(states(1),outputs(1));
%done = replacementOfTransitionSource(transitions(2),states);

a = isInitialTransition(transitions(3));
replaceInitialTransition(transitions,states);
b = replacementOfTransitionSource(transitions(1),states);

function done = replaceMathematicalOperatorInTransition(transition)
    done = false;
    containsPlus = false;
    containsMinus = false;
    containsMult = false;
    containsDiv = false;
    plusLocations = 0;
    minusLocations = 0;
    multLocations = 0;
    divLocations = 0;
    str = convertCharsToStrings(transition.LabelString);
    if (contains(str,'+') || contains(str,'-') ||...
       contains(str,'*') || contains(str,'/')) && isInitialTransition(transition)==false
        if contains(str,'+')
            containsPlus = true;
            plusLocations = strfind(str, '+');
        end
        if contains(str,'-')
            containsMinus = true;
            minusLocations = strfind(str, '-');
        end
        if contains(str,'*')
            containsMult = true;
            multLocations = strfind(str, '*');
        end
        if contains(str,'/')
            containsDiv = true;
            divLocations = strfind(str, '/');
        end
        locations = [];
        if containsPlus
            locations = [locations  plusLocations];
        end
        if containsMinus
            locations = [locations  minusLocations];
        end
        if containsMult
            locations = [locations  multLocations];
        end
        if containsDiv
            locations = [locations  divLocations];
        end
        whichToChange = randi([1 length(locations)]);
        if strcmp(transition.LabelString(locations(whichToChange)),'+')
            if rand <= 0.5
                transition.LabelString(locations(whichToChange)) = '-';
                done = true;
            else
               if rand <=0.5 && strcmp(transition.LabelString(locations(whichToChange)+1), '0')==false
                   transition.LabelString(locations(whichToChange)) = '/';
                   done = true;
               else
                   transition.LabelString(locations(whichToChange)) = '*';
                   done = true;
               end
            end
            
        elseif strcmp(transition.LabelString(locations(whichToChange)),'-')
            if rand <= 0.5
                transition.LabelString(locations(whichToChange)) = '+';
                done = true;
            else
               if rand <=0.5 &&  strcmp(transition.LabelString(locations(whichToChange)+1), '0')==false
                   transition.LabelString(locations(whichToChange)) = '/';
                   done = true;
               else
                   transition.LabelString(locations(whichToChange)) = '*';
                   done = true;
               end
            end
            
        elseif strcmp(transition.LabelString(locations(whichToChange)),'*')
            if rand <= 0.5 && strcmp(transition.LabelString(locations(whichToChange)+1), '0')==false
                transition.LabelString(locations(whichToChange)) = '/';
                done = true;
            else
               if rand <=0.5
                   transition.LabelString(locations(whichToChange)) = '+';
                   done = true;
               else
                   transition.LabelString(locations(whichToChange)) = '-';
                   done = true;
               end
            end
            
        elseif strcmp(transition.LabelString(locations(whichToChange)),'/')
            if rand <= 0.5
                transition.LabelString(locations(whichToChange)) = '*';
                done = true;
            else
               if rand <=0.5
                   transition.LabelString(locations(whichToChange)) = '-';
                   done = true;
               else
                   transition.LabelString(locations(whichToChange)) = '+';
                   done = true;
               end
            end
            
        end
    end
end


function done = replaceMathematicalOperatorInState(state)
    done = false;
    containsPlus = false;
    containsMinus = false;
    containsMult = false;
    containsDiv = false;
    plusLocations = 0;
    minusLocations = 0;
    multLocations = 0;
    divLocations = 0;
    str = convertCharsToStrings(state.Label);
    if contains(str,'+') || contains(str,'-') ||...
       contains(str,'*') || contains(str,'/')
        if contains(str,'+')
            containsPlus = true;
            plusLocations = strfind(str, '+');
        end
        if contains(str,'-')
            containsMinus = true;
            minusLocations = strfind(str, '-');
        end
        if contains(str,'*')
            containsMult = true;
            multLocations = strfind(str, '*');
        end
        if contains(str,'/')
            containsDiv = true;
            divLocations = strfind(str, '/');
        end
        locations = [];
        if containsPlus
            locations = [locations  plusLocations];
        end
        if containsMinus
            locations = [locations  minusLocations];
        end
        if containsMult
            locations = [locations  multLocations];
        end
        if containsDiv
            locations = [locations  divLocations];
        end
        whichToChange = randi([1 length(locations)]);
        if strcmp(state.Label(locations(whichToChange)),'+')
            if rand <= 0.5
                state.Label(locations(whichToChange)) = '-';
                done = true;
            else
               if rand <=0.5 && strcmp(state.Label(locations(whichToChange)+1), '0')==false
                   state.Label(locations(whichToChange)) = '/';
                   done = true;
               else
                   state.Label(locations(whichToChange)) = '*';
                   done = true;
               end
            end
            
        elseif strcmp(state.Label(locations(whichToChange)),'-')
            if rand <= 0.5
                state.Label(locations(whichToChange)) = '+';
                done = true;
            else
               if rand <=0.5 &&  strcmp(state.Label(locations(whichToChange)+1), '0')==false
                   state.Label(locations(whichToChange)) = '/';
                   done = true;
               else
                   state.Label(locations(whichToChange)) = '*';
                   done = true;
               end
            end
            
        elseif strcmp(state.Label(locations(whichToChange)),'*')
            if rand <= 0.5 && strcmp(state.Label(locations(whichToChange)+1), '0')==false
                state.Label(locations(whichToChange)) = '/';
                done = true;
            else
               if rand <=0.5
                   state.Label(locations(whichToChange)) = '+';
                   done = true;
               else
                   state.Label(locations(whichToChange)) = '-';
                   done = true;
               end
            end
            
        elseif strcmp(state.Label(locations(whichToChange)),'/')
            if rand <= 0.5
                state.Label(locations(whichToChange)) = '*';
                done = true;
            else
               if rand <=0.5
                   state.Label(locations(whichToChange)) = '-';
                   done = true;
               else
                   state.Label(locations(whichToChange)) = '+';
                   done = true;
               end
            end
            
        end
        
%         numOfTotalOp = containsPlus+containsMinus+ContainsMult+containsDiv;
%         prob = 1/numOfTotalOp;
%         selectOp = randi([1,numOfTotalOp]);
%         i=1;
%         if containsPlus==1
%             if selectOp == i
%                %replace plus 
%             end
%             i = i+1;           
%         end
%         if containsMinus ==1
%             if selectOp ==i
%                 %replace minus
%             end
%         end
%         if containsMult ==1
%             if selectOp ==i
%                 %replaceMult
%             end
%         end
        
    end
    
end


function done = replaceConditionalOperator(transition)
    done = false;
    replaceAnd = false;
    replaceOr = false;
    str = transition.LabelString;
    if isInitialTransition(transition)==false
       if contains(str,'&&')&& contains(str,'||')
           if rand<=0.5
               replaceAnd = true;
           else
               replaceOr = true;
           end           
       elseif contains(str,'&&')
           replaceAnd = true;
           
       elseif contains(str,'||')
           replaceOr = true;           
       else
          %No conditional operator 
          
       end
       if replaceAnd
            andLocations = strfind(str, '&&');
            whichToChange = randi([1 length(andLocations)]);
            str(andLocations(whichToChange)) = '|'; % Replace first e with null (in other words, delete it).
            str(andLocations(whichToChange)+1) = '|';
            transition.LabelString = str;
            done = true;
       end
       if replaceOr
            orLocations = strfind(str, '||');
            whichToChange = randi([1 length(orLocations)]);
            str(orLocations(whichToChange)) = '&'; % Replace first e with null (in other words, delete it).
            str(orLocations(whichToChange)+1) = '&';
            transition.LabelString = str;
            done = true;
       end
    end
end


function done = insertVariableInState(state,output)
    done = false;
    if(contains(state.Label,output.Name)==false)
        str = convertCharsToStrings(state.Label);
        selectVal = rand;
        if selectVal < 0.4
            str = str + newline + output.Name + '=' + num2str(0) + ';';
        elseif selectVal < 0.8
            str = str + newline + output.Name + '=' + num2str(1) + ';';
        else
            str = str + newline + output.Name + '=' + num2str(randi([0 50])) + ';'; % pulir esto
        end
        state.Label = str;
        done = true;
    end
end

function done = changeAssignation(state)
    done = false;
    if contains(state.Label,'entry:')
        done = true;
        if rand <0.8
            %change entry for during
            str = convertCharsToStrings(state.Label);
            newStr = strrep(str,'entry','during');
            state.Label = newStr;
            
        else
           %change entry for exit--exit is less used, this is why less prob.
           str = convertCharsToStrings(state.Label);
           newStr = strrep(str,'entry','exit');
           state.Label = newStr;
        end
        
    elseif contains(state.Label,'during:')
        done = true;
        if rand <0.8
            %change entry for entry
            str = convertCharsToStrings(state.Label);
            newStr = strrep(str,'during','entry');
            state.Label = newStr;
            
        else
           %change entry for exit--exit is less used, this is why less prob. 
           str = convertCharsToStrings(state.Label);
           newStr = strrep(str,'during','exit');
           state.Label = newStr;
            
        end
        
    elseif contains(state.Label,'exit:')
        done = true;
        if rand <=0.5
            %change exit for during
           str = convertCharsToStrings(state.Label);
           newStr = strrep(str,'exit','during');
           state.Label = newStr;
        else
           % change exit for entry
           str = convertCharsToStrings(state.Label);
           newStr = strrep(str,'exit','entry');
           state.Label = newStr;
        end
        
    end
    
end

function done = replaceInitialTransition(transitions,states)
    done = false;
    for ii=1:size(transitions,1)
       if isInitialTransition(transitions(ii))
           done = replacementOfTransitionDestination(transitions(ii),states);
       end
    end

end

function is = isInitialTransition(tran)
    is = isa(tran.Source,'Stateflow.State')==false;
end

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
    if size(states,1)>1 && isInitialTransition(trans) == false
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