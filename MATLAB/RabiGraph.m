clearvars
%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
%Detuning = 0.5e6;%.5 MHz Detuning
%Need to set it up so the program searches for the ideal Detuning for each
%Rabi Frequency - Note that the best Detuning only varies by less than 1MHz
%from 1.89 MHz
Detuning = 1.9e6;%MHz
%Detuning = .1;
F = 1;
%Sweep = 1.3655;%MHz/ms 
Otherlevel = 4.9e6;
AdjDetuning = Otherlevel-Detuning;

Sweep = logspace(8, 11, 1000);
Sweep = Sweep.';

Rabi = 10e3:1e2:200e3;

%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(Sweep, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Sweep), 1);

DecayTime = 35;
TransferTime = 2*Detuning./Sweep;
%Calculate transfer probabilities
Probs = Prob3(Linewidth, RabiMat, SweepMat, Detuning, F, AdjDetuning);
%Take into account metastable decay
Probs = Probs.*exp(-TransferTime/DecayTime);
ProbabilityCutoff = 0.97;
Probs(Probs<ProbabilityCutoff) = -inf;

% %Make colormap with Rabi vs Sweeprate and Fidelity as color
% figure(1);
% %Smoother colors
% colormap(hot(4096));
% h = pcolor(Sweep, Rabi*1e3, Probs.');
% %No gridlines
% set(h, 'EdgeColor', 'none');
% %title('Optimal Sweeps', 'Fontsize', 25);
% %xlabel('Sweep Rate \alpha (MHz/ms)', 'Fontsize', 20);
% %ylabel('Rabi Frequency (kHz)', 'Fontsize', 20);
% %set(gca, 'XScale', 'log');
% ax = gca;
% ax.Title.String = 'Optimal Sweeps';
% ax.Title.FontSize = 25;
% ax.XScale = 'log';
% ax.XLabel.String = 'Sweep Rate \alpha (MHz/ms)';
% ax.XLabel.FontSize = 20;
% ax.YLabel.String = 'Rabi Frequency (kHz)';
% ax.YLabel.FontSize = 20;
% % ax.XAxis.TickLabelFormat = '%.1f';
% % ax.XTickLabel = '%.1f';
% % xtickformat('%.1f');
% ax.XTickLabel = [0.1 1 10 100];
% %set(gca,'layer','top');
% %Visible tick lines
% ax.Layer = 'top';
% %Add colorbar
% cb = colorbar;


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
figure(2);
%Smoother colors
colormap(brewermap(4000, 'BuPu'));
%colormap(jet(4000));
h2 = pcolor(TransferTime, Rabi, Probs.');
%No gridlines
set(h2, 'EdgeColor', 'none');
%Set background color white
set(gcf,'color','white');
%title('Optimal Sweeps', 'Fontsize', 25);
%xlabel('Sweep Rate \alpha (MHz/ms)', 'Fontsize', 20);
%ylabel('Rabi Frequency (kHz)', 'Fontsize', 20);
%set(gca, 'XScale', 'log');
ax2 = gca;
ax2.Title.String = 'Optimal Sweeps';
ax2.Title.FontSize = 20;
ax2.XScale = 'log';
ax2.XLabel.String = 'Passage Time (ms)';
ax2.XLabel.FontSize = 12;
ax2.YLabel.String = 'Rabi Frequency (kHz)';
ax2.YLabel.FontSize = 12;
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
p = semilogx(IdealGateTimes, Rabi.', 'Color', [192, 192, 192]/255);
%set(p, 'Color', [128, 128, 128]);
set(ax2, 'TickDir', 'out','YGrid', 'on', 'XGrid', 'on');

%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiGateTimeIdeal = [Rabi.'*1e3 IdealGateTimes ProbIdeal.' Sweep(index)];

% figure(3)
% semilogx(GateTime(index), Rabi.'*1e3);
% ax3 = gca;
% ax3.Title.String = 'Optimal Gate Times';
% ax3.Title.FontSize = 25;
% ax3.XLabel.String = 'Gate Time (ms)';
% ax3.XLabel.FontSize = 20;
% ax3.YLabel.String = 'Rabi Frequency (kHz)';
% ax3.YLabel.FontSize = 20;

% figure(3)
% Leg = {};
% k = 1;
% for i = 1:length(Rabi)
%     RabiK = Rabi(i)*1e3;
%     if mod(RabiK, 20) == 0
%         p2 = semilogx(GateTime, Probs(:, i));
%         ax3 = gca;
%         hold on;
%         Leg{k} = [num2str(RabiK) ' kHz'];
%         k = k + 1;
%     end
% end
% l = legend(Leg, 'Location', 'Southeast');
% ax3.Title.String = 'Rabi Frequency Fidelities';
% ax3.Title.FontSize = 25;
% ax3.XLabel.String = 'Passage Time (ms)';
% ax3.XLabel.FontSize = 20;
% ax3.YLabel.String = 'Fidelity';
% ax3.YLabel.FontSize = 20;
% ax3.XTickLabel = [0.01 0.1 1 10 100];

% figure(4)
% Fidelities = RabiGateTimeIdeal(:,3);
% Rabis = RabiGateTimeIdeal(:,1);
% Num3 = NumPasses(3);
% Num5 = NumPasses(5);
% Num7 = NumPasses(7);
% Num8 = NumPasses(8);
% 
% plot(Rabis, Fidelities.^Num3);
% hold on;
% plot(Rabis, Fidelities.^Num5);
% hold on;
% plot(Rabis, Fidelities.^Num7);
% hold on;
% plot(Rabis, Fidelities.^Num8);
% hold on;
% ax4 = gca;
% Leg = {};
% Leg{1} = '3 level';
% Leg{2} = '5 level';
% Leg{3} = '7 level';
% Leg{4} = '8 level';
% l2 = legend(Leg, 'Location', 'Southwest');
% ax4.Title.String = 'Different qudits';
% ax4.Title.FontSize = 25;
% ax4.XLabel.String = 'Rabi Frequency (kHz)';
% ax4.XLabel.FontSize = 20;
% ax4.YLabel.String = 'Fidelity';
% ax4.YLabel.FontSize = 20;
%ax4.XTickLabel = [0.01 0.1 1 10 100];

fig = figure(5);
set(fig,'defaultAxesColorOrder',[[26 146 186]/255; [50 181 107]/255]);
% Fidelities = RabiGateTimeIdeal(:,3);
% GateTimes = RabiGateTimeIdeal(:,4);
% Fidelities(Fidelities<.94) = -inf;
% semilogx(GateTimes, Fidelities);
% hold on;
% Fidelities3 = Fidelities.^3;
% Fidelities3(Fidelities3<.95) = -inf;
% semilogx(GateTimes.*3, Fidelities3);
% hold on;
% Fidelities5 = Fidelities.^5;
% Fidelities5(Fidelities5<.95) = -inf;
% semilogx(GateTimes.*5, Fidelities5);
% hold on;
% Fidelities7 = Fidelities.^7;
% Fidelities7(Fidelities7<.95) = -inf;
% semilogx(GateTimes.*7, Fidelities7);
% hold on;
% Fidelities8 = Fidelities.^8;
% Fidelities8(Fidelities8<.95) = -inf;
% semilogx(GateTimes.*8, Fidelities8);
% hold on;

Fidelities = RabiGateTimeIdeal(:,3);
GateTimes = RabiGateTimeIdeal(:,4);
Rabis = RabiGateTimeIdeal(:,1);
% Fidelities(Fidelities<.95) = -inf;
% plot(GateTimes, Fidelities);
% hold on;
%Num3 = NumPasses(3);
%Num5 = NumPasses(5);
%Num7 = NumPasses(7);
%Num8 = NumPasses(8);\
%Average number of passages
Num3 = 3;
Num5 = 5.5;
Num7 = 8.5;
%Average number of fluorescences
Fluorescence3 = 1.5;
Fluorescence5 = 2.5;
Fluorescence7 = 3.5;
NA = 0.5;
Angle = asin(NA);
PercentCollected = sin(Angle/2)^2;
QE = 0.8;
P12Lifetime = 7.92e-9;
SaturationFluorescenceFreq = 1/(2*2*pi()*P12Lifetime);
AssumedFluorescenceFreq = SaturationFluorescenceFreq/2;
DetectionRate = AssumedFluorescenceFreq*PercentCollected*QE;
PhotonsToCollect = 10;
FluorescenceTime = PhotonsToCollect/DetectionRate;
%Calculate overall fluorescence time
TotalfTime3 = FluorescenceTime*Fluorescence3;
TotalfTime5 = FluorescenceTime*Fluorescence5;
TotalfTime7 = FluorescenceTime*Fluorescence7;
%Calculate total time for the whole measurement
TotalTime3 = GateTimes.*Num3 + TotalfTime3;
TotalTime5 = GateTimes.*Num5 + TotalfTime5;
TotalTime7 = GateTimes.*Num7 + TotalfTime7;

%Threshold to display
Thresh = 0.97;
%yyaxis left;
Fidelities3 = Fidelities.^Num3;
Fidelities3(Fidelities3<Thresh) = -inf;
Lev3 = semilogx(TotalTime3, Fidelities3);
hold on;
set(Lev3, 'Linewidth', 1.5, 'Color', [128 0 132]/255);

Fidelities5 = Fidelities.^Num5;
Fidelities5(Fidelities5<Thresh) = -inf;
Lev5 = plot(TotalTime5, Fidelities5);
hold on;
set(Lev5, 'Linestyle', '-.', 'Linewidth', 1.5, 'Color', [0 133 93]/255);

Fidelities7 = Fidelities.^Num7;
Fidelities7(Fidelities7<Thresh) = -inf;
Lev7 = plot(TotalTime7, Fidelities7);
hold on;
set(Lev7, 'Linestyle', '--', 'Linewidth', 1.5, 'Color', [19 14 141]/255);

%Fidelities8 = Fidelities.^Num8;
%Fidelities8(Fidelities8<.95) = -inf;
%plot(GateTimes.*Num8, Fidelities8);
%hold on;
%Set background color white
set(gcf,'color','white');
%set(LevRight, 'line
ax5 = gca;
Leg = {};
%Leg{1} = '1 level';
Leg{1} = '3 level';
Leg{2} = '5 level';
Leg{3} = '7 level';
%Leg{4} = '8 level';
l3 = legend(Leg, 'Location', 'Northeast');
ax5.Title.String = 'Qudit measurement fidelity';
ax5.Title.FontSize = 20;
ax5.XLabel.String = 'Measurement Time (ms)';
ax5.XLabel.FontSize = 12;
ax5.YLabel.String = 'Fidelity';
ax5.YLabel.FontSize = 12;
ylim([.975 1]);
set(ax5, 'YTick', 0:0.005:1,...
    'YMinorTick', 'on', 'TickDir', 'out',...
    'YGrid', 'on', 'XGrid', 'on',...
    'XTickLabel', [0.1 1 10 100 1000])
% yyaxis right;
% Size = size(Fidelities7(Fidelities7 ~= -Inf)');
% TotalTime7Small = TotalTime7(1:Size(2), :);
% RabisSmall = Rabis(1:Size(2), :);
% LevRight = plot(TotalTime7Small, RabisSmall);
% set(LevRight, 'Color', 'none', 'HandleVisibility', 'off');
% ylabel('Rabi Frequency');
%ax6 = axes('Position',ax5.Position,...
%             'XAxisLocation','top',...
%             'YAxisLocation','right',...
%             'Color','none',...
%             'XColor','k','YColor','k',...
%             'XScale', 'log', 'XDir', 'reverse');
%LevTop = semilogx(Rabis, Fidelities7);
%line(Rabis,Fidelities7,'Parent',ax6,'Color','k');
%linkaxes([ax5 ax6],'xy');
%ylim([0.975, 1]);