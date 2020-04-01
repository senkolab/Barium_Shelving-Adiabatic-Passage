%MeasurementV3 has motional sideband calculations, Off-resonant coupling,
%and uses some functions to clean up clutter
%% Intitial and constants
clearvars
addpath('..\Functions', '..\plotxx', '..\Figures', '..\DrosteEffect-BrewerMap-b6a6efc', '..\altmany-export_fig-9502702');
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
%% Setup matrices
%3-level qudit encoded in levels
ThreeEncoded = [5 7 13];
%Other transitions that involve one of the 3 encoded levels
ThreeCare = [3 4 8 11 15 18 19 20];
ThreeCareTotal = [ThreeEncoded ThreeCare];
%Generate all frequencies we care about
for i = 1:length(ThreeCareTotal)
    FreqsCare3level(i, :) = G.FreqsInfoXZ(ThreeCareTotal(i),:);
end

%5-level qudit encoded in levels
FiveEncoded = [5 7 10 13 16];
%Other transitions that involve one of the 5 encoded levels
FiveCare = [2 3 4 8 11 15 18 19 20];
FiveCareTotal = [FiveEncoded FiveCare];
%Generate all frequencies we care about
for i = 1:length(ThreeCareTotal)
    FreqsCare5level(i, :) = G.FreqsInfoXZ(FiveCareTotal(i),:);
end

%7-level qudit encoded in levels
SevenEncoded = [5 6 7 10 12 13 14];
%Other transitions that involve one of the 7 encoded levels
SevenCare = [2 3 4 8 9 11 15 17 18 19 20];
SevenCareTotal = [SevenEncoded SevenCare];
%Generate all frequencies we care about
for i = 1:length(ThreeCareTotal)
    FreqsCare7level(i, :) = G.FreqsInfoXZ(SevenCareTotal(i),:);
end


%Setup sweep rate array
%Sweep = logspace(7, 13, 4);
Sweep = logspace(8, 11, 1000);
Sweep = Sweep.'; %in seconds

%Setup Rabi Freqs
%Rabi = 10e3:5*10e3:330e3;
Rabi = 10e3:1e2:330e3;

%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(Sweep, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Sweep), 1);

%% 3-level transfer calculations
if Graph3
    %Freqs = [FreqsCare3level ClebschsCare3level];
    Freqs = FreqsCare3level;
    %The best case involves shelving 2.p0:p0, then 1.p1:p1, and then
    %deshelving 2.p0:p0, resulting in no motional sidebands driven
    %Setup which transitions to drive at each steps
    Which = [3 2 3];
    %Calculate probabilities from errors: LZ, Dephasing, Off-resonant
    %coupling, initial detuning
    [ProbIdeal3Level, indexx, TotalTime3Level] = MeasurementProb(3, Rabi, Sweep, Freqs, Which, Detuning);
    
    %Worst case - where we drive more motional sidebands than we need to
    if ShowWorst && G.MotionalErrorOn
        %Motional sidebands - can avoid them completely as above, but here, we present
        %the worst case where we do drive transitions that sweep through them.
        %This involves first driving 1.n1:n1, then 1.p1:p1, then deshelving
        %1.n1:n1. This results in two 1st order sidebands, and 1 second
        %order sideband being driven. 
        %Setup which transitions to drive at each step
        Which = [1 2 1];
        %Calculate probabilities from errors: LZ, Dephasing, Off-resonant
        %coupling, initial detuning
        [ProbIdeal3LevelW, indexx, TotalTime3LevelW] = MeasurementProb(3, Rabi, Sweep, Freqs, Which, Detuning);
        %Detunings of each motional sideband from the encoded transition
        %2-1.p1:n1, 2.p0:p2
        DetuningsActual = [0.351200443e6 0.085487684e6];
        %Detunings of each motional sideband from the sweep start/end
        Detunings = min(abs(Detuning -DetuningsActual), abs(Detuning + DetuningsActual));
        %Motional sideband order
        Order = [1 2];
        %Which transfer above is this motional sideband driven during?
        Transfer = [1 2];
        %Is it driven twice (Meaning once for shelving, once for deshelving)?
        Twice = ["yes","no"];
        DetMatrix = [Detunings;Order;Transfer;Twice];
        ProbIdeal3LevelW = ProbIdeal3LevelW.*MotionalSweeps(DetMatrix, Sweep, Rabi, indexx);
    end
