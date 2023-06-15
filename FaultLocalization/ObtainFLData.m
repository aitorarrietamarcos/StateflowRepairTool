clear;
clc;
close all;
%% Things to configure:

InstrumentedModel = 'Model1_Scenario2_Faulty_2020a_instrumented.slx'; % Add here the name of the instrumented model
executeTest = @executeTestPacemaker; % Add here the interface function for the execution of the test case.
NtestCases = 3;


%% Start getting the data


open(InstrumentedModel);
rt = sfroot;
states = getStates(rt);%find(rt,'-isa','Stateflow.State'); % get all states from the stateflow model
transitions = getTransitions(rt);%find(rt,'-isa','Stateflow.Transition');
numOfStates = size(states,1);
numOfTrans = size(transitions,1);
%close_system(InstrumentedModel);

transCov = zeros(numOfTrans,NtestCases);
statesCov = zeros(numOfStates,NtestCases);

Ncf_transitions = zeros(numOfTrans,1);
Ncf_states = zeros(numOfStates,1);

Ncs_transitions = zeros(numOfTrans,1);
Ncs_states = zeros(numOfStates,1);

Nf = 0;
Ns = 0;


for ii=1:NtestCases
   [Trans States Verdict] = executeTest(InstrumentedModel,ii);
   for jj=1:numOfStates
       if sum(States.Data==jj)>0 %if true, it means, state jj has been triggered
          statesCov(jj,ii)=1; 
          if strcmp(Verdict,'Pass')
              Ncs_states(jj,1) =  Ncs_states(jj,1)+1;
              
          elseif strcmp(Verdict,'Fail')
              Ncf_states(jj,1)=Ncf_states(jj,1)+1;
             
              
          end
       else
          if strcmp(Verdict,'Pass') &&jj==1
              Ns = Ns+1;
          elseif strcmp(Verdict,'Fail')&&jj==1
              Nf = Nf +1;
          end
       end
   end
   for jj=1:numOfTrans
       if sum(Trans.Data==jj)>0 %if true, it means, state jj has been triggered
          transCov(jj,ii)=1; 
          if strcmp(Verdict,'Pass')
              Ncs_transitions(jj,1) = Ncs_transitions(jj,1)+1;
              
          elseif strcmp(Verdict,'Fail')
              Ncf_transitions(jj,1) = Ncf_transitions(jj,1)+1;
          end
                 
       end
   end
   aitor = 0;
end

for ii=1:size(Ncf_states,1)
    if isnan((Ncf_states(ii,1)/Nf)/(Ncf_states(ii,1)/Nf+Ncs_states(ii,1)/Ns))
        tarantula_states(ii,1) = 0;
    else
        tarantula_states(ii,1) = (Ncf_states(ii,1)/Nf)/(Ncf_states(ii,1)/Nf+Ncs_states(ii,1)/Ns);
    end
end
for ii=1:size(Ncf_transitions,1)
    if isnan((Ncf_transitions(ii,1)/Nf)/(Ncf_transitions(ii,1)/Nf+Ncs_transitions(ii,1)/Ns))
        tarantula_transitions(ii,1) = 0;
    else   
        tarantula_transitions(ii,1) = (Ncf_transitions(ii,1)/Nf)/(Ncf_transitions(ii,1)/Nf+Ncs_transitions(ii,1)/Ns);
    end    
end

