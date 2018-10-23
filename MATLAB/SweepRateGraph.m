%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Tau = 1e-6;%MHz
%Rabi = 35e3;%35 kHz Rabi Frequency
Rabi = 35e-3;%MHz
%Detuning = 0.5e6;%.5 MHz Detuning
Detuning = .200;%MHz
F = 1;

%Sweepr = 1e-3:1e-7:1e3;
%Sweepr = log10(Sweepr);
Sweep = logspace(-3, 3, 1000);

ODetuning = 100 - Detuning;

Probs = Prob3(Tau, Rabi, Sweep, Detuning, F, ODetuning);
figure(1);
semilogx(Sweep, Probs);
ax = gca;
ax.Title.String = 'Optimal Sweep Rate';
ax.Title.FontSize = 25;
ax.XLabel.String = 'Sweep Rate \alpha (MHz/ms)';
ax.XLabel.FontSize = 20;
ax.YLabel.String = 'Fidelity';
ax.YLabel.FontSize = 20;
ProbsIdeal = max(Probs);
SweepIdeal = Sweep(find(Probs == ProbsIdeal));