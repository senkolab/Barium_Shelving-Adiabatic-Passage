function [Prob, TotalTime] = MeasurementProb(Level, DetMatrix, RabiFreqs, SweepRates, FreqsCare, WhichTransfers, Detuning)
%Function that returns the probability of measurement accounting for
%off-resonant errors, initial detuning error, dephasing error, and LZ error
G = getGlobals();
%Setup probability and time matrices
Prob = ones(length(SweepRates), length(RabiFreqs));
TotalTime = zeros(length(SweepRates), length(RabiFreqs));
%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(SweepRates, 1, length(RabiFreqs));
RabiMat = repmat(RabiFreqs, length(SweepRates), 1);

Freqs = FreqsCare(:,1);
Clebschs = FreqsCare(:,6);
Order = FreqsCare(:, 7);
k = 0;
%Go through each shelving passage
for i = 1:Level-1
    k = k + 1;
    %Get the prob of the this transfer
    prob = Prob6(G.Linewidth, RabiMat, SweepMat, Freqs, G.Fidelity, WhichTransfers(k), Clebschs, Detuning, Order);
    %Calculate transfer time for each sweeprate
    TransferTime = 2*Detuning./SweepMat;
    %TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTime = TotalTime + TransferTime;
    %Add in decay error
    if G.DecayTimeErrorOn
        prob = prob.*exp(-TransferTime/G.DecayTime);
    end
    %Mult this transfer prob to the tally prob
    Prob = Prob.*prob;
end
%Go through each deshelving passage
for i = 1:Level-2
    k = k + 1;
    %Get the prob of the this transfer
    prob = Prob6(G.Linewidth, RabiMat, SweepMat, Freqs, G.Fidelity, WhichTransfers(k), Clebschs, Detuning, Order);
    %Calculate transfer time for each sweeprate
    TransferTime = 2*Detuning./SweepMat;
    %TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTime = TotalTime + TransferTime;
    %Add in decay error
    if G.DecayTimeErrorOn
        prob = prob.*exp(-TransferTime/G.DecayTime);
    end
    %Mult this transfer prob to the tally prob
    Prob = Prob.*prob;
end
if ~isempty(DetMatrix)
    Prob = Prob.*MotionalSweeps(DetMatrix, SweepRates, RabiFreqs);
end
end