end
%% 5-level transfer calculations
if Graph5
    Freqs = FreqsCare5level;
    %Best case drive 2.p0:p0, 1.p1:p1, 1.n1:n1, 2.p2:p2, then deshelve
    %2.p0:p0, 2.p2:p2, 1.p1:p1 In this case, we drive two first order
    %sidebands, one of them sort of twice
    %Setup which transitions to drive at each steps
    Which = [4 2 1 3 4 3 2];
    %Calculate probabilities from errors: LZ, Dephasing, Off-resonant
    %coupling, initial detuning
    [ProbIdeal5Level, indexx, TotalTime5Level] = MeasurementProb(5, Rabi, Sweep, Freqs, Which, Detuning);
    if G.MotionalErrorOn
        %2:1.p1:n1, 2.n2:p0
        %Detunings of each motional sideband from the encoded transition
        DetuningsActual = [0.351200443e6 0.217087437e6];
        %Detunings of each motional sideband from the sweep start/end
        Detunings = min(abs(Detuning -DetuningsActual), abs(Detuning + DetuningsActual));
        %Which transfer above is this motional sideband driven during?
        Transfer = [3 4];
        %Matrix to tell if you need to do this transfer twice. Yes for 2.n2:p0
        %because we're swapping between a shelved and unshelved state
        Twice = ["no", "no"];
        Order = [1, 1];
        DetMatrix = [Detunings;Order;Transfer;Twice];
        ProbIdeal5Level = ProbIdeal5Level.*MotionalSweeps(DetMatrix, Sweep, Rabi, indexx);
    end
    if ShowWorst && G.MotionalErrorOn
        %The atrocious case is where we drive -2:-2,
        %resulting in a carrier other transition driving population from the
        %+2:+2 encoded level. We assume we drive 1.p1:p1, 1.n1:n1, 2.p0:p0,
        %2.p2:p2, then deshelve 1.p1:p1, 2.p2:p2, 1.n1:n1, resulting in a total
        %of two 2nd order and 4 1st order motional sidebands driven
        %Setup which transitions to drive at each steps
        Which = [2 1 4 3 2 3 1];
        %Calculate probabilities from errors: LZ, Dephasing, Off-resonant
        %coupling, initial detuning
        [ProbIdeal5LevelW, indexx, TotalTime5LevelW] = MeasurementProb(5, Rabi, Sweep, Freqs, Which, Detuning);
        %Detunings of each motional sideband from the encoded transition
        %2.p0:p2, 2-1.p1:n1, 2.n2:p0
        DetuningsActual = [0.085487684e6 0.351200443e6 0.217087437e6];
        %Detunings of each motional sideband from the sweep start/end
        Detunings = min(abs(Detuning -DetuningsActual), abs(Detuning + DetuningsActual));
        %Which transfer above is this motional sideband driven during?
        Transfer = [1 2 4];
        %Motional sideband order
        Order = [2 1 1];
        Twice = ["yes" "yes" "yes"];
        DetMatrix = [Detunings;Order;Transfer;Twice];
        ProbIdeal5LevelW = ProbIdeal5LevelW.*MotionalSweeps(DetMatrix, Sweep, Rabi, indexx);
    end
end
%% 7-level transfer calculations
if Graph7
    ProbIdeal7Level = ones(size(Rabi));
    TotalTransferTime7 = zeros(size(Rabi));
    %IdealSweeps7 = zeros(length(Detunings7Level(:,1)), length(Rabi));
    % SweepRateOpt3 = zeros(length(Detunings3Level(:,1) - 1),length(Rabi));
    %Go through each passage
    for i = 1:6
        %Get the prob of the this transfer
        prob7level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare7level, F, i, ClebschsCare7level);
        %Get the sweep rate with the best fidelity for each Rabi freq
        [ProbIdeal, index] = max(prob7level);
        %Detunings = abs(FreqsCare7level(i) -FreqsCare7level);
        %Detunings(i) = [];
        %SmallestDetuning = min(Detunings);
        %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
        TransferTime = 2*Detuning./Sweep(index);
        TransferTime = TransferTime.';
        %Add to transfer tally
        TotalTransferTime7 = TotalTransferTime7 + TransferTime;
        %Add in decay error
        ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
        %Mult this transfer prob to the tally prob
        ProbIdeal7Level = ProbIdeal.*ProbIdeal7Level;
        %Add sweep data from this transfer to sweep data array
        %IdealSweeps7(i, :) = Sweep(index);
    end
    for i = 1:5
        %Get the prob of the this transfer
        prob7level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare7level, F, i, ClebschsCare7level);
        %Get the sweep rate with the best fidelity for each Rabi freq
        [ProbIdeal, index] = max(prob5level);
        %Detunings = abs(FreqsCare7level(i) -FreqsCare7level);
        %Detunings(i) = [];
        %SmallestDetuning = min(Detunings);
        %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
        TransferTime = 2*Detuning./Sweep(index);
        TransferTime = TransferTime.';
        %Add to transfer tally
        TotalTransferTime7 = TotalTransferTime7 + TransferTime;
        %Add in decay error
        ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
        %Mult this transfer prob to the tally prob
        ProbIdeal7Level = ProbIdeal.*ProbIdeal7Level;
        %Add sweep data from this transfer to sweep data array
        %IdealSweeps7(i, :) = Sweep(index);
    end
    if G.MotionalErrorOn
        %Add in error from motional sidebands
        %Worst case first
        Detunings7w = [0.1104038e6 1.46721e6 1.089596e6 1.467208e6 1.493138e6 1.493138e6 1.3326899e6 1.33269e6];
        Twice7w = ["yes","yes","yes","yes","yes","yes","yes","yes",];
        Order = [1 2 2 2 2 2 2 2];
        ProbIdeal7LevelW = ProbIdeal7Level;
        for i = 1:length(Detunings7w)
            ProbSideband7w = Prob5_v2(Linewidth, RabiMat, SweepMat, Detunings7w(i), 1, Order(i));
            ProbIdeal7LevelW = ProbIdeal7LevelW.*(1-ProbSideband7w);
            if Twice7w(i) == "yes"
                ProbIdeal7LevelW = ProbIdeal7LevelW.*(1-ProbSideband7w);
            end
        end
    end
    
    %Best case
    Detunings7 = [1.33269e6 1.33269e6 1.49314e6 1.467208e6 1.493138e6];
    %Matrix to tell if you need to do this transfer twice
    Twice7 = ["yes", "yes", "yes", "no", "no"];
    for i = 1:length(Detunings7)
        ProbSideband7 = Prob5_v2(Linewidth, RabiMat, SweepMat, Detunings7(i), 1, 2);
        ProbIdeal7Level = ProbIdeal7Level.*(1-ProbSideband7);
        if Twice7(i) == "yes"
            ProbIdeal7Level = ProbIdeal7Level.*(1-ProbSideband7);
        end
    end
