%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Tau = 5e-6;%MHz
%Rabi = 35e3;%35 kHz Rabi Frequency
%Rabi = 35e-3;%MHz
%Detuning = 0.5e6;%.5 MHz Detuning
Detuning = 1.894;%MHz
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
ax2.XLabel.String = 'Gate Time (ms)';
ax2.XLabel.FontSize = 20;
ax2.YLabel.String = 'Rabi Frequency (kHz)';
ax2.YLabel.FontSize = 20;
% ax.XAxis.TickLabelFormat = '%.1f';
% ax.XTickLabel = '%.1f';
% xtickformat('%.1f');
%ax2.XTickLabel = [0.1 1 10 100];
%set(gca,'layer','top');
%Visible tick lines
ax2.Layer = 'top';
%Add colorbar
cb2 = colorbar;
hold on;
p = semilogx(GateTime(index), Rabi.'*1e3);
set(p, 'Color', 'Black');

[ProbIdeal, index] = max(Probs);
%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiGateTimeIdeal = [Rabi.'*1e3 GateTime(index) ProbIdeal.'];

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
ax3.XLabel.String = 'Gate Time (ms)';
ax3.XLabel.FontSize = 20;
ax3.YLabel.String = 'Fidelity';
ax3.YLabel.FontSize = 20;