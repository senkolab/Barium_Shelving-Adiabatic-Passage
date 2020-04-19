function [Prob] = MotionalSweepsV2(Freq, SweepRatesRabi, RabiFreqs)
%This function calculates the error from driving a motional sideband
%coherently. The inputs are:
%Freq: contains information on the desired transition that this unwanted transition
%is driven from, and information on the unwanted transition itself. It's
%laid out as follows:
%Col1: Frequency distance from an important transition
%Col2: Frequency of important transition
%Col3:6: F level info of important transition
%Col7: Clebschs Gordan coefficient of important transition
%Col8: Motional order of important transition
%Col9:15: ^^ information but for the unwanted transition
%SweepRatesRabi: matrix of sweep rates
%RabiFreqs: vector of all rabi frequencies
%Detuning: initial detuning for a wanted transition

%Get the session global variables
[GeomOrientation, CarrierFreq, Detuning, Linewidth, F] = getVarGlobals();

G = getGlobals_V3();
disp(Freq(14));
DetuningMotional = max(abs(Detuning -Freq(1)), abs(Detuning + Freq(1)));
Clebsch = Freq(14);
%Calculate the normalization coefficient to normalize to the transition of
%interest
ClebschMainNormal = 1/Clebsch;
%Multiply all coefficients of Clebsch by the normalization constant
Clebsch = Clebsch*ClebschMainNormal;
Order = abs(Freq(15));
prob = Prob5_v2(Linewidth, RabiFreqs, SweepRatesRabi, DetuningMotional, F, Order, Clebsch);
Prob = (1-prob);
end