end
%% Fluorescence calculations
Fluorescence3 = 2;
Fluorescence5 = 4;
Fluorescence7 = 6;
NA = 0.5;
Angle = asin(NA);
PercentCollected = sin(Angle/2)^2;
QE = 0.8;
P12Lifetime = 7.92e-9;
SaturationFluorescenceFreq = 1/(2*2*pi()*P12Lifetime);
AssumedFluorescenceFreq = SaturationFluorescenceFreq/4;
DetectionRate = AssumedFluorescenceFreq*PercentCollected*QE;
PhotonsToCollect = 10;
FluorescenceTime = PhotonsToCollect/DetectionRate;
%Calculate overall fluorescence time, add in decay error during fluorescence
if Graph3
    TotalfTime3 = FluorescenceTime*Fluorescence3;
    ProbIdeal3Level = ProbIdeal3Level.*exp(-TotalfTime3/DecayTime);
    if ShowWorst && G.MotionalErrorOn
        ProbIdeal3LevelW = ProbIdeal3LevelW.*exp(-TotalfTime3/DecayTime);
    end
end
if Graph5
    TotalfTime5 = FluorescenceTime*Fluorescence5;
    ProbIdeal5Level = ProbIdeal5Level.*exp(-TotalfTime5/DecayTime);
    if ShowWorst && G.MotionalErrorOn
        ProbIdeal5LevelW = ProbIdeal5LevelW.*exp(-TotalfTime5/DecayTime);
    end
end
if Graph7
    TotalfTime7 = FluorescenceTime*Fluorescence7;
    ProbIdeal7Level = ProbIdeal7Level.*exp(-TotalfTime7/DecayTime);
    if ShowWorst && G.MotionalErrorOn
        ProbIdeal7LevelW = ProbIdeal7LevelW.*exp(-TotalfTime7/DecayTime);
    end
