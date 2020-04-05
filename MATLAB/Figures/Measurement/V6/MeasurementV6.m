%MeasurementV6: 
%% Intitial and constants
clearvars
addpath('..\..\..\plotxx', '..\..\..\DrosteEffect-BrewerMap-b6a6efc', ...
    '..\..\..\altmany-export_fig-9502702', '..\..\..\Functions');
%Constants of the experiment
%Decay time of metastable state
DecayTime = 35;

%Geometric orientation - XZ, Orthogonal, or Average
GeomOrientation = "XZ";
%Carrier frequency
CarrierFreq = -1130e6;
Detuning = 1.31e6;
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Fidelity
F = 1;

%Set variational global variables
setVarGlobals(GeomOrientation, CarrierFreq, Detuning, Linewidth, F);
%Get the more concrete global variables
G = getGlobals();

Hide = [];

%Turn off/on plots
Graph3 = true;
Graph5 = true;
Graph7 = false;
Graph = Graph3 || Graph5 || Graph7;
ShowWorst = false;

%Retrieve all of the relevant frequencies
[FreqsAbs, MotionalFreqs] = CalculateFreqs(G.I, G.J, G.Jp, CarrierFreq, ...
    G.EnergiesS12, G.EnergiesD52, G.Fs, G.Fps, GeomOrientation, true, G.MotionalFreq);
%Get information about motional sweep
Level = 7;
Care = GetCareTransitions(Level, FreqsAbs, GeomOrientation, Hide);
Encoded = FreqsAbs(Care(1:Level), :);
Care = FreqsAbs(Care, :);
[MotionalInside, MotionalOutside] = ...
    CalculateMotionalFreqs(Care, G.MotionalFreq, Detuning, Level, GeomOrientation, Hide);


%Setup sweep rate array
%Sweep = logspace(7, 13, 10);
Sweep = logspace(8, 11, 1000);
Sweep = Sweep.'; %in seconds

%Setup Rabi Freqs
%Rabi = 10e3:1*10e3:60e3;
Rabi = 10e3:1e2:330e3;

%% Setup figure
if Graph
    fig = figure(5);
    set(fig,'defaultAxesColorOrder',[[26 146 186]/255; [50 181 107]/255]);
    %yyaxis left;
    %Set background color white
    set(gcf,'color','white');
    %set(LevRight, 'line
    ax5 = gca;
    Leg = {};
    numGraphs = 1;
end
%format long g;
%% 3-level transfer calculations and graphing
if Graph3
    Fluorescence3 = 2;
    [RabiTimeProb3, Line3, ProbIdeal3Level, TotalTime3Level] = ...
        GraphMeasurement(FreqsAbs, 3, false, Rabi, Sweep, Fluorescence3, Hide);
    Leg{numGraphs} = '3 level';
    numGraphs = numGraphs + 1;
    if ShowWorst && ~isempty(G.ThreeWorstDet)
        [RabiTimeProb3W, Line3W, ProbIdeal3LevelW, TotalTime3LevelW] = ...
            GraphMeasurement(FreqsAbs, 3, true, Rabi, Sweep, Fluorescence3, Hide);
        Leg{numGraphs} = '3 level worst';
        numGraphs = numGraphs + 1;
    end
end
if Graph5
    Fluorescence5 = 4;
    [RabiTimeProb5, Line5, ProbIdeal5Level, TotalTime5Level] = ...
        GraphMeasurement(FreqsAbs, 5, false, Rabi, Sweep, Fluorescence5, Hide);
    Leg{numGraphs} = '5 level';
    numGraphs = numGraphs + 1;
    if ShowWorst && ~isempty(G.FiveWorstDet)
        [RabiTimeProb5W, Line5W, ProbIdeal5LevelW, TotalTime5LevelW] = ...
            GraphMeasurement(FreqsAbs, 5, true, Rabi, Sweep, Fluorescence5, Hide);
        Leg{numGraphs} = '5 level worst';
        numGraphs = numGraphs + 1;
    end
end
%% 5-level transfer calculations and graphing
% if Graph5
%     %5-level qudit encoded in levels
%     FiveEncoded = [5 7 10 13 16];
%     %Other transitions that involve one of the 5 encoded levels
%     FiveCare = [2 3 4 8 11 15 18 19 20];
%     FiveCareTotal = [FiveEncoded FiveCare];
%     %Generate all frequencies we care about
%     for i = 1:length(ThreeCareTotal)
%         FreqsCare5level(i, :) = G.FreqsInfoXZ(FiveCareTotal(i),:);
%     end
%     Fluorescence5 = 4;
%     [RabiTimeProb5, Line5, ProbIdeal5Level, TotalTime5Level] = ...
%         GraphMeasurement(FreqsCare5level, 5, false, Rabi, Sweep, Fluorescence5, Hide);
%     Leg{numGraphs} = '5 level';
%     numGraphs = numGraphs + 1;
%     ShowWorst = false;
%     if ShowWorst
%         [RabiTimeProb5W, Line5W, ProbIdeal5LevelW, TotalTime5LevelW] = ...
%             GraphMeasurement(FreqsCare5level, 5, true, Rabi, Sweep, Fluorescence5, Hide);
%         Leg{numGraphs} = '5 level worst';
%         numGraphs = numGraphs + 1;
%     end
% end
%% Touch up graph
if Graph
    l3 = legend(Leg, 'Location', 'Northeast','FontSize',14);
    %ax5.Title.String = 'Qudit measurement fidelity';
    %ax5.Title.FontSize = 30;
    ax5.FontSize = 14;
    ax5.XLabel.String = 'Total measurement time (s)';
    ax5.XLabel.FontSize = 20;
    ax5.YLabel.String = 'Fidelity';
    ax5.YLabel.FontSize = 20;
    ylim([G.Thresh 1]);
    xlim([3e-4 2e-1]);
    set(ax5, 'YTick', 0:0.005:1,...
        'YMinorTick', 'on', 'TickDir', 'out',...
        'YGrid', 'on', 'XGrid', 'on')
    %,...
    %    'XTickLabel', [0.1 1 10 100 1000]
    set(gcf, 'Position', [100 100 600 500]);
    %set(gcf, 'Renderer', 'opengl');
    %saveas(gcf, 'Overall_Measurement.pdf');
    %export_fig Overall_Measurement.pdf
    %export_fig('Overall-Measurement6.pdf', '-pdf', '-opengl')
end