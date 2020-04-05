function G = getGlobals
%This function contains all global values used in much of the functions for
%FreqsSpace_AllTransitions. It contains information on energy structure,
%encodings, and how we choose to format the graphs made. Usage is like
%G = getGlobals();
G.I = 3/2;
G.J = 1/2;
G.Jp = 5/2;
G.Fs = [1 2];
G.Fps = [1 2];
G.Eta = 0.0234;

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

%Blue to Purple, 6 colorblind colors
G.EncodedColors = [[158 188 218];[77 0 75];[140 150 198];[140 107 177];[136 65 157];[129 15 124]]/255;
%Orange to Red, 6 colorblind colors %[215 48 31];
G.OtherColors = [[253 187 132];[252 141 89];[239 101 72];[179 0 0];[127 0 0]]/255;

G.TextHeight = 0.02;
G.TextFontSize = 6;
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
G.OtherLineStyle = '-';
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
G.FiveLevelGraphCut = 1.2;
G.SevenLevelGraphCut = 1.2;
G.GraphCut = [G.ThreeLevelGraphCut G.FiveLevelGraphCut G.SevenLevelGraphCut];

G.GraphOverShoot = 20e6*G.ScaleX;
G.SameHeight = false;
G.SameHeightHeight = 0.5;
end