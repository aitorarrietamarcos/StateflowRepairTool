
clear;
clc;
close all;
addpath functions;

modelToBeInstrumented = 'Model1_Scenario2_Faulty_2020a';
copyfile([modelToBeInstrumented '.slx'],[modelToBeInstrumented '_instrumented.slx']);

instrumentedModel = [modelToBeInstrumented '_instrumented.slx'];
close
open(instrumentedModel);
rt = sfroot;
states = getStates(rt);%find(rt,'-isa','Stateflow.State'); % get all states from the stateflow model
transitions = getTransitions(rt);%find(rt,'-isa','Stateflow.Transition');
data = find(rt,'-isa','Stateflow.Data');
inputs = getInputs(rt);
outputs = getOutputs(rt);


for i=1:size(transitions,1)
    tran = transitions(i);
    if contains(tran.LabelString,'}')
        tran.LabelString = strrep(tran.LabelString,'}',[';trans = ' num2str(i) '}']);
    else
        tran.LabelString = [tran.LabelString '{trans = ' num2str(i) '}'];
    end
end

for i=1:size(states,1)
   state = states(i);
   state.LabelString = [state.LabelString ' state = ' num2str(i) ';'];
end

%TODO: add two outputs
ch = find(rt,'-isa','Stateflow.Chart');
x = Stateflow.Data(ch);
x.Name = 'trans';
x.Scope = 'Output';

y = Stateflow.Data(ch);
y.Name = 'state';
y.Scope = 'Output';
 
save_system([modelToBeInstrumented '_instrumented.slx']);
close_system([modelToBeInstrumented '_instrumented.slx']);