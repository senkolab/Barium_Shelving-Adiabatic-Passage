%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Tau = 5e-6;%MHz
%Rabi = 35e3;%35 kHz Rabi Frequency
%Rabi = 35e-3;%MHz
%Detuning = 0.5e6;%.5 MHz Detuning
%Need to set it up so the program searches for the ideal Detuning for each
%Rabi Frequency - Note that the best Detuning only varies by less than 1MHz
%from 1.89 MHz
Detuning = 1.89;%MHz
%Detuning = .1;
F = 1;
%Sweep = 1.3655;%MHz/ms 
Otherlevel = 4.9;
OtherDetuning = Otherlevel-Detuning;

% Sweep1 = 1e-3:1e-7:1e-2;
% Sweep2 = 1e-2:1e-6:1e-1;
% Sweep3 = 1e-1:1e-5:1;
% Sweep4 = 1:1e-4:1e2;
% Sweep5 = 1e2:1e-3:1e3;
% Sweep = 1e-1:1e-2:1e2;
Sweep = logspace(-1, 2, 1000);
Sweep = Sweep.';


Rabi = 10e-3:1e-4:200e-3;

SweepMat = repmat(Sweep, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Sweep), 1);


Probs = Prob3(Tau, RabiMat, SweepMat, Detuning, F, OtherDetuning);
Probs(Probs<.9) = -inf;

