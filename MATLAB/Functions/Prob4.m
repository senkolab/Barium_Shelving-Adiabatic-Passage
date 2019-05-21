function[Prob] = Prob4(Linewidth, Rabi, Sweep, DetuningsLevel, SmallestDetuning, Fidelity)
%Start with detuning halfway between levels
Detuning = SmallestDetuning/2;
%Detuning from the adjacent levels
ODetuning1 = DetuningsLevel(1) - Detuning;
ODetuning2 = DetuningsLevel(2) - Detuning;
%Theta calculation at initial detuning
Theta = 1/2*atan(Rabi/Detuning);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(Theta).^2;
%StateDetuningError = 0;
%Lander Zanau Probability
ProbLZ = 1 - exp(-pi()^2*Rabi.^2./Sweep);
%Dephasing exponential Lacour et. al.
DephasingExp = exp(-2*pi()^3*Linewidth*Rabi./Sweep);
%Effective Rabi Freq
ORabi1 = sqrt(Rabi.^2 + ODetuning1^2);
ORabi2 = sqrt(Rabi.^2 + ODetuning2^2);
%Probability of exciting this other level: Using Steck equation 5.60,
%Assume average for sine function
OProb1 = Rabi.^2./(2*ORabi1.^2);
OProb2 = Rabi.^2./(2*ORabi2.^2);
%OProb = 0;
Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*(1-OProb1).*(1-OProb2).*(1 - StateDetuningError).^2;
end
