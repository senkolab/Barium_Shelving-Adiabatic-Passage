clearvars
addpath('..\Functions', '..\plotxx', '..\Figures', '..\DrosteEffect-BrewerMap-b6a6efc', '..\altmany-export_fig-9502702');
%Constants of the experiment
%Tau = 5;%5 Hz Linewidth
Linewidth = 1;
F = 1;
%Sweep = 1.3655;%MHz/ms 

%List all energy levels: transition, adjacent transition, other adjacent
%transition. If no adjacent transition:0
% FreqsSpread3level = [...
%     4020.05 0 4037.32;...%1,-1
%     4073.02 4068.91 4076.89;...%2,0
%     4054.15 4037.32 4064.65]*1e6;%1,1

%Actually, we don't care about adjacent transitions, we care about driving
%from m_F to m_F' !=m_F. Using Polarization, we can ignore +-1 transitions,
%so just +-2 transitions matter. b's we don't want, but they don't include
%an encoded state, blanks we don't want and include an encoded state, w's
%are transitions we want to make. Picked detuning frequency of -1092 MHz
TransSpread3level = [...
    "2:0" "2:+2.0" "b2:-1" "b2:+1.-1" "w1:-1" "1:0" "w1:+1" "b2:0.+2" ...
    "b2:-1+1" "2:+2" "b2:-2.0" "2:+1" "w2:0" "2:-1" "b2:+2.0" "2:-2" "b2:1.-1" "b2:0.-2"];
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
    0.013362742 0.010910894 ...
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
% [TransSpread3level; FreqsSpread; ClebschSpread]
% FreqsSpread3level = [...
%     4020.05 0 4037.32;...%1,-1
%     4073.02 4068.91 4076.89;...%2,0
%     4054.15 4037.32 4064.65]*1e6;%1,1
%Make array of the freq. differences between each adjacent level and the
%level we care about
% Detunings3Level = [abs(FreqsSpread3level(:,1)-FreqsSpread3level(:,2)) abs(FreqsSpread3level(:,1)-FreqsSpread3level(:,3))];
% %Sort it so the levels with closest adjacent levels are first in line
% Detunings3Level = sort(sort(Detunings3Level,2),1);
% SmallestDetuning3 = min(Detunings3Level(:,:).');
TransSpread5level = [...
    "b2:0" "b2:+2.0" "b2:-1" "b2:+1.-1" "w1:-1" "1:0" "w1:+1" "b2:0.+2" ...
    "b2:-1+1" "w2:+2" "b2:-2.0" "2:+1" "w2:0" "2:-1" "b2:+2.0" "w2:-2" "b2:1.-1" "b2:0.-2"];
%5-level qudit encoded in levels
FiveEncoded = [5 7 10 13 16];
%Other transitions that involve one of the 5 encoded levels
FiveCare = [2 3 4 8 11 15 18 19 20];
FiveCareTotal = [FiveEncoded FiveCare];
FreqsCare5level = zeros(length(FiveCareTotal),1);
ClebschsCare5level = zeros(length(FiveCareTotal),1);
%Generate all frequencies we care about
for i = 1:length(FiveCareTotal)
    FreqsCare5level(i) = FreqsSpread(FiveCareTotal(i));
    ClebschsCare5level(i) = ClebschSpread(FiveCareTotal(i));
end 
% [TransSpread5level; FreqsSpread; ClebschSpread]
% FreqsSpread5level = [...
%     4080.38 4076.89 0; ...%2,-2
%     4020.05 0 4037.32; ...%1,-1
%     4073.02 4068.91 4076.89; ...%2,0
%     4054.15 4037.32 4064.65; ...%1,1
%     4064.65 4054.15 4068.91]*1e6;%2,2
% Detunings5Level = [abs(FreqsSpread5level(:,1)-FreqsSpread5level(:,2)) abs(FreqsSpread5level(:,1)-FreqsSpread5level(:,3))];
% Detunings5Level = sort(sort(Detunings5Level,2),1);
% SmallestDetuning5 = min(Detunings5Level(:,:).');
TransSpread7level = [...
    "b2:0" "b2:+2.0" "b2:-1" "b2:+1.-1" "w1:-1" "w1:0" "w1:+1" "b2:0.+2" ...
    "b2:-1+1" "w2:+2" "b2:-2.0" "w2:+1" "w2:0" "w2:-1" "b2:+2.0" "2:-2" "b2:1.-1" "b2:0.-2"];
%7-level qudit encoded in levels
SevenEncoded = [5 6 7 10 12 13 14];
%Other transitions that involve one of the 7 encoded levels
SevenCare = [2 3 4 8 9 11 15 17 18 19 20];
SevenCareTotal = [SevenEncoded SevenCare];
FreqsCare7level = zeros(length(SevenCareTotal),1);
ClebschsCare7level = zeros(length(SevenCareTotal),1);
%Generate all frequencies we care about
for i = 1:length(SevenCareTotal)
    FreqsCare7level(i) = FreqsSpread(SevenCareTotal(i));
    ClebschsCare7level(i) = ClebschSpread(SevenCareTotal(i));
end 
% [TransSpread7level; FreqsSpread; ClebschSpread]
% FreqsSpread7level = [...
%     4080.38 4076.89 0; ...%2,-2
%     4020.05 0 4037.32; ...%1,-1
%     4076.89 4073.02 4080.38; ...%2,-1
%     4037.32 4020.05 4054.15; ...%1,0
%     4073.02 4068.91 4076.89; ...%2,0
%     4054.15 4037.32 0; ...%1,1
%     4068.91 4064.65 4073.02]*1e6;%2,1
% Detunings7Level = [abs(FreqsSpread7level(:,1)-FreqsSpread7level(:,2)) abs(FreqsSpread7level(:,1)-FreqsSpread7level(:,3))];
% Detunings7Level = sort(sort(Detunings7Level,2),1);
% SmallestDetuning7 = min(Detunings7Level(:,:).');


%Setup sweep rate array
Sweep = logspace(8, 11, 1000);
Sweep = Sweep.';

%Setup Rabi Freqs
Rabi = 10e3:1e2:330e3;

%Make a bunch of copies of the sweep rates and rabi freqs
SweepMat = repmat(Sweep, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Sweep), 1);

%Decay time of metastable state
DecayTime = 35;

%ProbIdeal3Level is for tallying up the overall prob
ProbIdeal3Level = ones(size(Rabi));
%TotalTransferTime3 is for tallying up the overall transfer time
TotalTransferTime3 = zeros(size(Rabi));
%IdealSweeps is for storing the info on what the best sweep rate was for
%each separate transfer
%IdealSweeps3 = zeros(length(Detunings3Level(:,1)), length(Rabi));
% SweepRateOpt3 = zeros(length(Detunings3Level(:,1) - 1),length(Rabi));
%Go through each passage
for i = 2:3
    %Get the prob of the this transfer
    prob3level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare3level, F, i, ClebschsCare3level);
    %Get the sweep rate with the best fidelity for each Rabi freq
    [ProbIdeal, index] = max(prob3level);
    Detunings = abs(FreqsCare3level(i) -FreqsCare3level);
    Detunings(i) = [];
    SmallestDetuning = min(Detunings);
    %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
    TransferTime = 2*SmallestDetuning./Sweep(index);
    TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTransferTime3 = TotalTransferTime3 + TransferTime;
    %Add in decay error
    ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
    %Mult this transfer prob to the tally prob
    ProbIdeal3Level = ProbIdeal.*ProbIdeal3Level;
    %Add sweep data from this transfer to sweep data array
    %IdealSweeps3(i, :) = Sweep(index);
end
for i = 2:2
    %Get the prob of the this transfer
    prob3level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare3level, F, i, ClebschsCare3level);
    %Get the sweep rate with the best fidelity for each Rabi freq
    [ProbIdeal, index] = max(prob3level);
    Detunings = abs(FreqsCare3level(i) -FreqsCare3level);
    Detunings(i) = [];
    SmallestDetuning = min(Detunings);
    %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
    TransferTime = 2*SmallestDetuning./Sweep(index);
    TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTransferTime3 = TotalTransferTime3 + TransferTime;
    %Add in decay error
    ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
    %Mult this transfer prob to the tally prob
    ProbIdeal3Level = ProbIdeal.*ProbIdeal3Level;
    %Add sweep data from this transfer to sweep data array
    %IdealSweeps3(i, :) = Sweep(index);
