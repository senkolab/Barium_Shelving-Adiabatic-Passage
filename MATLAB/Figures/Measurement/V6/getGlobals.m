function G = getGlobals()
%% Global Parameters
G.Fidelity = 1;
G.Linewidth = 1;
G.DecayTime = 35;
G.I = 3/2;
G.J = 1/2;
G.Jp = 5/2;
G.Fs = [1 2];
G.Fps = [1 2];
G.Eta = 0.0243;
G.MotionalFreq = 2e6;

G.DetuningErrorOn = true;
G.DephasingErrorOn = true;
G.LZErrorOn = true;
G.OffResErrorOn = true;
G.MotionalErrorOn = true;
G.DecayTimeErrorOn = true;
G.Thresh = 0.975;
G.ThreeColor = [128 0 132]/255;
G.FiveColor = [0 133 93]/255;
G.SevenColor = [19 14 141]/255;
G.Colors = [G.ThreeColor;G.FiveColor;G.SevenColor];
G.ThreeLineStyle = '-';
G.FiveLineStyle = '-.';
G.SevenLineStyle = '--';
G.WorstLineStyle = ':';
G.LineStyles = {G.ThreeLineStyle;G.FiveLineStyle;G.SevenLineStyle};
G.LineStyle3 = G.LineStyles(1);

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
%% Frequency Information
%detuning frequency of -1092 MHz results in many more overlaps in
%frequencies for unwanted transitions. We pick -1030 MHz instead to avoid
%many of these. 
%Generate all energy levels and their F, mF values
G.EnergiesS12 = [-5020.299869 -5023.594146 -5026.885725 3007.567387 3010.864369...
    3014.158646 3017.450225 3020.739113]*1e6;
G.EnergiesS12 = G.EnergiesS12.';
G.EnergiesD52 = [91.7507785	105.7274217	119.2650606	19.19064521	25.97722349	...
    33.13870889	40.53715002	48.09334784]*1e6;
%Encodings for 3- 5- and 7-level qudits
G.Encoded3 = [...
    1 -1 1 -1;...
    1 1 1 1;...
    2 0 2 0];
G.Encoded5 = [...
    G.Encoded3;...
    2 -2 2 -2;...
    2 2 2 2];
G.Encoded7 = [...
    G.Encoded3;...
    1 0 1 0;...
    2 1 2 1;...
    2 -1 2 -1;...
    2 2 2 2];

%Ordered so that the last row is the one we don't shelve
G.EncodedBaseG3 = [...
    1 -1;...
    1 1;...
    2 0];
G.EncodedBaseG5 = [...
    G.EncodedBaseG3;...
    2 -2;...
    2 2];
G.EncodedBaseG7 = [...
    G.EncodedBaseG3;...
    2 1;...
    2 -1;...
    2 2;...
    1 0];
G.EncodedBaseP3 = G.EncodedBaseG3;
G.EncodedBaseP5 = G.EncodedBaseG5;
G.EncodedBaseP7 = G.EncodedBaseG7;

%Store the information of each state
G.LevelsAll = [...
    2 -2;...%1
    1 -1;...%2
    2 -1;...%3
    1 0;...%4
    2 0;...%5
    1 1;...%6
    2 1;...%7
    2 2];%8
    
G.Levels3G = [...
    NaN NaN;...%1
    1 -1;...%2
    NaN NaN;...%3
    NaN NaN;...%4
    2 0;...%5
    1 1;...%6
    NaN NaN;...%7
    NaN NaN];%8

G.Levels5G = [...
    2 -2;...%1
    1 -1;...%2
    NaN NaN;...%3
    NaN NaN;...%4
    2 0;...%5
    1 1;...%6
    NaN NaN;...%7
    2 2];%8

G.Levels7G = [...
    NaN NaN;...%1
    1 -1;...%2
    2 -1;...%3
    1 0;...%4
    2 0;...%5
    1 1;...%6
    2 1;...%7
    2 2];%8

G.Levels3P = NaN(8, 2);
G.Levels5P = G.Levels3P;
G.Levels7P = G.Levels3P;
    

%% 3-Level XZ
%Changing CarrierFreq to a lower frequency (Below -1120), the 3-level no
%longer has any motional sidebands at all, so there is no worst case now
%The best case involves shelving 2.p0:p0, then 1.p1:p1, and then
%deshelving 2.p0:p0, resulting in no motional sidebands driven
G.ThreeBest = [3 2 3];
%None needed
G.ThreeBestDet = [];

G.ThreeWorst = [];
G.ThreeWorstDet = [];
%Columns do
%Col1: What type of step is this?
%Col2: Which state to move
%Col3: Where to move it
G.ThreeBestMeasurement = [...
    "Shelve", 5, 5;...
    "Shelve", 6, 6;...
    "Fluoresce", 2, 2;...
    "Deshelve", 5, 5;...
    "Fluoresce", 5, 5];


%% 5-Level XZ
%Best case drive 2.p0:p0, 1.p1:p1, 1.n1:n1, 2.p2:p2, then deshelve
%2.p0:p0, 2.p2:p2, 1.p1:p1 In this case, we drive two first order
%sidebands, one of them sort of twice
%Setup which transitions to drive at each steps
G.FiveBest = [3 2 1 5 3 5 2];
G.FiveBestMeasurement = [...
    "Shelve" 6 6;...
    "Shelve" 2 2;...
    "Hide" 1 2;...
    "Shelve" 8 8;...
    "Shelve" 5 5;...
    "Fluoresce" 2 2;...
    "Deshelve" 5 5;...
    "Fluoresce" 5 5;...
    "Deshelve" 2 2;...
    "Fluoresce" 2 2;...
    "Deshelve" 6 6;...
    "Fluoresce" 6 6
    ];
%Drive a carrier twice, a first order motional sideband twice
G.FiveWorstMeasurement = [...
    "Shelve" 5 5;...
    "Shelve" 1 1;...
    "Shelve" 8 8;...
    "Shelve" 2 2;...
    "Fluoresce" 6 6;...
    "Deshelve" 1 1;...
    "Fluoresce" 1 1;...
    "Deshelve" 8 8;...
    "Fluoresce" 8 8;...
    "Deshelve" 5 5;...
    "Fluoresce" 5 5];
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