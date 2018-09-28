%Calculate the probability of adiabatic passage, with no other spectral
%features, dephasing effects according to Lacour et. al. Sweep Rate array
function [Prob] = Prob1(Tau, Rabi, sweep, Detuning, Fidelity)
%Theta calculation at initial detuning
Theta = 1/2*atan(Rabi./Detuning);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(Theta).^2;
%Lander Zanau Probability
%ProbLZ = 1 - exp(-pi()^2*Rabi^2./sweep);
ProbLZ = 1 - exp(-pi()^2*Rabi^2./sweep*1e3);%Sweep in ms units
%DephasingExp = exp(-2*pi()^2*Tau*Rabi./sweep);
DephasingExp = exp(-2*pi()^2*Tau*Rabi./sweep*1e3);%Sweep in ms units
Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2))*(1 - StateDetuningError)^2;
end

