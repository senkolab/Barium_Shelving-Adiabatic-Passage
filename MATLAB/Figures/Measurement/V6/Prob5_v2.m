%This function does not have off-resonant error
function[Prob] = Prob5_v2(Linewidth, Rabi, Sweep, Detuning, Fidelity, SidebandOrder)
eta = 0.0246;
Rabi = Rabi*eta^SidebandOrder;
%Theta calculation at initial detuning
Theta = 1/2*atan(Rabi/Detuning);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(Theta).^2;
%StateDetuningError = 0;
%Lander Zanau Probability
ProbLZ = 1 - exp(-pi()^2*Rabi.^2./Sweep);
%Dephasing exponential Lacour et. al.
DephasingExp = exp(-2*pi()^3*Linewidth*Rabi./Sweep);
Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*(1 - StateDetuningError).^2;
end
