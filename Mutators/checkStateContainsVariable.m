function variableInState = checkStateContainsVariable(state,variable)
    strState = state.Label;
    strVariable = variable.Name;
    variableInState = contains(strState,strVariable);
end