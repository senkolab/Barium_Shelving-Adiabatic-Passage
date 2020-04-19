function G = getGlobals_V2()
%% Global Parameters
G.DecayTime = 30;
G.I = 3/2;
G.J = 1/2;
G.Jp = 5/2;
G.Fs = [1 2];
G.Fps = [1 2];
G.Eta = 0.0243;
G.MotionalFreq = 2e6;

G.DetuningErrorOn = true;
G.DephasingErrorOn = true;
G.DephasingExp = 2*pi^2;
G.LZErrorOn = true;
G.LZExp = pi^2;
G.OffResErrorOn = true;
G.MotionalErrorOn = false;
G.DecayTimeErrorOn = true;
G.FluorescenceErrorOn = true;
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
G.TimeScaling = 1e3;

%% Fluorescence Information
NA = 0.5;
Angle = asin(NA);
G.PercentCollected = sin(Angle/2)^2;
QE = 0.8;
P12Lifetime = 7.92e-9;
SaturationFluorescenceFreq = 1/(2*2*pi()*P12Lifetime);
AssumedFluorescenceFreq = SaturationFluorescenceFreq/4;
DetectionRate = AssumedFluorescenceFreq*G.PercentCollected*QE;
PhotonsToCollect = 10;
G.FluorescenceTime = PhotonsToCollect/DetectionRate;
G.FluorescenceError = 2.9e-4;

%% Frequency Information
%detuning frequency of -1092 MHz results in many more overlaps in
%frequencies for unwanted transitions. We pick -1030 MHz instead to avoid
%many of these. 
%Generate all energy levels and their F, mF values
G.EnergiesGround = [-5020.299869 -5023.594146 -5026.885725 3007.567387 3010.864369...
    3014.158646 3017.450225 3020.739113]*1e6;
G.EnergiesGround = G.EnergiesGround.';
G.EnergiesExcited = [91.7507785	105.7274217	119.2650606	19.19064521	25.97722349	...
    33.13870889	40.53715002	48.09334784]*1e6;

%% Encoding Information
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
end