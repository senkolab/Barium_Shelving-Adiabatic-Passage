function G = getGlobals_V3
%This function contains all global values used in much of the functions for
%FreqsSpace_AllTransitions. It contains information on energy structure,
%encodings, and how we choose to format the graphs made. Usage is like
%G = getGlobals();
%% Experimental parameters
G.I = 3/2;
G.J = 1/2;
G.Jp = 5/2;
G.Fs = [1 2];
G.Fps = [1 2];
G.Eta = 0.0234;
G.MotionalFreq = 2e6;

G.MotionalErrorOn = true;

%% Display parameters
%Blue to Purple, 6 colorblind colors
G.EncodedColors = [[158 188 218];[77 0 75];[140 150 198];[140 107 177];[136 65 157];[129 15 124];[140 150 198]]/255;
%Orange to Red, 6 colorblind colors %[215 48 31];
G.OtherColors = [[253 187 132];[252 141 89];[239 101 72];[179 0 0];[127 0 0]]/255;

G.TextHeight = 0.02;
G.TextFontSize = 8;
G.TextOffSet = 0;
G.ShowRelevantText = true;
G.ShowIrrelevantText = false;
G.ShowRelevantTextMotional = false;
G.ShowIrrelevantTextMotional = false;

G.SweepAlpha = 0.3;
G.SweepHeight = 1/3;

G.EncodedLineWidth = 1;
G.EncodedLineStyle = '-';
G.EncodedAlpha = 1;

G.OtherLineWidth = 1;
G.OtherLineStyle = '--';
G.OtherAlpha = 1;

G.MotionalOneLineStyle = '--';
G.MotionalOneLineWidth = 1;
G.MotionalOneAlpha = 1;
G.MotionalOneMarkerColor = [1 1 1];
G.MotionalHeightOne = G.Eta;

G.MotionalTwoLineStyle = ':';
G.MotionalTwoLineWidth = 1;
G.MotionalTwoAlpha = 1;
G.MotionalTwoMarkerColor = [1 1 1];
G.MotionalHeightTwo = G.Eta^2;

G.ScaleX = 1e-6;

G.ThreeLevelGraphCut = 1.2;
G.FiveLevelGraphCut = 0.8;
G.SevenLevelGraphCut = 1.2;
G.GraphCut = [G.ThreeLevelGraphCut G.FiveLevelGraphCut G.SevenLevelGraphCut];

G.GraphOverShoot = 20e6*G.ScaleX;
G.SameHeight = false;
G.SameHeightHeight = 0.5;

%% Energy Information
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
    
%For storing the chosen encoding. The same regardless of geometric
%orientation
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

%For storing the chosen shelving state
G.Levels3PXZ = G.Levels3G;
G.Levels5PXZ = G.Levels5G;
G.Levels7PXZ = G.Levels7G;
G.Levels3POrthog = [...
    NaN NaN;...%1
    1 -1;...%2
    NaN NaN;...%3
    NaN NaN;...%4
    NaN NaN;...%5
    1 1;...%6
    NaN NaN;...%7
    2 2];%8
G.Levels5POrthog = G.Levels5G;
G.Levels7POrthog = G.Levels7G;

%For storing the initial status of the shelving state
G.Levels3P = NaN(8, 2);
G.Levels5P = G.Levels3P;
G.Levels7P = G.Levels3P;

%% Measurement sequences:
%Col1: What type of step is this?
%Col2: Lower level state
%Col3: Upper level state
G.ThreeBestMeasurement = [...
    "Shelve", 5, 5;...%1
    "Shelve", 6, 6;...%2
    "Fluoresce", 2, 2;...%3
    "Deshelve", 5, 5;...%4
    "Fluoresce", 5, 5];%5
G.FiveBestMeasurement = [...
    "Shelve" 6 6;...%1
    "Shelve" 2 2;...%2
    "Hide" 1 2;...%3
    "Shelve" 8 8;...%4
    "Shelve" 5 5;...%5
    "Fluoresce" 2 2;...%6
    "Deshelve" 5 5;...%7
    "Fluoresce" 5 5;...%8
    "Deshelve" 2 2;...%9
    "Fluoresce" 2 2;...%10
    "Deshelve" 6 6;...%11
    "Fluoresce" 6 6];%12
G.FiveWorstMeasurement = [...
    "Shelve" 5 5;...%1
    "Shelve" 1 1;...%2
    "Shelve" 8 8;...%3
    "Shelve" 2 2;...%4
    "Fluoresce" 6 6;...%5
    "Deshelve" 1 1;...%6
    "Fluoresce" 1 1;...%7
    "Deshelve" 8 8;...%8
    "Fluoresce" 8 8;...%9
    "Deshelve" 5 5;...%10
    "Fluoresce" 5 5];%11
end