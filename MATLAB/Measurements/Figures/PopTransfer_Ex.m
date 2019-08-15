clearvars
addpath('..', '..\DrosteEffect-BrewerMap-b6a6efc', '..\altmany-export_fig-9502702' );
%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Detuning = .1;
F = 1;
%Sweep = 1.3655;%MHz/ms 
% Otherlevel = 4.9e6;
%Detuning = 0.5e6;%.5 MHz Detuning
%Need to set it up so the program searches for the ideal Detuning for each
%Rabi Frequency - Note that the best Detuning only varies by less than 1MHz
%from 1.89 MHz
% Detuning = Otherlevel/2;%MHz
% AdjDetuning = Otherlevel-Detuning;

Sweep = logspace(8, 11, 10000);
Sweep = Sweep.';

Rabi = 10e3:1e2:200e3;

%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(Sweep, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Sweep), 1);

FreqsSpread = [...
    4000.431225 4007.011692 4011.11359 4017.699447 4020.050647 4037.321568 ...
    4054.150786 4058.065298 4062.327219 4064.645765 4066.428678 4068.913075 ...
    4073.019937 4076.887145 4079.600404 4080.376742 4083.473002 4086.968001 ...
    4026.636504 4047.56493]*1e6;
% ClebschSpread = [...
%     0 0.0745 0.1581 0.0527 0.0913 0.1826 0.0913 0.0488 0.0598 0.1195 0.0488 ...
%     0.0598 0.1195 0.0598 0.0488 0.1195 0.0598 0.0488];
ClebschSpread = [...
    0 0.00745 0.01581 0.00527 0.035360338 0.070720676 0.035360338 0.010910894 0.013362742...
    0.026725484 0.010910894 0.013362742 0.026725484 0.013362742 0.010910894 0.026725484...
    0.013362742 0.010910894...
    0.035360338 0.035360338];
%3-level qudit encoded in levels
ThreeEncoded = [5 7 13];
%Other transitions that involve one of the 3 encoded levels
ThreeCare = [3 4 8 11 15 18 19 20];
ThreeCareTotal = [ThreeEncoded ThreeCare];
FreqsCare3level = zeros(length(ThreeCareTotal),1);
ClebschsCare3level = zeros(length(ThreeCareTotal),1);
%Generate all frequencies we care about
for i = 1:length(ThreeCareTotal)
    FreqsCare3level(i) = FreqsSpread(ThreeCareTotal(i));
    ClebschsCare3level(i) = ClebschSpread(ThreeCareTotal(i));
end 

DetuningOffsetstart = 200000;
Detunings = abs(FreqsCare3level(3) -FreqsCare3level);
Detunings(3) = [];
DecayTime = 35;
SmallestDetuning = min(Detunings);
%Start with detuning halfway between levels
Detuning = SmallestDetuning- DetuningOffsetstart;
TransferTime = 2*Detuning./Sweep;
ODetunings = [3490000 3870000];
% Probs = Prob5(Linewidth, RabiMat, SweepMat, ODetunings, min(ODetunings), F);
Probs = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare3level, F, 3, ClebschsCare3level);
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
% ax2.Title.String = 'Optimal sweeps';
% ax2.Title.FontSize = 30;
ax2.XScale = 'log';
ax2.XLabel.String = 'Passage time (ms)';
ax2.FontSize = 14;
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
colorTitleHandle = get(cb2,'Title');
set(colorTitleHandle ,'String','Fidelity');
%saveas(gcf, 'Population_Transfer_Adiabatic.pdf');
%export_fig Population_Transfer_Adiabatic.pdf 
%export_fig('Population_Transfer_Adiabatic5.pdf', '-pdf', '-opengl')


%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiGateTimeIdeal = [Rabi.'*1e-3 IdealGateTimes*1e3 ProbIdeal.' Sweep(index)];