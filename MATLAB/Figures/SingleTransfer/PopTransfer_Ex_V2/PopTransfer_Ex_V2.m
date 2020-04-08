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
setVarGlobalsPop(GeomOrientation, CarrierFreq, Detuning, Linewidth, F);
%Get the more concrete global variables
G = getGlobalsPop();

Sweep = logspace(8, 11, 1000);
Sweep = Sweep.';

Rabi = 10e3:1e1:200e3;
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
RabiSweepIdeal = [Rabi.'*1e3 Sweep(index) ProbIdeal.'];
[FidelityIdeal, ind] = max(RabiSweepIdeal(:,3));
RabiIdeal = RabiSweepIdeal(ind, 1);
%SweepIdeal = RabiSweepIdeal(ind, 2);
RabiSweepIdealTime = [Rabi.' TotalTime(index).' ProbIdeal.'];


%Make colormap with Rabi vs Gate Time and Fidelity as color
fig = figure(1);
%Smoother colors
colormap(brewermap(4000, 'BuPu'));
h2 = pcolor(TotalTime.'*1e3, Rabi*1e-3, Probs.');
%No gridlines
set(h2, 'EdgeColor', 'none');
%Set background color white
set(gcf,'color','white');
%title('Optimal Sweeps', 'Fontsize', 25);
%xlabel('Sweep Rate \alpha (MHz/ms)', 'Fontsize', 20);
%ylabel('Rabi Frequency (kHz)', 'Fontsize', 20);
%set(gca, 'XScale', 'log');
ax = gca;
ax.XScale = 'log';
ax.XLabel.String = 'Passage time (ms)';
ax.FontSize = 14;
ax.XLabel.FontSize = 20;
ax.YLabel.String = 'Rabi frequency (kHz)';
ax.YLabel.FontSize = 20;
%Change the xtick labels from exponential notation
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

%Visible tick lines
ax.Layer = 'top';
%Add colorbar
cb2 = colorbar;
hold on;
IdealGateTimes = TotalTime(index);
p = semilogx(IdealGateTimes*1e3, Rabi.'*1e-3, 'Color', [192, 192, 192]/255,'LineWidth',2);
%set(p, 'Color', [128, 128, 128]);
set(ax, 'TickDir', 'out','YGrid', 'on', 'XGrid', 'on');
set(gcf, 'Position', [100 100 600 500]);
colorTitleHandle = get(cb2,'Title');
set(colorTitleHandle ,'String','Fidelity');
%saveas(gcf, 'Population_Transfer_Adiabatic.pdf');
%export_fig Population_Transfer_Adiabatic.pdf 
if SavePDF
    export_fig(SavePDFName, '-pdf', '-opengl')
end

RabiGateTimeIdeal = [Rabi.'*1e-3 IdealGateTimes.'*1e3 ProbIdeal.' Sweep(index)];
[maxx, index2] = max(ProbIdeal);
fprintf("The best fidelity is %f%%, and occurs with a Rabi frequency of %f MHz and a sweeprate of %f MHz/ms\n", ...
    maxx*100, Rabi(index2)*1e-3, SweepIdeal(index2)*1e-9);