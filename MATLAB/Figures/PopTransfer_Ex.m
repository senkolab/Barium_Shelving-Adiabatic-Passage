clearvars
addpath('..\Functions', '..\plotxx', '..\Figures', '..\DrosteEffect-BrewerMap-b6a6efc', '..\altmany-export_fig-9502702', '..\masumhabib-PlotPub-fe51157\lib','..\masumhabib-PlotPub-fe51157\examples' );
%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Detuning = .1;
F = 1;
%Sweep = 1.3655;%MHz/ms 
Otherlevel = 4.9e6;
%Detuning = 0.5e6;%.5 MHz Detuning
%Need to set it up so the program searches for the ideal Detuning for each
%Rabi Frequency - Note that the best Detuning only varies by less than 1MHz
%from 1.89 MHz
Detuning = Otherlevel/2;%MHz
AdjDetuning = Otherlevel-Detuning;

Sweep = logspace(8, 11, 1000);
Sweep = Sweep.';

Rabi = 10e3:1e2:200e3;

%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(Sweep, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Sweep), 1);

DecayTime = 35;
TransferTime = 2*Detuning./Sweep;
ODetunings = [3490000 3870000];
Probs = Prob4(Linewidth, RabiMat, SweepMat, ODetunings, min(ODetunings), F);
%Calculate transfer probabilities
%Probs = Prob3(Linewidth, RabiMat, SweepMat, Detuning, F, AdjDetuning);
%Take into account metastable decay
Probs = Probs.*exp(-TransferTime/DecayTime);
ProbabilityCutoff = 0.97;
Probs(Probs<ProbabilityCutoff) = -inf;

%Old Code #1 was here

%Setup ideal plot to put over colormap
[ProbIdeal, index] = max(Probs);
%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiSweepIdeal = [Rabi.'*1e3 Sweep(index) ProbIdeal.'];
[FidelityIdeal, ind] = max(RabiSweepIdeal(:,3));
RabiIdeal = RabiSweepIdeal(ind, 1);
SweepIdeal = RabiSweepIdeal(ind, 2);
RabiSweepIdealTime = [Rabi.' TransferTime(index) ProbIdeal.'];


%Make colormap with Rabi vs Gate Time and Fidelity as color
fig = figure(5);
%Smoother colors
colormap(brewermap(4000, 'BuPu'));
%colormap(jet(4000));
h2 = pcolor(TransferTime, Rabi*1e-3, Probs.');
%No gridlines
set(h2, 'EdgeColor', 'none');
%Set background color white
set(gcf,'color','white');
%title('Optimal Sweeps', 'Fontsize', 25);
%xlabel('Sweep Rate \alpha (MHz/ms)', 'Fontsize', 20);
%ylabel('Rabi Frequency (kHz)', 'Fontsize', 20);
%set(gca, 'XScale', 'log');
ax2 = gca;
ax2.Title.String = 'Optimal sweeps';
ax2.Title.FontSize = 30;
ax2.XScale = 'log';
ax2.XLabel.String = 'Passage time (ms)';
ax2.XLabel.FontSize = 20;
ax2.YLabel.String = 'Rabi frequency (kHz)';
ax2.YLabel.FontSize = 20;
% ax.XAxis.TickLabelFormat = '%.1f';
% ax.XTickLabel = '%.1f';
% xtickformat('%.1f');
ax2.XTickLabel = [0.1 1 10];
%set(gca,'layer','top');
%Visible tick lines
ax2.Layer = 'top';
%Add colorbar
cb2 = colorbar;
hold on;
IdealGateTimes = TransferTime(index);
p = semilogx(IdealGateTimes, Rabi.'*1e-3, 'Color', [192, 192, 192]/255,'LineWidth',2);
%set(p, 'Color', [128, 128, 128]);
set(ax2, 'TickDir', 'out','YGrid', 'on', 'XGrid', 'on');
set(gcf, 'Position', [100 100 600 500]);
%saveas(gcf, 'Population_Transfer_Adiabatic.pdf');
%export_fig Population_Transfer_Adiabatic.pdf 
%export_fig('Population_Transfer_Adiabatic.pdf', '-pdf', '-opengl')


%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiGateTimeIdeal = [Rabi.'*1e-3 IdealGateTimes*1e3 ProbIdeal.' Sweep(index)];