function G = getGlobals
%Blue to Purple, 6 colorblind colors
G.EncodedColors = [[158 188 218];[77 0 75];[140 150 198];[140 107 177];[136 65 157];[129 15 124]];
%Orange to Red, 6 colorblind colors
%[215 48 31];
G.OtherColors = [[253 187 132];[252 141 89];[239 101 72];[179 0 0];[127 0 0]];
G.IrrelevantColor = [0 0 0];
G.Detuning = 1.6;
G.IrrelevantWidth = 0.25;
G.IrrelevantAlpha = 0.1;
G.IrrelevantLineWidth = 0.2;
G.RelevantAlpha = 1;
G.RelevantLineWidth = 1;
G.SweepAlpha = 0.3;
G.SweepHeight = 1/3;
G.TextHeight = 0.02;
G.TextFontSize = 6;
G.TextOffSet = 0;
G.ShowRelevantText = true;
G.ShowIrrelevantText = false;
G.ShowRelevantTextMotional = false;
G.ShowIrrelevantTextMotional = false;
G.EncodedLineStyle = '-';
G.OtherLineStyle = '-';
G.MotionalLineStyle1 = '--';
G.MotionalLineStyle2 = ':';
G.ThreeLevelGraphCut = 0.8;
G.FiveLevelGraphCut = 0.8;
G.SevenLevelGraphCut = 1.2;
G.SameHeight = false;
G.SameHeightHeight = 0.5;
G.MotionalHeight1 = 0.023;
G.MotionalHeight2 = 0.023^2;
G.SidebandMarkerColor = [1 1 1];
end 