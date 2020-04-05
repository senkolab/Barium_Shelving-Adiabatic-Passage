function [RabiTimeProb, Line, ProbIdeal, TotalTime] = ...
    GraphMeasurement(Freqs, Level, Worst, Rabi, Sweep, FluorescenceSteps, Hide)
G = getGlobals;
[GeomOrientation, CarrierFreq, Detuning, Linewidth, F] = getVarGlobals();

Care = GetCareTransitions(Level, Freqs, GeomOrientation, Hide);
Freqs = Freqs(Care, :);
%Get the parameters for this calculation
if Level == 3
    Ind = 1;
elseif Level == 5
    Ind = 2;
elseif Level == 7
    Ind = 3;
end
Color = G.Colors(Ind, :);
if Worst
    LineStyle = G.WorstLineStyle;
else
    LineStyle = cell2mat(G.LineStyles(Ind));
end
if Level == 3
    if Worst
        Which = G.ThreeWorst;
        DetMatrix = G.ThreeWorstDet;
    else
        Which = G.ThreeBest;
        DetMatrix = G.ThreeBestDet;
    end
elseif Level == 5
    if Worst
        Which = G.FiveWorst;
        DetMatrix = G.FiveWorstDet;
    else
        Which = G.FiveBest;
        DetMatrix = G.FiveBestDet;
    end
elseif Level == 7
    if Worst
        Which = G.SevenWorst;
        DetMatrix = G.SevenWorstDet;
    else
        Which = G.SevenBest;
        DetMatrix = G.SevenBestDet;
    end
end

if Level == 3
    Encoded = G.EncodedBaseG3;
    EncodedP = G.EncodedBaseP3;
elseif Level == 5
    Encoded = G.EncodedBaseG5;
    EncodedP = G.EncodedBaseP5;
elseif Level == 7
    Encoded = G.EncodedBaseG7;
    EncodedP = G.EncodedBaseP7;
end
MoveEnc = [];
MoveEncP = [];
if ~isempty(MoveEnc)
    Encoded(MoveEnc(:, 1), :) = Encoded(MoveEnc(:, 2:3));%Change so that instead, we look at two inputs of MoveEnc...
end
if ~isempty(MoveEncP)
    EncodedP(MoveEncP(:,1), :) = EncodedP(MoveEnc(:, 2:3));
end

%Calculate probabilities from errors: LZ, Dephasing, Off-resonant
%coupling, initial detuning
[ProbIdeal, TotalTime] = MeasurementProb(Level, DetMatrix, Rabi, Sweep, Freqs, Which, Detuning);
[ProbIdeal, index] = max(ProbIdeal);
TotalTimeOpt = zeros(1, length(index));
for i = 1:length(index)
    TotalTimeOpt(i) = TotalTime(index(i));
end
TotalTime = TotalTimeOpt;

%Fluorescence
TotalFTime = G.FluorescenceTime*FluorescenceSteps;
TotalTime= TotalTime + TotalFTime;
ProbIdeal = ProbIdeal.*exp(-TotalFTime/G.DecayTime);

%Final graphing and data organizing
RabiTimeProb = [Rabi.' TotalTime' ProbIdeal.'];
if Worst
    fprintf("Worst %i-level: %f\n", Level, max(ProbIdeal));
else
    fprintf("Ideal %i-level: %f\n", Level, max(ProbIdeal));
end
ProbIdeal(ProbIdeal<G.Thresh) = -inf;
Line = semilogx(TotalTime, ProbIdeal);
hold on;
set(Line, 'Linewidth', 1.5, 'Linestyle', LineStyle, 'Color', Color);
end