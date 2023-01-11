function done = deleteTransition(transition)
    if isInitialTransition(transitions(ii))
       done = false;
    else
       delete(transition);
       done = true;
    end
    
end