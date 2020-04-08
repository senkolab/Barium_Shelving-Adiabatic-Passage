clearvars
addpath('..\..\..\Functions\Frequencies_EnergyStructure', ...
    '..\..\..\DrosteEffect-BrewerMap-b6a6efc', ...
    '..\..\..\altmany-export_fig-9502702');
%Constants of the experiment
%Constants of the experiment
%Decay time of metastable state
DecayTime = 35;

%Geometric orientation - XZ, Orthogonal, or Average
GeomOrientation = "XZ";
%Carrier frequency
CarrierFreq = -1130e6;
Detuning = 1.3e6;
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Fidelity
F = 1;
SavePDF = false;

%Set variational global variables
setVarGlobalsErrorSources(GeomOrientation, CarrierFreq, Detuning, Linewidth, F);
%Get the more concrete global variables
G = getGlobalsErrorSources();

Sweep = logspace(8, 11, 100);
Sweep = Sweep.';

Rabi = 10e3:1e2:200e3;
%Rabi = 

LevelsG = G.Levels3G;
LevelsP = G.Levels3P;
Level1 = [2 0];
Level2 = [2 0];
SavePDFName = sprintf("SingleTransfer_%s_%g_MHz_%gMHz_F=%i_mF=%i_Fp=%i_mFp=%i",...
    GeomOrientation, CarrierFreq*1e-6, Detuning*1e-6, Level1(1), Level1(2), Level2(1), Level2(2));
SavePDFName = strrep(SavePDFName, ".", "p");
[Probs, TotalTime] = TransferProbV2(G, Sweep, Rabi, 3, Level1, Level2, LevelsG, LevelsP);
ProbabilityCutoff = G.Thresh;
Probs(Probs<ProbabilityCutoff) = -inf;

%Setup ideal plot to put over colormap
[ProbIdeal, index] = max(Probs);
%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
SweepIdeal = Sweep(index, :);
IdealGateTimes = TotalTime(index);
RabiSweepIdealTime = [Rabi.' TotalTime(index).' ProbIdeal.'];
RabiGateTimeIdeal = [Rabi.'*1e-3 IdealGateTimes.'*1e3 ProbIdeal.' Sweep(index)];
[Probb, index2] = max(ProbIdeal);
Rabii = Rabi(index2);
Sweepp = SweepIdeal(index2);
fprintf("The best fidelity is %f%%, and occurs with a Rabi frequency of %f MHz and a sweeprate of %f MHz/ms\n\n", ...
    Probb*100, Rabii*1e-3, Sweepp*1e-9);

Errors = ["Prep", "OffRes", "Adiabadicity", "Dephasing", "Decay"];
ThreeTotal = 1;
FiveTotal = 1;
SevenTotal = 1;
for i = 1:length(Errors)
    Error = Errors(i);
    G = ChangeErrors(G, Error);
    Probb = TransferProbV2(G, Sweepp, Rabii, 3, Level1, Level2, LevelsG, LevelsP, true);
    ErrorVal = 1-Probb;
    %fprintf("Single Transfer %s error: %d\n", Error, 1-Probb);
    if i == 1
        fprintf("3-level        5-level        7-level\n")
    end
    Three = Probb^3;
    Threee = 1 - Three;
    ThreeTotal = ThreeTotal*Three;
    Five = Probb^7;
    Fivee = 1 - Five;
    FiveTotal = FiveTotal*Five;
    Seven = Probb^11;
    Sevenn = 1 - Seven;
    SevenTotal = SevenTotal*Seven;
    fprintf("%d   %d   %d   %s\n", Threee, Fivee, Sevenn, Error);
    if Error == "Decay"
        fprintf("%f%%     %f%%     %f%%     Total Fidelity\n", ThreeTotal*100, FiveTotal*100, SevenTotal*100, Error);
    end
end