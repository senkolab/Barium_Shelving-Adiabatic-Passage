%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Tau = 5e-6;%MHz
%Rabi = 35e3;%35 kHz Rabi Frequency
Rabi = 50e-3;%MHz
%Detuning = 0.5e6;%.5 MHz Detuning
%Detuning = 0.5;%MHz
F = 1;
Otherlevel = 4.9;

Detuning = 1e-1:1e-3:4.8e0;%MHz
OptSweep = zeros(length(Detuning), 0);
Sweep1 = 1e-3:1e-6:1e-2;
Sweep2 = 1e-2:1e-5:1e-1;
Sweep3 = 1e-1:1e-4:1;
Sweep4 = 1:1e-3:1e2;
Sweep5 = 1e2:1e-2:1e3;
Sweep = [Sweep1 Sweep2 Sweep3 Sweep4 Sweep5];
for i = 1:length(Detuning)
    OtherDetuning = Otherlevel - Detuning(i);
    Probs = Prob2(Tau, Rabi, Sweep, Detuning(i), F, OtherDetuning);
    OptSweep(i) = Sweep(find(Probs == max(Probs)));
end
Sweep = OptSweep(1);

OtherDetuning = Otherlevel-Detuning;
Probs = Prob2(Tau, Rabi, Sweep, Detuning, F, OtherDetuning);
OptProb = max(Probs);
OptDetuning = Detuning(find(Probs == OptProb));
figure(1);
plot(Detuning, Probs);
ax = gca;
ax.Title.String = 'Optimal Detuning';
ax.Title.FontSize = 25;
ax.XLabel.String = 'Detuning (MHz)';
ax.XLabel.FontSize = 20;
ax.YLabel.String = 'Fidelity';
ax.YLabel.FontSize = 20;