%Calculate the probability of adiabatic passage, with dephasing effects 
%according to Lacour et. al., and with two equidistant energy levels around
%the level of interest. Rabi and Sweep arrays.
function [Prob] = Prob3(Linewidth, Rabi, sweep, Detuning, Fidelity, ODetuning)
%Theta calculation at initial detuning
Theta = 1/2*atan(Rabi/Detuning);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(Theta).^2;
%StateDetuningError = 0;
%Lander Zanau Probability
%2 options not concluded on yet: Noel et. al.:
ProbLZ = 1 - exp(-pi()^2*Rabi.^2./sweep*1e3);%Sweep in ms units
%Lacour et. al.:
%ProbLZ = 1 - exp(-pi()*Rabi.^2./(2*sweep)*1e3);
%2 options not concluded on yet: Noel et. al.:
DephasingExp = exp(-2*pi()^3*Linewidth*Rabi./sweep*1e3);%Sweep in ms units
%Mine/Lacour et. al(squared alpha instead):
%DephasingExp = exp(-pi()*Tau*Rabi./(2*sweep)*1e3);
%Other energy level's effective Rabi Frequency
ORabi = sqrt(Rabi.^2 + ODetuning^2);
%Probability of exciting this other level: Using Steck equation 5.60,
%Assume average for sine function
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

