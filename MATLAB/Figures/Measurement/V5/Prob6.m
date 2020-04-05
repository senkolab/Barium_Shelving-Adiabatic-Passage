function[Prob] = Prob6(Linewidth, Rabi, Sweep, Freqss, Fidelity, Level, Clebsch, Detuning)
G = getGlobals();
if G.OffResErrorOn
    OProb = OffResonantError(Freqss, Level, Clebsch, Rabi, Detuning);
else
    OProb = 1;
end
if G.DetuningErrorOn
    %Theta calculation at initial detuning
    Theta = 1/2*atan(Rabi/Detuning);
    %Initial adiabatic state error based on detuning not being infinite
    StateDetuningError = sin(Theta).^2;
    %StateDetuningError = 0;
else
    StateDetuningError = 0;
end
if G.LZErrorOn
    %Lander Zanau Probability
    ProbLZ = 1 - exp(-pi()^2*Rabi.^2./Sweep);
else
    ProbLZ = 1;
end
if G.DephasingErrorOn
    %Dephasing exponential Lacour et. al. + noel et. al.
    DephasingExp = exp(-2*pi()^2*Linewidth*Rabi./Sweep);
else
    DephasingExp = 1;
end

Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*OProb.*(1 - StateDetuningError).^2;
end
