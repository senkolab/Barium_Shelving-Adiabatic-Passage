%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Tau = 110e-6;%MHz
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
figure(1);
colormap(hot(4096));
h = pcolor(Sweep, Rabi*1e3, Probs.');
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
ax.Layer = 'top';
cb = colorbar;

[ProbIdeal, index] = max(Probs);
%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;
RabiSweepIdeal = [Rabi.'*1e3 Sweep(index) ProbIdeal.'];
%format longG