end
% for i = 2:length(Detunings3Level(:,1))
%     %Get the prob of the this transfer
%     prob3level = Prob4(Linewidth, RabiMat, SweepMat, Detunings3Level(i,:), SmallestDetuning3(i), F);
%     %Get the sweep rate with the best fidelity for each Rabi freq
%     [ProbIdeal, index] = max(prob3level);
%     %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
%     TransferTime = 2*SmallestDetuning3(i)./Sweep(index);
%     TransferTime = TransferTime.';
%     %Add to transfer tally
%     TotalTransferTime3 = TotalTransferTime3 + TransferTime;
%     %Add in decay error
%     ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
%     %Mult this transfer prob to the tally prob
%     ProbIdeal3Level = ProbIdeal.*ProbIdeal3Level;
%     %Add sweep data from this transfer to sweep data array
%     IdealSweeps3(i, :) = Sweep(index);
% end
% for i = 2:length(Detunings3Level(:,1))-1
%     %Get the prob of the this transfer
%     prob3level = Prob4(Linewidth, RabiMat, SweepMat, Detunings3Level(i,:), SmallestDetuning3(i), F);
%     %Get the sweep rate with the best fidelity for each Rabi freq
%     [ProbIdeal, index] = max(prob3level);
%     %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
%     TransferTime = 2*SmallestDetuning3(i)./Sweep(index);
%     TransferTime = TransferTime.';
%     %Add to transfer tally
%     TotalTransferTime3 = TotalTransferTime3 + TransferTime;
%     %Add in decay error
%     ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
%     %Mult this transfer prob to the tally prob
%     ProbIdeal3Level = ProbIdeal.*ProbIdeal3Level;
%     %Add sweep data from this transfer to sweep data array
%     IdealSweeps3(i, :) = Sweep(index);
% end

