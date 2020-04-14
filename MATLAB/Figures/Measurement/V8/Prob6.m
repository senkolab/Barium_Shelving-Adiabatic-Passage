function[Prob] = Prob6(Linewidth, Rabi, Sweep, Freqs, Fidelity, Level, Detuning)
%This function returns the probability of a transfer, taking into account
%off-resonant error to other levels, error from the intitial detuning,
%error from LZ adiabatic passage, error from dephasing
%The inputs are
%Linewidth: the linewidth of the laser
%Rabi: a matrix of Rabi frequencies
%Sweep: a matrix of Sweeprates, the same size as Rabi
%Freqs: a list of all frequencies that could be off-resoantly driven
%Fidelity: a scaling factor for the fidelity
%Level: Which encoded transfer are we doing?
%Clebschs: a list of clebschs gordan coefficients for each of these
%frequencies
%Detuning: the detuning we start the laser sweep at
%Order: a list of what motional order these frequencies are

G = getGlobals_V3();

%Pull out the frequencies, clebschs gordan coefficients, and motional orders
Freqss = Freqs(:,1);
Clebschs = Freqs(:,6);
Orders = Freqs(:, 7);

%Calculate the error from off-resonantly driving frequencies
if G.OffResErrorOn
    OProb = OffResonantError(Freqss, Level, Clebschs, Rabi, Detuning, Orders, G.Eta);
else
    OProb = 1;
end
%Calculate the initial detuning error
if G.DetuningErrorOn
    %Theta calculation at initial detuning
    Theta = 1/2*atan(Rabi/Detuning);
    %Initial adiabatic state error based on detuning not being infinite
    StateDetuningError = sin(Theta).^2;
    %StateDetuningError = 0;
else
    StateDetuningError = 0;
end
%Calculate the Landau Zener probability for the adiabatic passage
if G.LZErrorOn
    %Lander Zanau Probability
    ProbLZ = 1 - exp(-G.LZExp*Rabi.^2./Sweep);
else
    ProbLZ = 1;
end
%Calculate the dephasing exponential from Lacour et. al.
if G.DephasingErrorOn
    %Dephasing exponential Lacour et. al. + noel et. al.
    DephasingExp = exp(-G.DephasingExp*Linewidth*Rabi./Sweep);
else
    DephasingExp = 1;
end
%Put all the errors together
Prob = Fidelity*(1/2 + DephasingExp.*(ProbLZ - 1/2)).*OProb.*(1 - StateDetuningError).^2;
end
