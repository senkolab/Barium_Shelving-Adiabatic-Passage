%Calculate the probability of adiabatic passage, with dephasing effects 
%according to Lacour et. al., and with two equidistant energy levels around
%the level of interest. Rabi and Sweep arrays.
function [Prob] = Prob3(Tau, Rabi, sweep, Detuning, Fidelity, ODetuning)
%Theta calculation at initial detuning
Theta = 1/2*atan(Rabi/Detuning);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(Theta).^2;
%StateDetuningError = 0;
%Lander Zanau Probability
%ProbLZ = 1 - exp(-pi()^2*Rabi^2./sweep);
ProbLZ = 1 - exp(-pi()^2*Rabi.^2./sweep*1e3);%Sweep in ms units
%DephasingExp = exp(-2*pi()^2*Tau*Rabi./sweep);
DephasingExp = exp(-2*pi()^2*Tau*Rabi./sweep*1e3);%Sweep in ms units
%Other energy level's effective Rabi Frequency
ORabi = sqrt(Rabi.^2 + ODetuning^2);
%Probability of exciting this other level: Using Steck equation 5.60,
%Assume upper bound for sine function
OProb = Rabi.^2./(2*ORabi.^2);
%OProb = 0;
%OProb = 0;
Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*(1 - OProb).^2.*(1 - StateDetuningError).^2;
%Phase error, State prep error
%Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*(1 - StateDetuningError).^2;
%Phase error, other level coupling
%Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*(1 - OProb).^2;
%Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2));
%Prob = ProbLZ;
end

