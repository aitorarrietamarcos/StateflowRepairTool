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
    end
end