ProbIdeal5Level = ones(size(Rabi));
TotalTransferTime5 = zeros(size(Rabi));
%IdealSweeps5 = zeros(length(Detunings5Level(:,1)), length(Rabi));
% SweepRateOpt3 = zeros(length(Detunings3Level(:,1) - 1),length(Rabi));
%Go through each passage
for i = 1:4
    %Get the prob of the this transfer
    prob5level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare5level, F, i, ClebschsCare5level);
    %Get the sweep rate with the best fidelity for each Rabi freq
    [ProbIdeal, index] = max(prob5level);
    Detunings = abs(FreqsCare5level(i) -FreqsCare5level);
    Detunings(i) = [];
    SmallestDetuning = min(Detunings);
    %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
    TransferTime = 2*SmallestDetuning./Sweep(index);
    TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTransferTime5 = TotalTransferTime5 + TransferTime;
    %Add in decay error
    ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
    %Mult this transfer prob to the tally prob
    ProbIdeal5Level = ProbIdeal.*ProbIdeal5Level;
    %Add sweep data from this transfer to sweep data array
    %IdealSweeps5(i, :) = Sweep(index);
end
for i = 1:3
    %Get the prob of the this transfer
    prob5level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare5level, F, i, ClebschsCare5level);
    %Get the sweep rate with the best fidelity for each Rabi freq
    [ProbIdeal, index] = max(prob5level);
    Detunings = abs(FreqsCare5level(i) -FreqsCare5level);
    Detunings(i) = [];
    SmallestDetuning = min(Detunings);
    %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
    TransferTime = 2*SmallestDetuning./Sweep(index);
    TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTransferTime5 = TotalTransferTime5 + TransferTime;
    %Add in decay error
    ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
    %Mult this transfer prob to the tally prob
    ProbIdeal5Level = ProbIdeal.*ProbIdeal5Level;
    %Add sweep data from this transfer to sweep data array
    %IdealSweeps5(i, :) = Sweep(index);
