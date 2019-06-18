function[Prob] = Prob5(Linewidth, Rabi, Sweep, Freqss, Fidelity, Level, Clebsch)
%Start with detuning offset from the adjacent transition
DetuningOffsetstart = 200000;
%FreqDiff = abs(Freqss(Level) -Freqss);
%Get all frequency detunings of other levels from level of interest
FreqDiff = Freqss(Level) -Freqss;
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
%Find the smallest detuning and its entry
[SmallestFreqDiff, SmallestIndex] = min(abs(FreqDiff));
%Find the smallest detuning (sign included)
SmallestFreqDiff = FreqDiff(SmallestIndex);
%SmallestFreqDiff = min(FreqDiff);
%Start with detuning offset from adjacent transition by smallest transition
Detuning = abs(SmallestFreqDiff)- DetuningOffsetstart;
%Find all detunings at start
DetuningsStart = abs(FreqDiff - Detuning);
%Find all detunings at end of transfer
DetuningsEnd = abs(FreqDiff + Detuning);
OProb = zeros(size(Rabi));
%Go through and add in off resonant coupling error from start and end of
%transfer for all possible transitions
for i = 1:length(DetuningsStart)
    OProb= OProb.*Rabi.^2./(2*(Rabi.^2 + DetuningsStart(i)^2))*(Clebsch(i))^2;
    OProb= OProb.*Rabi.^2./(2*(Rabi.^2 + DetuningsEnd(i)^2))*(Clebsch(i))^2;
end
%OProb = 0;
%Theta calculation at initial detuning
Theta = 1/2*atan(Rabi/Detuning);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(Theta).^2;
%StateDetuningError = 0;
%Lander Zanau Probability
ProbLZ = 1 - exp(-pi()^2*Rabi.^2./Sweep);
%Dephasing exponential Lacour et. al.
DephasingExp = exp(-2*pi()^3*Linewidth*Rabi./Sweep);

Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*(1-OProb).*(1 - StateDetuningError).^2;
end
