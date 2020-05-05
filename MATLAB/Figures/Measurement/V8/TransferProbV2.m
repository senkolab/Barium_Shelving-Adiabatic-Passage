function [Prob, TotalTime, FreqDoing] = TransferProbV2(G, SweepRates, RabiFreqs, Levels, Level1, Level2, LevelsG, LevelsP, Single)
%This function gives the probability of a transfer
%The outputs are the probabilities of the transfer for different rabi rates,
%sweep rates, and the time for each of these probabilities
%The inputs are
%G: a global variable containing energy structure information, and information on which errors
%we're keeping on
%SweepRates: a vector of all sweeprates
%RabiFreqs: a vector of all rabi frequencies
%Levels: the d in qudit. How many levels are in our encoding?
%Level1: which lower level are we driving from?
%Level2: which upper level are we driving to?
%LevelsG: contains all information on status of ground state
%LevelsP: contains all information on status of excited state
%Single: boolean saying whether this is for the single population transfer
%figure or the measurements figure

%Get the session global variables
[GeomOrientation, CarrierFreq, Detuning, Linewidth, F] = getVarGlobals();

%Get all of the frequencies that matter given the status of the ground
%state and excited state
Freqs = GetCareFrequencies(G, LevelsG, LevelsP, CarrierFreq, GeomOrientation);

%Find which transfer we're doing from the frequencies
WhichTransition = find(all([all(Freqs(:, 2:5) == [Level1 Level2], 2) Freqs(:, 7) == 0], 2));
FreqDoing = Freqs(WhichTransition, :);

if G.MotionalErrorOn
    %Find all motional frequencies that lie within this sweep
    FreqsMotional = Freqs(Levels+1:size(Freqs, 1), :);
    AllDiffs = [];
    for i = 1:length(FreqsMotional)
        Motionali = FreqsMotional(i, :);
        Diff = abs(Motionali(1) - FreqDoing(1));
        AllDiffs = [AllDiffs; Diff FreqDoing(:,1:7) Motionali(:,1:7)];
    end
    FreqsInsideSweep = AllDiffs(AllDiffs(:,1) <= Detuning, :);
    %Get rid of transitions that are themselves - detuning is zero
    if ~isempty(FreqsInsideSweep)
        FreqsInsideSweep = FreqsInsideSweep(FreqsInsideSweep(:, 1) ~=0, :);
    end
    %FreqsInsideSweep laid out as follows:
    %Col1: Frequency distance from an important transition
    %Col2: Frequency of important transition
    %Col3:6: F level info of important transition
    %Col7: Clebschs Gordan coefficient of important transition
    %Col8: Motional order of important transition
    %Col9:15: ^^ information but for the unwanted transition

    %Take out all motional frequencies which were inside, so we don't count
    %them for the off resonant calculation
    if ~isempty(FreqsInsideSweep)
        [temp, index] = intersect(Freqs(:, 1), FreqsInsideSweep(:, 9));
        Freqs(index, :) = [];
    end
    if ~isempty(FreqsInsideSweep)
        %Go through each, displaying information about this motional sweep
        for i = 1:size(FreqsInsideSweep, 1)
            %Find out which level was swept through, and whether it was in the
            %excited state or not
            [indexx, indexy] = find([all(FreqsInsideSweep(i, 10:11) == LevelsG, 2) all(FreqsInsideSweep(i, 12:13) == LevelsP, 2)], 2);
            %If it was in the ground state, form text with F, mF
            if indexy == 1
                GroundState = LevelsG(indexx, :);
                TextEncState = sprintf("F=%i, mF=%i", GroundState(1), GroundState(2));
            %If it was in the excited state, form text with F', mF'
            elseif indexy == 2
                ExcitedState = LevelsP(indexx, :);
                TextEncState = sprintf("F'=%i, mF'=%i", ExcitedState(1), ExcitedState(2));
            %Case where there exists population in both states
            elseif size(indexy, 1) == 2
                ExcitedState = LevelsP(indexx(2),:);
                GroundState = LevelsG(indexx(1),:);
                TextEncState = sprintf("F'=%i, mF'=%i, to encoded state F = %i, mF=%i", ExcitedState(1), ExcitedState(2), GroundState(1), GroundState(2));
            end
            if abs(FreqsInsideSweep(i, 15)) == 0
                TextOrder = sprintf("Carrier");
            elseif abs(FreqsInsideSweep(i, 15)) == 1
                TextOrder = sprintf("1st order");
            elseif abs(FreqsInsideSweep(i, 15)) == 2
                TextOrder = sprintf("2nd order");
            end
            %Print the information
            fprintf("A %s motional frequency driving F=%i, mF = %i, F'=%i, mF'=%i was swept, driving population from encoded state %s.\n", ...
                TextOrder, FreqsInsideSweep(i, 10), FreqsInsideSweep(i, 11), FreqsInsideSweep(i, 12), FreqsInsideSweep(i, 13), TextEncState);
        end
    end
else
    FreqsInsideSweep = [];
end

%Setup probability and time matrices
Prob = ones(length(SweepRates), length(RabiFreqs));
TotalTime = zeros(length(SweepRates), length(RabiFreqs));
%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(SweepRates, 1, length(RabiFreqs));
RabiMat = repmat(RabiFreqs, length(SweepRates), 1);

%Calculate the probabiltiy of transfer for all errors but motional sweeping
Prob = Prob.*Prob6(Linewidth, RabiMat, SweepMat, Freqs, F, WhichTransition, Detuning);

%Add in motional frequency sweep through an unwanted transition
if ~isempty(FreqsInsideSweep)
    FreqsMotSweep = FreqsInsideSweep(find(Freqs(WhichTransition, 1) == FreqsInsideSweep(:, 2)), :);
    for j = 1:size(FreqsMotSweep, 1)
        Prob = Prob.*MotionalSweepsV2(FreqsMotSweep(j, :), SweepMat, RabiFreqs);
    end
end
%Calculate transfer time for each sweeprate
TransferTime = 2*Detuning./SweepMat;
%Add to transfer tally
TotalTime = TotalTime + TransferTime;
%Add in decay error
if G.DecayTimeErrorOn
    Prob = Prob.*exp(-TransferTime/G.DecayTime);
end
FreqDoing = FreqDoing(1);
end