end
% for i = 2:length(Detunings5Level(:,1))
%     prob5level = Prob4(Linewidth, RabiMat, SweepMat, Detunings5Level(i,:), SmallestDetuning5(i), F);
%     %Take into account the decay rate
%     [ProbIdeal, index] = max(prob5level);
%     TransferTime = 2*SmallestDetuning5(i)./Sweep(index);
%     TransferTime = TransferTime.';
%     TotalTransferTime5 = TotalTransferTime5 + TransferTime;
%     ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
%     ProbIdeal5Level = ProbIdeal.*ProbIdeal5Level;
%     IdealSweeps5(i, :) = Sweep(index);
% %     SweepRateOpt3(i-1, 1) = Rabi(index);
% %     SweepRateRabiOpt3(i-1, 2) = Sweep(index);
% end
% for i = 2:length(Detunings5Level(:,1))-1
%     prob5level = Prob4(Linewidth, RabiMat, SweepMat, Detunings5Level(i,:), SmallestDetuning5(i), F);
%     %Take into account the decay rate
%     [ProbIdeal, index] = max(prob5level);
%     TransferTime = 2*SmallestDetuning5(i)./Sweep(index);
%     TransferTime = TransferTime.';
%     TotalTransferTime5 = TotalTransferTime5 + TransferTime;
%     ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
%     ProbIdeal5Level = ProbIdeal.*ProbIdeal5Level;
%     IdealSweeps5(i, :) = Sweep(index);
% %     SweepRateOpt3(i-1, 1) = Rabi(index);
% %     SweepRateRabiOpt3(i-1, 2) = Sweep(index);
% end

ProbIdeal7Level = ones(size(Rabi));
TotalTransferTime7 = zeros(size(Rabi));
%IdealSweeps7 = zeros(length(Detunings7Level(:,1)), length(Rabi));
% SweepRateOpt3 = zeros(length(Detunings3Level(:,1) - 1),length(Rabi));
%Go through each passage
for i = 2:7
    %Get the prob of the this transfer
    prob7level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare7level, F, i, ClebschsCare7level);
    %Get the sweep rate with the best fidelity for each Rabi freq
    [ProbIdeal, index] = max(prob7level);
    Detunings = abs(FreqsCare7level(i) -FreqsCare7level);
    Detunings(i) = [];
    SmallestDetuning = min(Detunings);
    %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
    TransferTime = 2*SmallestDetuning./Sweep(index);
    TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTransferTime7 = TotalTransferTime7 + TransferTime;
    %Add in decay error
    ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
    %Mult this transfer prob to the tally prob
    ProbIdeal7Level = ProbIdeal.*ProbIdeal7Level;
    %Add sweep data from this transfer to sweep data array
    %IdealSweeps7(i, :) = Sweep(index);
end
for i = 2:6
    %Get the prob of the this transfer
    prob7level = Prob5(Linewidth, RabiMat, SweepMat, FreqsCare7level, F, i, ClebschsCare7level);
    %Get the sweep rate with the best fidelity for each Rabi freq
    [ProbIdeal, index] = max(prob5level);
    Detunings = abs(FreqsCare7level(i) -FreqsCare7level);
    Detunings(i) = [];
    SmallestDetuning = min(Detunings);
    %Calculate the transfer time of this passage (optimal sweep rate; for each Rabi freq)
    TransferTime = 2*SmallestDetuning./Sweep(index);
    TransferTime = TransferTime.';
    %Add to transfer tally
    TotalTransferTime7 = TotalTransferTime7 + TransferTime;
    %Add in decay error
    ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
    %Mult this transfer prob to the tally prob
    ProbIdeal7Level = ProbIdeal.*ProbIdeal7Level;
    %Add sweep data from this transfer to sweep data array
    %IdealSweeps7(i, :) = Sweep(index);