%Make colormap with Rabi vs Sweeprate and Fidelity as color
figure(1);
%Smoother colors
colormap(hot(4096));
h = pcolor(Sweep, Rabi*1e3, Probs.');
%No gridlines
set(h, 'EdgeColor', 'none');
%title('Optimal Sweeps', 'Fontsize', 25);
%xlabel('Sweep Rate \alpha (MHz/ms)', 'Fontsize', 20);
%ylabel('Rabi Frequency (kHz)', 'Fontsize', 20);
%set(gca, 'XScale', 'log');
ax = gca;
ax.Title.String = 'Optimal Sweeps';
ax.Title.FontSize = 25;
ax.XScale = 'log';
ax.XLabel.String = 'Sweep Rate \alpha (MHz/ms)';
ax.XLabel.FontSize = 20;
ax.YLabel.String = 'Rabi Frequency (kHz)';
ax.YLabel.FontSize = 20;
% ax.XAxis.TickLabelFormat = '%.1f';
% ax.XTickLabel = '%.1f';
% xtickformat('%.1f');
ax.XTickLabel = [0.1 1 10 100];
%set(gca,'layer','top');
%Visible tick lines
ax.Layer = 'top';
%Add colorbar
cb = colorbar;

[ProbIdeal, index] = max(Probs);
%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiSweepIdeal = [Rabi.'*1e3 Sweep(index) ProbIdeal.'];
[FidelityIdeal, ind] = max(RabiSweepIdeal(:,3));
RabiIdeal = RabiSweepIdeal(ind, 1);
SweepIdeal = RabiSweepIdeal(ind, 2);

GateTime = 2*Detuning./Sweep;
%Make colormap with Rabi vs Gate Time and Fidelity as color
figure(2);
%Smoother colors
colormap(hot(4096));
h2 = pcolor(GateTime, Rabi*1e3, Probs.');
%No gridlines
set(h2, 'EdgeColor', 'none');
%title('Optimal Sweeps', 'Fontsize', 25);
%xlabel('Sweep Rate \alpha (MHz/ms)', 'Fontsize', 20);
%ylabel('Rabi Frequency (kHz)', 'Fontsize', 20);
%set(gca, 'XScale', 'log');
ax2 = gca;
ax2.Title.String = 'Optimal Sweeps';
ax2.Title.FontSize = 25;
ax2.XScale = 'log';
ax2.XLabel.String = 'Passage Time (ms)';
ax2.XLabel.FontSize = 20;
ax2.YLabel.String = 'Rabi Frequency (kHz)';
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
IdealGateTimes = GateTime(index);
p = semilogx(IdealGateTimes, Rabi.'*1e3);
set(p, 'Color', 'Black');

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

figure(3)
Leg = {};
k = 1;
for i = 1:length(Rabi)
    RabiK = Rabi(i)*1e3;
    if mod(RabiK, 20) == 0
        p2 = semilogx(GateTime, Probs(:, i));
        ax3 = gca;
        hold on;
        Leg{k} = [num2str(RabiK) ' kHz'];
        k = k + 1;
    end
end
l = legend(Leg, 'Location', 'Southeast');
ax3.Title.String = 'Rabi Frequency Fidelities';
ax3.Title.FontSize = 25;
ax3.XLabel.String = 'Passage Time (ms)';
ax3.XLabel.FontSize = 20;
ax3.YLabel.String = 'Fidelity';
ax3.YLabel.FontSize = 20;
ax3.XTickLabel = [0.01 0.1 1 10 100];

figure(4)
Fidelities = RabiGateTimeIdeal(:,3);
Rabis = RabiGateTimeIdeal(:,1);
Num3 = NumPasses(3);
Num5 = NumPasses(5);
Num7 = NumPasses(7);
Num8 = NumPasses(8);

plot(Rabis, Fidelities.^Num3);
hold on;
plot(Rabis, Fidelities.^Num5);
hold on;
plot(Rabis, Fidelities.^Num7);
hold on;
plot(Rabis, Fidelities.^Num8);
hold on;
ax4 = gca;
Leg = {};
Leg{1} = '3 level';
Leg{2} = '5 level';
Leg{3} = '7 level';
Leg{4} = '8 level';
l2 = legend(Leg, 'Location', 'Southwest');
ax4.Title.String = 'Different qudits';
ax4.Title.FontSize = 25;
ax4.XLabel.String = 'Rabi Frequency (kHz)';
ax4.XLabel.FontSize = 20;
ax4.YLabel.String = 'Fidelity';
ax4.YLabel.FontSize = 20;
%ax4.XTickLabel = [0.01 0.1 1 10 100];

figure(5)
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
% Fidelities(Fidelities<.95) = -inf;
% plot(GateTimes, Fidelities);
% hold on;
%Num3 = NumPasses(3);
%Num5 = NumPasses(5);
%Num7 = NumPasses(7);
%Num8 = NumPasses(8);
Num3 = 4;
Num5 = 8;
Num7 = 12;

Fluorescence3 = 2;
Fluorescence5 = 4;
Fluorescence7 = 6;
NA = 0.5;
Angle = asin(NA);
PercentCollected = sin(Angle/2)^2;
QE = 0.8;
FluorescenceRabi = 20e6;
DetectionRate = FluorescenceRabi*PercentCollected*QE;
PhotonsToCollect = 10;
FluorescenceTime = PhotonsToCollect/DetectionRate;
TotalfTime3 = FluorescenceTime*Fluorescence3;
TotalfTime5 = FluorescenceTime*Fluorescence5;
TotalfTime7 = FluorescenceTime*Fluorescence7;

Fidelities3 = Fidelities.^Num3;
Fidelities3(Fidelities3<.95) = -inf;
plot(GateTimes.*Num3 + TotalfTime3, Fidelities3);
hold on;
Fidelities5 = Fidelities.^Num5;
Fidelities5(Fidelities5<.95) = -inf;
plot(GateTimes.*Num5 + TotalfTime5, Fidelities5);
hold on;
Fidelities7 = Fidelities.^Num7;
Fidelities7(Fidelities7<.95) = -inf;
plot(GateTimes.*Num7 + TotalfTime7, Fidelities7);
hold on;
%Fidelities8 = Fidelities.^Num8;
%Fidelities8(Fidelities8<.95) = -inf;
%plot(GateTimes.*Num8, Fidelities8);
%hold on;

ax5 = gca;
Leg = {};
%Leg{1} = '1 level';
Leg{1} = '3 level';
Leg{2} = '5 level';
Leg{3} = '7 level';
%Leg{4} = '8 level';
l3 = legend(Leg, 'Location', 'Southwest');
ax5.Title.String = 'Different qudits';
ax5.Title.FontSize = 25;
ax5.XLabel.String = 'Measurement Time (ms)';
ax5.XLabel.FontSize = 20;
ax5.YLabel.String = 'Fidelity';
ax5.YLabel.FontSize = 20;
%ax5.XTickLabel = [0.1 0.1 1 10];