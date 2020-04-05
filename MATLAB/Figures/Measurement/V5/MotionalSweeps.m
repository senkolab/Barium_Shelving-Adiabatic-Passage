function [Prob] = MotionalSweeps(DetuningsMatrix, SweepRates, RabiFreqs)
%This function gives the error from coherently sweeping through weak motional
%sidebands
%Inputs: 
%DetuningsMatrix: Contains all detunings, the orders of these detunings,
%which transfers of the measurement they corresponds to, and whether they are
%driven twice
%SweepRates: Vector of all the sweeprates
%RabiFreqs: Vector of all the Rabi Frequencies
%Linewidth: linewidth of the laser
G = getGlobals();
%Pull out information from DetuningsMatrix
Detunings = str2double(DetuningsMatrix(1, :));
Orders = str2double(DetuningsMatrix(2, :));
Transfers = str2double(DetuningsMatrix(3, :));
DriveTwice = DetuningsMatrix(4, :);

%Start with fidelity 1
Prob = 1;
%Go through each detuning, calculating error
for i = 1:length(Detunings)
    prob = Prob5_v2(G.Linewidth, RabiFreqs, SweepRates, Detunings(i), G.Fidelity, Orders(i));
    Prob = Prob.*(1-prob);
    if DriveTwice(i) == "yes"
        Prob = Prob.*(1-prob);
    end
end
end