end
% for i = 2:length(Detunings7Level(:,1))
%     prob7level = Prob4(Linewidth, RabiMat, SweepMat, Detunings7Level(i,:), SmallestDetuning7(i), F);
%     %Take into account the decay rate
%     [ProbIdeal, index] = max(prob7level);
%     TransferTime = 2*SmallestDetuning7(i)./Sweep(index);
%     TransferTime = TransferTime.';
%     TotalTransferTime7 = TotalTransferTime7 + TransferTime;
%     ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
%     ProbIdeal7Level = ProbIdeal.*ProbIdeal7Level;
%     IdealSweeps7(i, :) = Sweep(index);
% %     SweepRateOpt3(i-1, 1) = Rabi(index);
% %     SweepRateRabiOpt3(i-1, 2) = Sweep(index);
% end
% for i = 2:length(Detunings7Level(:,1))-1
%     prob7level = Prob4(Linewidth, RabiMat, SweepMat, Detunings7Level(i,:), SmallestDetuning7(i), F);
%     %Take into account the decay rate
%     [ProbIdeal, index] = max(prob7level);
%     TransferTime = 2*SmallestDetuning7(i)./Sweep(index);
%     TransferTime = TransferTime.';
%     TotalTransferTime7 = TotalTransferTime7 + TransferTime;
%     ProbIdeal = ProbIdeal.*exp(-TransferTime/DecayTime);
%     ProbIdeal7Level = ProbIdeal.*ProbIdeal7Level;
%     IdealSweeps7(i, :) = Sweep(index);
% %     SweepRateOpt3(i-1, 1) = Rabi(index);
% %     SweepRateRabiOpt3(i-1, 2) = Sweep(index);
% end

% Num3 = 3;
% Num5 = 5.5;
% Num7 = 8.5;
%Average number of fluorescences
% Fluorescence3 = 1.5;
% Fluorescence5 = 2.5;
% Fluorescence7 = 3.5;
Fluorescence3 = 2;
Fluorescence5 = 4;
Fluorescence7 = 6;
NA = 0.5;
Angle = asin(NA);
PercentCollected = sin(Angle/2)^2;
QE = 0.8;
P12Lifetime = 7.92e-9;
SaturationFluorescenceFreq = 1/(2*2*pi()*P12Lifetime);
AssumedFluorescenceFreq = SaturationFluorescenceFreq/4;
DetectionRate = AssumedFluorescenceFreq*PercentCollected*QE;
PhotonsToCollect = 10;
FluorescenceTime = PhotonsToCollect/DetectionRate;
%Calculate overall fluorescence time
TotalfTime3 = FluorescenceTime*Fluorescence3;
TotalfTime5 = FluorescenceTime*Fluorescence5;
TotalfTime7 = FluorescenceTime*Fluorescence7;
%Add in decay error during fluorescence
ProbIdeal3Level = ProbIdeal3Level.*exp(-TotalfTime3/DecayTime);
ProbIdeal5Level = ProbIdeal5Level.*exp(-TotalfTime5/DecayTime);
ProbIdeal7Level = ProbIdeal7Level.*exp(-TotalfTime7/DecayTime);

