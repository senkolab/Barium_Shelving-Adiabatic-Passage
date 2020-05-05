%% Intitial and constants
clearvars
addpath('..\..\..\Functions\Frequencies_EnergyStructure', '..\..\..\altmany-export_fig-9502702');
%Constants of the experiment
%Geometric orientation - XZ, Orthogonal, or Average
GeomOrientation = "XZ";
%Carrier frequency
CarrierFreq = -1130e6;
Detuning = 1.3e6;
%Tau = 5;%5 Hz Linewidth
Linewidth = 2;
%Fidelity
F = 1;

%Set variational global variables
setVarGlobals(GeomOrientation, CarrierFreq, Detuning, Linewidth, F);
%Get the more concrete global variables
G = getGlobals_V3();

%Turn off/on plots
Graph3 = true;
Graph5 = true;
Graph7 = true;
Graph = Graph3 || Graph5 || Graph7;
ShowWorst = false;
SavePDF = false;
SavePDFName = sprintf("Measurement%s_%gMHzCarrier_%gMHzDetuning_%gHz", GeomOrientation, CarrierFreq*1e-6, Detuning*1e-6, Linewidth);
SavePDFName = strrep(SavePDFName, ".", "p");

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
    ax = gca;
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
    "Shelve", 5, 5;...%1
    "Shelve", 6, 6;...%2
    "Fluoresce", 2, 2;...%3
    "Deshelve", 5, 5;...%4
    "Fluoresce", 5, 5];%5
    [Line3, ProbIdeal3Level, TotalTime3Level, ShelvingSpecs3Level] = ...
        GraphMeasurement_V3(3, false, Rabi, Sweep, ThreeBestMeasurement);
    Leg{numGraphs} = '3 level';
    numGraphs = numGraphs + 1;
    %No motional sidebands, so no worst measurement
    ThreeWorstMeasurement = [];
    if ShowWorst && ~isempty(ThreeWorstMeasurement)
        [Line3W, ProbIdeal3LevelW, TotalTime3LevelW, ShelvingSpecs3LevelW] = ...
            GraphMeasurement_V3(3, true, Rabi, Sweep, ThreeWorstMeasurement);
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
    [Line5, ProbIdeal5Level, TotalTime5Level, ShelvingSpecs5Level] = ...
        GraphMeasurement_V3(5, false, Rabi, Sweep, FiveBestMeasurement);
    Leg{numGraphs} = '5 level';
    numGraphs = numGraphs + 1;
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
    if ShowWorst && ~isempty(FiveWorstMeasurement)
        %Drive a carrier twice, a first order motional sideband twice
        [Line5W, ProbIdeal5LevelW, TotalTime5LevelW, ShelvingSpecs5LevelW] = ...
            GraphMeasurement_V3(5, true, Rabi, Sweep, FiveWorstMeasurement);
        Leg{numGraphs} = '5 level worst';
        numGraphs = numGraphs + 1;
    end
end
if Graph7
    %
    SevenBestMeasurement = [...
        "Shelve" 2 2;...
        "Shelve" 4 4;...
        "Shelve" 6 6;...
        "Hide" 7 6;...
        "Hide" 3 2;...
        "Shelve" 8 8;...
        "Hide" 6 7;...
        "Shelve" 7 7;...
        "Hide" 2 3;...
        "Shelve" 3 3;...
        "Fluoresce" 5 5;...
        "Deshelve" 2 2
        "Fluoresce" 2 2;...
        "Deshelve" 4 4;...
        "Fluoresce" 4 4;...
        "Deshelve" 6 6;...
        "Fluoresce" 6 6;...
        "Deshelve" 7 7;...
        "Fluoresce" 7 7;...
        "Deshelve" 8 8;...
        "Fluoresce" 8 8];
    [Line7, ProbIdeal7Level, TotalTime7Level, ShelvingSpecs7Level] = ...
        GraphMeasurement_V3(7, false, Rabi, Sweep, SevenBestMeasurement);
    Leg{numGraphs} = '7 level';
    numGraphs = numGraphs + 1;
    SevenWorstMeasurement = [];
    if ShowWorst && ~isempty(SevenWorstMeasurement)
        %Drive a carrier twice, a first order motional sideband twice
        [Line7W, ProbIdeal7LevelW, TotalTime7LevelW, Shelvingspecs7LevelW] = ...
            GraphMeasurement_V3(7, true, Rabi, Sweep, SevenWorstMeasurement);
        Leg{numGraphs} = '7 level worst';
        numGraphs = numGraphs + 1;
    end
end

%% Touch up graph
if Graph
    l3 = legend(Leg, 'Location', 'Northeast','FontSize',14);
    %ax5.Title.String = 'Qudit measurement fidelity';
    %ax5.Title.FontSize = 30;
    ax.FontSize = 14;
    if G.TimeScaling == 1e3
        timetext = "ms";
    else
        timetext = "s";
    end
    ax.XLabel.String = sprintf('Total measurement time (%s)', timetext);
    ax.XLabel.FontSize = 20;
    ax.YLabel.String = 'Fidelity';
    ax.YLabel.FontSize = 20;
    ylim([G.Thresh 1]);
    xlim([5e-4 3e-1]*G.TimeScaling);
    set(ax, 'YTick', 0:0.005:1,...
        'YMinorTick', 'on', 'TickDir', 'out',...
        'YGrid', 'on', 'XGrid', 'on')
    tickslabel = ax.XTickLabel;
    newtickslabel = [];
    for i = 1:length(tickslabel)
        label = char(tickslabel(i));
        label = strrep(label, "{", "");
        label = strrep(label, "}", "");
        label = strrep(label, "^", "e");
        label = str2double(label)*0.1;
        newlabel = sprintf("%d", label);
        newtickslabel(i) = newlabel;
    end
    ax.XTickLabel = num2str(newtickslabel.');
    set(gcf, 'Position', [100 100 600 500]);
    %set(gcf, 'Renderer', 'opengl');
    %saveas(gcf, 'Overall_Measurement.pdf');
    if SavePDF
        export_fig(SavePDFName, '-pdf', '-opengl')
    end
end