function[Prob] = Prob5(Linewidth, Rabi, Sweep, Freqss, Fidelity, Level, Clebsch, Detuning)
G = getGlobals();
if G.OffResErrorOn
    %Get all frequency detunings of other levels from level of interest
    FreqDiff = Freqss(Level) - Freqss;
    %Delete entry for the level of interest, which should be equal to 0 right
    %now
    FreqDiff(Level) = [];
    %Calculate the normalization coefficient to normalize to the transition of
    %interest
    ClebschMainNormal = 1/Clebsch(Level);
    %Multiply all coefficients of Clebsch by the normalization constant
    Clebsch = Clebsch*ClebschMainNormal;
    %Delete level of interest entry of Clebsch
    Clebsch(Level) = [];
    %Find all detunings at start
    DetuningsStart = abs(FreqDiff - Detuning);
    %Find all detunings at end of transfer
    DetuningsEnd = abs(FreqDiff + Detuning);
    OProb = ones(size(Rabi));
    %Go through and add in off resonant coupling error from start and end of
    %transfer for all possible transitions
    for i = 1:length(DetuningsStart)
        %OProb= OProb + Rabi.^2./(2*(Rabi.^2 + min(DetuningsStart(i), DetuningsEnd(i))^2))*(Clebsch(i))^2;
        OProb = OProb.*(1-Rabi.^2./(2*(Rabi.^2 + min(DetuningsStart(i), DetuningsEnd(i))^2))*(Clebsch(i))^2);
    end
    %disp(OProb(1,:));
    %OProb = 1;
    %OProb = 1 - OProb;
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
    %Dephasing exponential Lacour et. al.
    DephasingExp = exp(-2*pi()^3*Linewidth*Rabi./Sweep);
else
    DephasingExp = 1;
end

Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*OProb.*(1 - StateDetuningError).^2;
end
