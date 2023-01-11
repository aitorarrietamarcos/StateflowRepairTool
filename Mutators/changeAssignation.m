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
