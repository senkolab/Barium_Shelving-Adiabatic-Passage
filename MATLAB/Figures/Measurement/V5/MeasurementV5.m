%MeasurementV5: Clutter completely cleaned up, using functions and globals
%% Intitial and constants
clearvars
addpath('..\..\plotxx', '..\..\DrosteEffect-BrewerMap-b6a6efc', '..\..\altmany-export_fig-9502702');
G = getGlobals();
%Constants of the experiment
%Decay time of metastable state
DecayTime = 35;

Detuning = 1.31e6;
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Fidelity
F = 1;

%Turn off/on plots
Graph3 = true;
Graph5 = true;
Graph7 = false;
ShowWorst = true;

%Setup sweep rate array
%Sweep = logspace(7, 13, 4);
Sweep = logspace(8, 11, 10000);
Sweep = Sweep.'; %in seconds

%Setup Rabi Freqs
%Rabi = 10e3:1*10e3:60e3;
Rabi = 10e3:1e2:330e3;


%% Setup figure
fig = figure(5);
set(fig,'defaultAxesColorOrder',[[26 146 186]/255; [50 181 107]/255]);
%yyaxis left;
%Set background color white
set(gcf,'color','white');
%set(LevRight, 'line
ax5 = gca;
Leg = {};
numGraphs = 1;
format long g;
%% 3-level transfer calculations and graphing
if Graph3
    %3-level qudit encoded in levels
    ThreeEncoded = [5 7 13];
    %Other transitions that involve one of the 3 encoded levels
    ThreeCare = [3 4 8 11 15 18 19 20];
    ThreeCareTotal = [ThreeEncoded ThreeCare];
    %Generate all frequencies we care about
    for i = 1:length(ThreeCareTotal)
        FreqsCare3level(i, :) = G.FreqsInfoXZ(ThreeCareTotal(i),:);
    end
    Fluorescence3 = 2;
    [RabiTimeProb3, Line3, ProbIdeal3Level, TotalTime3Level] = GraphMeasurement(FreqsCare3level, 3, false, Rabi, Sweep, Detuning, Fluorescence3);
    Leg{numGraphs} = '3 level';
    numGraphs = numGraphs + 1;
    if ShowWorst
        [RabiTimeProb3W, Line3W, ProbIdeal3LevelW, TotalTime3LevelW] = GraphMeasurement(FreqsCare3level, 3, true, Rabi, Sweep, Detuning, Fluorescence3);
        Leg{numGraphs} = '3 level worst';
        numGraphs = numGraphs + 1;
    end
end
%% 5-level transfer calculations and graphing
if Graph5
    %5-level qudit encoded in levels
    FiveEncoded = [5 7 10 13 16];
    %Other transitions that involve one of the 5 encoded levels
    FiveCare = [2 3 4 8 11 15 18 19 20];
    FiveCareTotal = [FiveEncoded FiveCare];
    %Generate all frequencies we care about
    for i = 1:length(ThreeCareTotal)
        FreqsCare5level(i, :) = G.FreqsInfoXZ(FiveCareTotal(i),:);
    end
    Fluorescence5 = 4;
    [RabiTimeProb5, Line5, ProbIdeal5Level, TotalTime5Level] = GraphMeasurement(FreqsCare5level, 5, false, Rabi, Sweep, Detuning, Fluorescence5);
    Leg{numGraphs} = '5 level';
    numGraphs = numGraphs + 1;
    ShowWorst = false;
    if ShowWorst
        [RabiTimeProb5W, Line5W, ProbIdeal5LevelW, TotalTime5LevelW] = GraphMeasurement(FreqsCare5level, 5, true, Rabi, Sweep, Detuning, Fluorescence5);
        Leg{numGraphs} = '5 level worst';
        numGraphs = numGraphs + 1;
    end
end
%% Touch up graph
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