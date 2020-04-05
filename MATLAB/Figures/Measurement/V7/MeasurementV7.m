%MeasurementV6: 
%% Intitial and constants
clearvars
addpath('..\..\..\Functions\Frequencies_EnergyStructure');
%Constants of the experiment
%Decay time of metastable state
DecayTime = 35;

%Geometric orientation - XZ, Orthogonal, or Average
GeomOrientation = "XZ";
%Carrier frequency
CarrierFreq = -1092e6;
Detuning = 1.31e6;
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Fidelity
F = 1;

%Set variational global variables
setVarGlobals(GeomOrientation, CarrierFreq, Detuning, Linewidth, F);
%Get the more concrete global variables
G = getGlobals_V2();

%Turn off/on plots
Graph3 = true;
Graph5 = true;
Graph7 = false;
Graph = Graph3 || Graph5 || Graph7;
ShowWorst = false;

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
    %Changing CarrierFreq to a lower frequency (Below -1120), the 3-level no
    %longer has any motional sidebands at all, so there is no worst case now
    %The best case involves shelving 2.p0:p0, then 1.p1:p1, and then
    %deshelving 2.p0:p0, resulting in no motional sidebands driven
    %Columns do
    %Col1: What type of step is this?
    %Col2: Lower level state
    %Col3: Upper level state
    ThreeBestMeasurement = [...
    "Shelve", 5, 5;...
    "Shelve", 6, 6;...
    "Fluoresce", 2, 2;...
    "Deshelve", 5, 5;...
    "Fluoresce", 5, 5];
    [Line3, ProbIdeal3Level, TotalTime3Level] = ...
        GraphMeasurement_V2(3, false, Rabi, Sweep, ThreeBestMeasurement);
    Leg{numGraphs} = '3 level';
    numGraphs = numGraphs + 1;
    %No motional sidebands, so no worst measurement
    ThreeWorstMeasurement = [];
    if ShowWorst && ~isempty(ThreeWorstMeasurement)
        [Line3W, ProbIdeal3LevelW, TotalTime3LevelW] = ...
            GraphMeasurement_V2(3, true, Rabi, Sweep, ThreeWorstMeasurement);
        Leg{numGraphs} = '3 level worst';
        numGraphs = numGraphs + 1;
    end
end
if Graph5
    %Best case drive 2.p0:p0, 1.p1:p1, 1.n1:n1, 2.p2:p2, then deshelve
    %2.p0:p0, 2.p2:p2, 1.p1:p1. By changing the carrier frequency from -1092 to
    %-1130, we've gotten rid of all motional sidebands within sweeps for this
    FiveBestMeasurement = [...
        "Shelve" 6 6;...
        "Shelve" 2 2;...
        "Hide" 1 2;...
        "Shelve" 8 8;...
        "Shelve" 5 5;...
        "Fluoresce" 2 2;...
        "Deshelve" 5 5;...
        "Fluoresce" 5 5;...
        "Deshelve" 2 2;...
        "Fluoresce" 2 2;...
        "Deshelve" 6 6;...
        "Fluoresce" 6 6
        ];
    [Line5, ProbIdeal5Level, TotalTime5Level] = ...
        GraphMeasurement_V2(5, false, Rabi, Sweep, FiveBestMeasurement);
    Leg{numGraphs} = '5 level';
    numGraphs = numGraphs + 1;
    if ShowWorst && ~isempty(G.FiveWorstDet)
        %Drive a carrier twice, a first order motional sideband twice
        FiveWorstMeasurement = [...
            "Shelve" 5 5;...
            "Shelve" 1 1;...
            "Shelve" 8 8;...
            "Shelve" 2 2;...
            "Fluoresce" 6 6;...
            "Deshelve" 1 1;...
            "Fluoresce" 1 1;...
            "Deshelve" 8 8;...
            "Fluoresce" 8 8;...
            "Deshelve" 5 5;...
            "Fluoresce" 5 5];
        [Line5W, ProbIdeal5LevelW, TotalTime5LevelW] = ...
            GraphMeasurement_V2(5, true, Rabi, Sweep, FiveWorstMeasurement);
        Leg{numGraphs} = '5 level worst';
        numGraphs = numGraphs + 1;
    end
end

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