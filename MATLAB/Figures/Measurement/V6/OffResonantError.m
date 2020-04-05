function [OProb] = OffResonantError(Freqss, Level, Clebsch, Rabi, Detuning, Order, Eta)
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
    %Decrease strength of transition based on the order of the transition
    Strength = Eta^abs(Order(i));
    %OProb= OProb + Rabi.^2./(2*(Rabi.^2 + min(DetuningsStart(i), DetuningsEnd(i))^2))*(Clebsch(i))^2;
    OProb = OProb.*(1-Strength*Rabi.^2./(2*(Rabi.^2 + min(DetuningsStart(i), DetuningsEnd(i))^2))*(Clebsch(i))^2);
end
%disp(OProb(1,:));
%OProb = 1;
%OProb = 1 - OProb;
end