%Get best probabilities for each Rabi
% [ProbIdeal3, index3] = max(prob3level);
% [ProbIdeal5, index5] = max(prob5level);
% [ProbIdeal7, index7] = max(prob7level);
format long g;
%Organize ideal rabi/sweep/probs into nice matrix
% RabiSweepIdeal3 = [Rabi.' Sweep(index3) ProbIdeal3.'];
% RabiSweepIdeal5 = [Rabi.' Sweep(index5) ProbIdeal5.'];
% RabiSweepIdeal7 = [Rabi.' Sweep(index7) ProbIdeal7.'];
%The best overall fidelity
% disp('3-level');
% max(RabiSweepIdeal3(:,3))
% disp('5-level');
% max(RabiSweepIdeal5(:,3))
% disp('7-level');
% max(RabiSweepIdeal7(:,3))
IdealGateTimes3 = TotalTransferTime3;
IdealGateTimes5 = TotalTransferTime5;
IdealGateTimes7 = TotalTransferTime7;
% RabiGateTimeIdeal3 = [Rabi.' IdealGateTimes3 ProbIdeal3Level.' Sweep(index3)];
% RabiGateTimeIdeal5 = [Rabi.' IdealGateTimes5 ProbIdeal5Level.' Sweep(index5)];
% RabiGateTimeIdeal7 = [Rabi.' IdealGateTimes7 ProbIdeal7Level.' Sweep(index7)];
RabiGateTimeIdeal3 = [Rabi.' IdealGateTimes3' ProbIdeal3Level.'];
RabiGateTimeIdeal5 = [Rabi.' IdealGateTimes5' ProbIdeal5Level.'];
RabiGateTimeIdeal7 = [Rabi.' IdealGateTimes7' ProbIdeal7Level.'];
%Display the best sweep rate and fidelity for each rabi frequency (kHz)
format long g;

fig = figure(5);
set(fig,'defaultAxesColorOrder',[[26 146 186]/255; [50 181 107]/255]);

Fidelities3 = RabiGateTimeIdeal3(:,3);
Fidelities5 = RabiGateTimeIdeal5(:,3);
Fidelities7 = RabiGateTimeIdeal7(:,3);
GateTimes3 = RabiGateTimeIdeal3(:,2);
GateTimes5 = RabiGateTimeIdeal5(:,2);
GateTimes7 = RabiGateTimeIdeal7(:,2);
Rabis3 = RabiGateTimeIdeal3(:,1);
Rabis5 = RabiGateTimeIdeal5(:,1);
Rabis7 = RabiGateTimeIdeal7(:,1);

disp(max(Fidelities3));
disp(max(Fidelities5));
disp(max(Fidelities7));




%Calculate total time for the whole measurement
TotalTime3 = GateTimes3 + TotalfTime3;
TotalTime5 = GateTimes5 + TotalfTime5;
TotalTime7 = GateTimes7 + TotalfTime7;

%Threshold to display
Thresh = 0.97;
%yyaxis left;
Fidelities3(Fidelities3<Thresh) = -inf;
Lev3 = semilogx(TotalTime3, Fidelities3);
hold on;
set(Lev3, 'Linewidth', 1.5, 'Color', [128 0 132]/255);

Fidelities5(Fidelities5<Thresh) = -inf;
Lev5 = plot(TotalTime5, Fidelities5);
hold on;
set(Lev5, 'Linestyle', '-.', 'Linewidth', 1.5, 'Color', [0 133 93]/255);

Fidelities7(Fidelities7<Thresh) = -inf;
Lev7 = plot(TotalTime7, Fidelities7);
hold on;
set(Lev7, 'Linestyle', '--', 'Linewidth', 1.5, 'Color', [19 14 141]/255);

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
l3 = legend(Leg, 'Location', 'Northeast','FontSize',14);
%ax5.Title.String = 'Qudit measurement fidelity';
%ax5.Title.FontSize = 30;
ax5.FontSize = 14;
ax5.XLabel.String = 'Total measurement time (ms)';
ax5.XLabel.FontSize = 20;
ax5.YLabel.String = 'Fidelity';
ax5.YLabel.FontSize = 20;
ylim([.975 1]);
set(ax5, 'YTick', 0:0.005:1,...
    'YMinorTick', 'on', 'TickDir', 'out',...
    'YGrid', 'on', 'XGrid', 'on',...
    'XTickLabel', [0.1 1 10 100 1000])
set(gcf, 'Position', [100 100 600 500]);
%set(gcf, 'Renderer', 'opengl');
%saveas(gcf, 'Overall_Measurement.pdf');
%export_fig Overall_Measurement.pdf
%export_fig('Overall-Measurement5.pdf', '-pdf', '-opengl')
