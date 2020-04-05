Levels = Level;
SweepRates = Sweep;
RabiFreqs = Rabi;
Freqs = GetCareFrequencies(G, [1 1], [1 1], CarrierFreq, GeomOrientation);
%Find all motional frequencies that lie within a sweep
FreqsMotional = Freqs(Levels+1:size(Freqs, 1), :);
FreqsEnc = Freqs(1:Levels, :);
AllDiffs = [];
for i = 1:length(FreqsMotional)
    Motionali = FreqsMotional(i, :);
    for j = 1:Levels
        Encj = FreqsEnc(j, :);
        Diff = abs(Motionali(1) - Encj(1));
        AllDiffs = [AllDiffs; Diff Encj(:,1:7) Motionali(:,1:7)];
    end
end
AllDiffsInside = AllDiffs(AllDiffs(:,1) <= Detuning, :);
disp([AllDiffsInside(:, 1:2)*1e-9 AllDiffsInside(:, 3:8) AllDiffsInside(:, 9)*1e-9 AllDiffsInside(:, 10:15)]);
%Take out all motional frequencies which were inside, so we don't count
%them for the off resonant calculation
[temp, index] = intersect(Freqs(:, 1), AllDiffsInside(:, 9));
Freqs(index, :) = [];

%Setup probability and time matrices
Prob = ones(length(SweepRates), length(RabiFreqs));
TotalTime = zeros(length(SweepRates), length(RabiFreqs));
%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(SweepRates, 1, length(RabiFreqs));
RabiMat = repmat(RabiFreqs, length(SweepRates), 1);

Freqss = Freqs(:,1);
Clebschs = Freqs(:,6);
Order = Freqs(:, 7);

%Find which transfer we're doing from the frequencies
WhichTransition = find(all(Freqs(:, 2:5) == [1 1 1 1], 2));

Prob = Prob.*Prob6(G.Linewidth, RabiMat, SweepMat, Freqss, G.Fidelity, WhichTransition, Clebschs, Detuning, Order);

%Calculate transfer time for each sweeprate
TransferTime = 2*Detuning./SweepMat;
%TransferTime = TransferTime.';
%Add to transfer tally
TotalTime = TotalTime + TransferTime;
%Add in decay error
if G.DecayTimeErrorOn
    Prob = Prob.*exp(-TransferTime/G.DecayTime);
end