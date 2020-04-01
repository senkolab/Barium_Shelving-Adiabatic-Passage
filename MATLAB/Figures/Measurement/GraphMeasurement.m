function [RabiTimeProb, Line, ProbIdeal, TotalTime] = GraphMeasurement(Freqs, Level, Worst, Rabi, Sweep, Detuning, FluorescenceSteps)
G = getGlobals;
%Get the parameters for this calculation
if Level == 3
    Color = G.ThreeColor;
    LineStyle = G.ThreeLineStyle;
    if Worst
        Which = G.ThreeWorst;
        DetMatrix = G.ThreeWorstDet;
        LineStyle = G.WorstLineStyle;
    else
        Which = G.ThreeBest;
        DetMatrix = G.ThreeBestDet;
    end
elseif Level == 5
    Color = G.FiveColor;
    LineStyle = G.FiveLineStyle;
    if Worst
        Which = G.FiveWorst;
        DetMatrix = G.FiveWorstDet;
        LineStyle = G.WorstLineStyle;
    else
        Which = G.FiveBest;
        DetMatrix = G.FiveBestDet;
    end
elseif Level == 7
    Color = G.SevenColor;
    LineStyle = G.SevenLineStyle;
    if Worst
        Which = G.SevenWorst;
        DetMatrix = G.SevenWorstDet;
        LineStyle = G.WorstLineStyle;
    else
        Which = G.SevenBest;
        DetMatrix = G.SevenBestDet;
    end
end
%Detunings of each motional sideband from the sweep start/end
if ~isempty(DetMatrix)
    DetMatrix(1,:) = min(abs(Detuning -str2double(DetMatrix(1,:))), abs(Detuning + str2double(DetMatrix(1,:))));
end

%Calculate probabilities from errors: LZ, Dephasing, Off-resonant
%coupling, initial detuning
[ProbIdeal, TotalTime] = MeasurementProb(Level, Rabi, Sweep, Freqs, Which, Detuning);
if G.MotionalErrorOn && ~isempty(DetMatrix)
    ProbIdeal = ProbIdeal.*MotionalSweeps(DetMatrix, Sweep, Rabi);
end
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
fprintf("Ideal %i-level: %f\n", Level, max(ProbIdeal));
ProbIdeal(ProbIdeal<G.Thresh) = -inf;
Line = semilogx(TotalTime, ProbIdeal);
hold on;
set(Line, 'Linewidth', 1.5, 'Linestyle', LineStyle, 'Color', Color);
end