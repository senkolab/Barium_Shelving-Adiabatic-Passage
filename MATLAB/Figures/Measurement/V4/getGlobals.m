function G = getGlobals
%% Global Parameters
G.Fidelity = 1;
G.Linewidth = 1;
G.DecayTime = 35;

G.DetuningErrorOn = true;
G.DephasingErrorOn = true;
G.LZErrorOn = true;
G.OffResErrorOn = true;
G.MotionalErrorOn = true;
G.DecayTimeErrorOn = true;
G.Thresh = 0.975;
G.ThreeColor = [128 0 132]/255;
G.ThreeLineStyle = '-';
G.FiveColor = [0 133 93]/255;
G.FiveLineStyle = '-.';
G.SevenColor = [19 14 141]/255;
G.SevenLineStyle = '--';
G.WorstLineStyle = ':';

%% Fluorescence Information
NA = 0.5;
Angle = asin(NA);
PercentCollected = sin(Angle/2)^2;
QE = 0.8;
P12Lifetime = 7.92e-9;
SaturationFluorescenceFreq = 1/(2*2*pi()*P12Lifetime);
AssumedFluorescenceFreq = SaturationFluorescenceFreq/4;
DetectionRate = AssumedFluorescenceFreq*PercentCollected*QE;
PhotonsToCollect = 10;
G.FluorescenceTime = PhotonsToCollect/DetectionRate;
%% Frequency Information in XZ polarization
%Using \gamma=45, \phi=0 orientation XZ,
%we can ignore +-1 transitions, so just +-2 transitions matter. Picked 
%detuning frequency of -1092 MHz.
%Information about each transition
TransSpreadInfo = [...
    "2-1:p0" "2-1:p2.p0" "2-1:-1" "2:p1.-1" "ENCODING:1:-1" "ENCODING:1:p0" "ENCODING1:p1" "2:p0.p2" ...
    "2:-1.p1" "ENCODING2:p2" "2:-2.p0" "ENCODING:2:p1" "ENCODING2:p0" "ENCODING:2:-1" "2:p2.p0" "ENCODING:2:-2" "2:p1.-1" "2:p0.-2" "1:p1.-1" "1:-1.p1"];
FreqsSpread = [...
    4000.431225 4007.011692 4011.11359 4017.699447 4020.050647 4037.321568 ...
    4054.150786 4058.065298 4062.327219 4064.645765 4066.428678 4068.913075 ...
    4073.019937 4076.887145 4079.600404 4080.376742 4083.473002 4086.968001 ...
    4026.636504 4047.56493]*1e6;
%These Clebsch-Gordan Coefficients include the geometrical component based
%on the 1762nm polarization and direction: \gamma = 45, \phi = 0
ClebschSpread = [...
    0 0.00745 0.01581 0.00527 0.035360338 0.070720676 0.035360338 0.010910894 0.013362742...
    0.026725484 0.010910894 0.013362742 0.026725484 0.013362742 0.010910894 0.026725484...
    0.013362742 0.010910894 ...
    0.035360338 0.035360338];
G.FreqsInfoXZ = [TransSpreadInfo.' FreqsSpread.' ClebschSpread.'];

%% 3-Level XZ
%The best case involves shelving 2.p0:p0, then 1.p1:p1, and then
%deshelving 2.p0:p0, resulting in no motional sidebands driven
G.ThreeBest = [3 2 3];
%None needed
G.ThreeBestDet = [];

%Motional sidebands - can avoid them completely as above, but here, we present
%the worst case where we do drive transitions that sweep through them.
%This involves first driving 1.n1:n1, then 1.p1:p1, then deshelving
%1.n1:n1. This results in two 1st order sidebands, and 1 second
%order sideband being driven. 
G.ThreeWorst = [1 2 1];
%2-1.p1:n1, 2.p0:p2
Detunings = [0.351200443e6 0.085487684e6];
%Motional sideband order
Order = [1 2];
%Which transfer above is this motional sideband driven during?
Transfer = [1 2];
%Is it driven twice (Meaning once for shelving, once for deshelving)?
Twice = ["yes","no"];
G.ThreeWorstDet = [Detunings;Order;Transfer;Twice];

%% 5-Level XZ
%Best case drive 2.p0:p0, 1.p1:p1, 1.n1:n1, 2.p2:p2, then deshelve
%2.p0:p0, 2.p2:p2, 1.p1:p1 In this case, we drive two first order
%sidebands, one of them sort of twice
%Setup which transitions to drive at each steps
G.FiveBest = [4 2 1 3 4 3 2];
%2:1.p1:n1, 2.n2:p0
%Detunings of each motional sideband from the encoded transition
Detunings = [0.351200443e6 0.217087437e6];
%Which transfer above is this motional sideband driven during?
Transfer = [3 4];
Order = [1, 1];
%Matrix to tell if you need to do this transfer twice. Yes for 2.n2:p0
%because we're swapping between a shelved and unshelved state
Twice = ["no", "no"];
G.FiveBestDet = [Detunings;Order;Transfer;Twice];

%The atrocious case is where we drive -2:-2,
%resulting in a carrier other transition driving population from the
%+2:+2 encoded level. We assume we drive 1.p1:p1, 1.n1:n1, 2.p0:p0,
%2.p2:p2, then deshelve 1.p1:p1, 2.p2:p2, 1.n1:n1, resulting in a total
%of two 2nd order and 4 1st order motional sidebands driven
%Setup which transitions to drive at each steps
G.FiveWorst = [2 1 4 3 2 3 1];
%Detunings of each motional sideband from the encoded transition
%2.p0:p2, 2-1.p1:n1, 2.n2:p0
Detunings = [0.085487684e6 0.351200443e6 0.217087437e6];
%Which transfer above is this motional sideband driven during?
Transfer = [1 2 4];
%Motional sideband order
Order = [2 1 1];
Twice = ["yes" "yes" "yes"];
G.FiveWorstDet = [Detunings;Order;Transfer;Twice];
end