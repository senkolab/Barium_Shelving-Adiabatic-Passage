clearvars;
addpath('..\..\..\Functions\Frequencies_EnergyStructure');
%% Parameters
%3, 5, or 7
Levels = 5;
Worst = false;
MeasurementSequence = false;
MeasurementManual = false;
%"XZ", "Orthogonal", or "Average"
GeomOrientation = "Orthogonal";
CarrierFreq = -1130e6;
Detuning = 1.31e6;
G = getGlobals_V3();

%% Preparation - Measurement info, frequency info
%Get the measurement sequence
[LevelsG, LevelsP, Measurement] = getMeasurement(G, MeasurementSequence, Worst, Levels, GeomOrientation);

%Get all frequencies we care about
Freqs = [];
if MeasurementSequence
    %Go through the sequence
    Freqs = [Freqs; getFreqsMeasurementSeq(G, Measurement, LevelsG, LevelsP, Levels, CarrierFreq, GeomOrientation)];
else
    Freqs = [Freqs; GetCareFrequencies(G, LevelsG, LevelsP, CarrierFreq, GeomOrientation)];
end
%Delete duplicates
[Freqs, index] = unique(Freqs, 'rows');
%Sort by zeroth order carrier freqs
[~,index] = sort(abs(Freqs(:,7)));
Freqs = Freqs(index,:);
%Pull out encoded transitions
FreqsEnc = Freqs(Freqs(:, 8) == 1, :);

%Scale Frequencies for graphing
Freqs = [Freqs(:,1)*G.ScaleX Freqs(:,2:8)];
FreqsEnc = [FreqsEnc(:,1)*G.ScaleX FreqsEnc(:,2:8)];
% FreqsCareOverall = [FreqsCareOverall(:,1)*G.ScaleX FreqsCareOverall(:,2:8)];
Detuning = Detuning*G.ScaleX;

%Find the strongest transition's coefficient
% MaxClebschs = max(FreqsCareOverall(:, 6));
MaxClebschs = max(Freqs(:, 6));

%% Plot all frequencies
fig = figure(1);
ax = gca;
hold on;

%j and k iterates the number of encoded transitions plotted and the number
%of other transitions plotted respectively
j = 0;
k = 0;
for i = 1:size(Freqs, 1)
    Trans = Freqs(i, :);
    %Carrier transition?
    if Trans(7) == 0
        %Encoded carrier transition?
        if Trans(8) == 1
            %Set the color from the list of encoded colors and store this
            %color in EncColorsTag
            Color = G.EncodedColors(mod(j, length(G.EncodedColors))+1, :);
            j = j + 1;
            EncColorsTag(j, :) = [Trans(2:5) Color];
        %Other carrier transition?
        else
            %Set the color from the list of other colors and store this
            %color in OtherColors Tag
            Color = G.OtherColors(mod(k, length(G.OtherColors))+1, :);
            k = k + 1;
            OtherColorsTag(k, :) = [Trans(2:5) Color];
        end
    %Motional sideband transition?
    else
        %Encoded motional sideband transition?
        if Trans(8) == 1
            %Find the color associated with this transition
            Color = EncColorsTag(find(all(EncColorsTag(:, 1:4) == Trans(2:5), 2)), 5:7);
        %Other motional sideaband transition?
        else
            Color = OtherColorsTag(find(all(OtherColorsTag(:, 1:4) == Trans(2:5), 2)), 5:7);
        end
    end
    %Set boundary for which transitions we'll plot based on lowest and
    %highest encoded transition
    LeftBound = abs(min(FreqsEnc(:, 1))) - G.GraphOverShoot;
    RightBound = abs(max(FreqsEnc(:, 1))) + G.GraphOverShoot;
    if abs(Trans(1)) > LeftBound && ...
            abs(Trans(1)) < RightBound
        [Plot, Line, Text, Area] = PlotTransition_V3(Trans, Color, MaxClebschs, Detuning, GeomOrientation);
    end
end

%% Touch up the graph
ax.XLim = [LeftBound RightBound];
Legend = sprintf(...
    'Encoded: Blue/Purple\nOther: Red/Orange\nLaserSweep: Shaded Areas\nIrrelevant: Grey\nMotional Sidebands: White Arrow');
LegendXPosition = ((max(FreqsEnc(1:Levels,1)) + min(FreqsEnc(1:Levels,1)))/2 + G.GraphOverShoot/2);
if Levels == 3
    Levelsi = 1;
elseif Levels == 5
    Levelsi = 2;
elseif Levels == 7
    Levelsi = 3;
end
ax.YLim = [0 G.GraphCut(Levelsi)];
text(LegendXPosition, G.GraphCut(Levelsi) - 0.2, Legend, 'FontSize', 16);
TitleText = sprintf('%i-Level %s Orientation', Levels, GeomOrientation);
title(TitleText, 'FontSize', 16);
fig.Position = [100 100 1200 600];
ylabel('Normalized Strength', 'FontSize', 16);
if G.ScaleX == 1e-6
    XText = sprintf('Frequency/MHz');
else
    XText = sprintf(...
        'Frequency/%d Hz', G.ScaleX);
end
xlabel(XText, 'FontSize', 16);
%Set background color white
set(gcf,'color','white');