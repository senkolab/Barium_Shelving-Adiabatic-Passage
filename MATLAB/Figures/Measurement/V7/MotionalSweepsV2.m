function [Prob] = MotionalSweepsV2(Freq, SweepRatesRabi, RabiFreqs, Detuning)
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


G = getGlobals_V2();
DetuningMotional = min(abs(Detuning -Freq(1)), abs(Detuning + Freq(1)));
Order = abs(Freq(15));
prob = Prob5_v2(G.Linewidth, RabiFreqs, SweepRatesRabi, DetuningMotional, G.Fidelity, Order);
Prob = (1-prob);
end