end
%% Setup data for display
%Get best probabilities for each Rabi, gate time, print the best fidelities
%for each qudit, calculate total time for the whole measurement
format long g;
if Graph3
    RabiGateTimeIdeal3 = [Rabi.' TotalTime3Level' ProbIdeal3Level.'];
    Fidelities3 = RabiGateTimeIdeal3(:,3);
    GateTimes3 = RabiGateTimeIdeal3(:,2);
    Rabis3 = RabiGateTimeIdeal3(:,1);
    disp("Ideal 3-level");
    disp(max(Fidelities3));
    TotalTime3Level = TotalTime3Level + TotalfTime3;
    if ShowWorst && G.MotionalErrorOn
        RabiGateTimeIdeal3W = [Rabi.' TotalTime3LevelW' ProbIdeal3LevelW.'];
        Fidelities3W = RabiGateTimeIdeal3W(:,3);
        TotalTime3LevelW = TotalTime3LevelW + TotalfTime3;
        disp("Worst 3-level");
        disp(max(Fidelities3W));
    end
end
if Graph5
    RabiGateTimeIdeal5 = [Rabi.' TotalTime5Level' ProbIdeal5Level.'];
    Fidelities5 = RabiGateTimeIdeal5(:,3);
    GateTimes5 = RabiGateTimeIdeal5(:,2);
    Rabis5 = RabiGateTimeIdeal5(:,1);
    TotalTime5Level = TotalTime5Level + TotalfTime5;
    disp("Ideal 5-level");
    disp(max(Fidelities5));
    if ShowWorst && G.MotionalErrorOn
        RabiGateTimeIdeal5W = [Rabi.' TotalTime5LevelW' ProbIdeal5LevelW.'];
        Fidelities5W = RabiGateTimeIdeal5W(:,3);
        TotalTime5LevelW = TotalTime5LevelW + TotalfTime5;
        disp("Worst 5-level");
        disp(max(Fidelities5W));
    end
end
if Graph7
    IdealGateTimes7 = TotalTransferTime7;
    RabiGateTimeIdeal7 = [Rabi.' IdealGateTimes7' ProbIdeal7Level.'];
    Fidelities7 = RabiGateTimeIdeal7(:,3);
    GateTimes7 = RabiGateTimeIdeal7(:,2);
    Rabis7 = RabiGateTimeIdeal7(:,1);
    disp("Ideal 7-level");
    disp(max(Fidelities7));
    if ShowWorst && G.MotionalErrorOn
        RabiGateTimeIdeal7W = [Rabi.' IdealGateTimes7' ProbIdeal7LevelW.'];
        Fidelities7W = RabiGateTimeIdeal7W(:,3);
        disp("Worst 7-level");
        disp(max(Fidelities7W));
    end
    TotalTime7 = GateTimes7 + TotalfTime7;
end
%% Graph the data
fig = figure(5);
set(fig,'defaultAxesColorOrder',[[26 146 186]/255; [50 181 107]/255]);
%Threshold to display
Thresh = 0.97;
%yyaxis left;
%Set background color white
set(gcf,'color','white');
%set(LevRight, 'line
ax5 = gca;
Leg = {};
numGraphs = 1;

if Graph3
    Fidelities3(Fidelities3<Thresh) = -inf;
    Lev3 = semilogx(TotalTime3Level, Fidelities3);
    hold on;
    set(Lev3, 'Linewidth', 1.5, 'Color', [128 0 132]/255);
    Leg{numGraphs} = '3 level';
    numGraphs = numGraphs + 1;
    if ShowWorst && G.MotionalErrorOn
        Lev3W = semilogx(TotalTime3LevelW, Fidelities3W);
        set(Lev3W, 'Linestyle', ':', 'Linewidth', 1.5, 'Color', [128 0 132]/255);
        Leg{numGraphs} = '3 level Worst';
        numGraphs = numGraphs + 1;
    end
end

if Graph5
    Fidelities5(Fidelities5<Thresh) = -inf;
    Lev5 = plot(TotalTime5Level, Fidelities5);
    hold on;
    set(Lev5, 'Linestyle', '-.', 'Linewidth', 1.5, 'Color', [0 133 93]/255);
    Leg{numGraphs} = '5 level';
    numGraphs = numGraphs + 1;
    if ShowWorst && G.MotionalErrorOn
        Lev5W = plot(TotalTime5LevelW, Fidelities5W);
        set(Lev5W, 'Linestyle', ':', 'Linewidth', 1.5, 'Color', [0 133 93]/255);
        Leg{numGraphs} = '5 level Worst';
        numGraphs = numGraphs + 1;
    end
end

if Graph7
    Fidelities7(Fidelities7<Thresh) = -inf;
    Lev7 = plot(TotalTime7, Fidelities7);
    hold on;
    set(Lev7, 'Linestyle', '--', 'Linewidth', 1.5, 'Color', [19 14 141]/255);
    Leg{numGraphs} = '7 level';
    numGraphs = numGraphs + 1;
    if ShowWorst && G.MotionalErrorOn
        Fidelities7W(Fidelities7W<Thresh) = -inf;
        Lev7W = plot(TotalTime7, Fidelities7W);
        set(Lev7W, 'Linestyle', ':', 'Linewidth', 1.5, 'Color',[19 14 141]/255); 
        Leg{numGraphs} = '7 level Worst';
        numGraphs = numGraphs + 1;
    end
end

l3 = legend(Leg, 'Location', 'Northeast','FontSize',14);
%ax5.Title.String = 'Qudit measurement fidelity';
%ax5.Title.FontSize = 30;
ax5.FontSize = 14;
ax5.XLabel.String = 'Total measurement time (s)';
ax5.XLabel.FontSize = 20;
ax5.YLabel.String = 'Fidelity';
ax5.YLabel.FontSize = 20;
ylim([Thresh 1]);
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