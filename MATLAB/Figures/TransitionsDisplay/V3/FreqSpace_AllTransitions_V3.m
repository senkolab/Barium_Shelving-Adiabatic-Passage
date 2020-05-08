clearvars;
addpath('..\..\..\Functions\Frequencies_EnergyStructure', '..\..\..\altmany-export_fig-9502702');
%% Parameters
Worst = false;
MeasurementSequence = false;
MeasurementManual = false;
SavePDF = false;
TitleDisplay = false;

%3, 5, or 7
Levels = 5;
%"XZ", "Orthogonal", or "Average"
GeomOrientation = "XZ";
CarrierFreq = -1130e6;
Detuning = 1.3e6;
G = getGlobals_V3();
SavePDFName = sprintf("%s_%gMHz_%i-Level_%gMHz", GeomOrientation, CarrierFreq*1e-6, Levels, Detuning*1e-6);
SavePDFName = strrep(SavePDFName, ".", "p");

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
%Can end up with some transitions that are used as an encoding transition
%somewhere, but not elsewhere. These are duplicated, but with the last row
%tagging it as encoded in one entry and unencoded in the other. Delete
%these duplicates
Encoded = Freqs(Freqs(:, 8) == 1, :);
Unencoded = Freqs(Freqs(:, 8) == 0, :);
for i = 1:size(Encoded, 1)
    Unencoded = Unencoded(Unencoded(:, 1) ~= Encoded(i, 1), :);
end
Freqs = [Encoded;Unencoded];

%Delete other duplicates
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
l = 0;
%m, n, o iterate the number of encoded, other, motional transitions
%actually plotted (within the bounds)
m = 0;
n = 0;
o = 0;
Leg = {};
NumGraph = 1;
for i = 1:size(Freqs, 1)
    Trans = Freqs(i, :);
    %Set boundary for which transitions we'll plot based on lowest and
    %highest encoded transition
    LeftBound = abs(min(FreqsEnc(:, 1))) - G.GraphOverShoot;
    RightBound = abs(max(FreqsEnc(:, 1))) + G.GraphOverShoot;
    %Carrier transition?
    if Trans(7) == 0
        %Encoded carrier transition?
        if Trans(8) == 1
            %Set the color from the list of encoded colors and store this
            %color in EncColorsTag
            Color = G.EncodedColors(mod(j, length(G.EncodedColors))+1, :);
            j = j + 1;
            EncColorsTag(j, :) = [Trans(2:5) Color];
            if abs(Trans(1)) > LeftBound && abs(Trans(1)) < RightBound
                m = m + 1;
            end
        %Other carrier transition?
        else
            %Set the color from the list of other colors and store this
            %color in OtherColors Tag
            Color = G.OtherColors(mod(k, length(G.OtherColors))+1, :);
            k = k + 1;
            OtherColorsTag(k, :) = [Trans(2:5) Color];
            if abs(Trans(1)) > LeftBound && abs(Trans(1)) < RightBound
                n = n + 1;
            end
        end
    %Motional sideband transition?
    else
        l = l + 1;
        %Encoded motional sideband transition?
        if Trans(8) == 1
            %Find the color associated with this transition
            Color = EncColorsTag(find(all(EncColorsTag(:, 1:4) == Trans(2:5), 2)), 5:7);
        %Other motional sideaband transition?
        else
            Color = OtherColorsTag(find(all(OtherColorsTag(:, 1:4) == Trans(2:5), 2)), 5:7);
        end
        if abs(Trans(1)) > LeftBound && abs(Trans(1)) < RightBound
            o = o + 1;
        end
    end
    if abs(Trans(1)) > LeftBound && ...
            abs(Trans(1)) < RightBound
        [Plot, Line, Text, Area] = PlotTransition_V3(Trans, Color, MaxClebschs, Detuning, GeomOrientation);
        %Check if first encoded transition, to save legend entry and turn
        %off legend display of marker
        if m == 1 && Trans(7) == 0 && Trans(8) == 1
            Leg{NumGraph} = "Encoded Transition";
            NumGraph = NumGraph + 1;
            Leg{NumGraph} = "Laser Sweep";
            NumGraph = NumGraph + 1;
            if Plot ~= false
                set(get(get(Plot,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        %Check if first other transition, to save legend entry and turn
        %off legend display of marker
        elseif n == 1 && Trans(7) == 0 && Trans(8) == 0
            Leg{NumGraph} = "Unwanted Transition";
            NumGraph = NumGraph + 1;
            FirstOth = true;
            if Plot ~= false
                set(get(get(Plot,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        %Check if first motional transition, to save legend entry and turn
        %off legend display of line
        elseif o == 1 && Trans(7) ~= 0
            Leg{NumGraph} = "Motional Sideband";
            NumGraph = NumGraph + 1;
            FirstMot = true;
            if Line ~= false
                set(get(get(Line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        %Otherwise, take off legend display 
        else
            if Plot ~= false
                set(get(get(Plot,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
            if Line ~= false
                set(get(get(Line,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
            %set(get(get(Text,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            if Area ~= false
                set(get(get(Area,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            end
        end
    end
end

%% Touch up the graph
ax.XLim = [LeftBound RightBound];
% Legend = sprintf(...
%     'Encoded: Blue/Purple Solid\nOther: Red/Orange Dashed\nLaserSweep: Shaded Areas\nMotional Sidebands: White Arrow');
% LegendXPosition = ((max(FreqsEnc(1:Levels,1)) + min(FreqsEnc(1:Levels,1)))/2 + G.GraphOverShoot/2);
% text(LegendXPosition, G.GraphCut(Levelsi) - 0.1, Legend, 'FontSize', 16);
if Levels == 3
    Levelsi = 1;
elseif Levels == 5
    Levelsi = 2;
elseif Levels == 7
    Levelsi = 3;
end
ax.YLim = [0 G.GraphCut(Levelsi)];
if TitleDisplay
    TitleText = sprintf('%i-Level %s Orientation, Carrier %d MHz', Levels, GeomOrientation, CarrierFreq*1e-6);
    title(TitleText, 'FontSize', 16);
end
fig.Position = [100 100 1200 600];
ylabel('Normalized Strength', 'FontSize', 16);
if G.ScaleX == 1e-6
    XText = sprintf('Frequency (MHz)');
else
    XText = sprintf(...
        'Frequency/%d Hz', G.ScaleX);
end
xlabel(XText, 'FontSize', 16);
ax.FontSize = 12;
l3 = legend(Leg, 'Location', 'Northeast','FontSize',14);
%Set background color white
set(gcf,'color','white');
box on;

if SavePDF
    export_fig(SavePDFName, '-pdf', '-opengl')
end