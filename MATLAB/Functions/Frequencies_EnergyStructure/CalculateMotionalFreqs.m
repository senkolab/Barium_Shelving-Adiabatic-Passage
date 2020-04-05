function [AllDiffsInside, AllDiffsOutside] = CalculateMotionalFreqs(FreqsAbs, MotionalFreq, Detuning, Level, GeomOrientation, Hide)
%Get all of the motional frequencies, both the ones that lie within a
%sweep and those that lie without.
%AllDiffsInside is laid out as follows:
%1: Difference between sweep encoding transition and this motional
%transition
%2:7: Information on this encoding transition - freq, Fs, Clebschs
%8:14: Information on the motional transition - freq, Fs, Clebschs,
%Sideband order
%AllDiffsOutside is laid out as follows:
%1:7: Information on the motional transition - freq, Fs, Clebschs, Sideband
%order
%Inputs to this function are: 
%FreqsAbs: a list of all transitions in the form of 1:6:Freq, Fs, Clebschs.
%Note that the first transition row are the encoded transitions
%MotionalFreq: The trap motional freq. in MHz
%Detuning: The detuning we choose to start our sweep with
%Level: the number of levels encoded
Care = GetCareTransitions(Level, FreqsAbs, GeomOrientation, Hide);
FreqsCare = FreqsAbs(Care, :);

%Generate all motional sidebands up to 2nd order
FreqsMotional = [];
%Last column gives whether red, blue sideband and order
for i = -2:1:2
    if i == 0
        continue
    else
        FreqsMotional = [FreqsMotional; ...
            FreqsCare(:, 1) + i*MotionalFreq FreqsCare(:, 2:6) ...
            i*ones(length(FreqsCare), 1)];
    end
end
AllDiffs = [];
for i = 1:length(FreqsMotional)
    Motionali = FreqsMotional(i, :);
    for j = 1:Level
        Carej = FreqsCare(j, :);
        Diff = abs(Motionali(1) - Carej(1));
        AllDiffs = [AllDiffs; Diff Carej Motionali];
    end
end
AllDiffsOutside = AllDiffs(AllDiffs(:,1) > Detuning, :);
AllDiffsOutside = AllDiffsOutside(:, 8:14);
%Delete duplicates
[MotOutUn, index] = unique(AllDiffsOutside(:,1));
AllDiffsOutside = AllDiffsOutside(index,:);
AllDiffsInside = AllDiffs(AllDiffs(:,1) <= Detuning, :);
end