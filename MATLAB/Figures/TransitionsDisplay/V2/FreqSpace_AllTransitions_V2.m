clearvars;
addpath('..\..\..\Functions\Frequencies_EnergyStructure');

%3, 5, or 7
Levels = 3;
%"XZ", "Orthogonal", or "Average"
GeomOrientation = "XZ";
if ~logical(exist('GeomOrientation', 'var'))
    Prompt = 'Geometric Orientation: ''XZ'', ''Orthogonal'', ''Average'':';
    GeomOrientation = input(Prompt);
end
if ~logical(exist('Levels', 'var'))
    Prompt = 'Number of qudit levels:';
    Levels = input(Prompt);
end
%Hide state F=2, mF=-2 in F=1, mF=-1
%In doing this, we also need to "Pretend" to hide state F=2, mF = 0, since
%we artificially hide it by our choice of when to shelve it
Hide = [...
    4 1 -1;...
    3 4 4];
Hide = [];

CarrierFreq = -1130e6;
Detuning = 1.31e6;
MotionalFreq = 2e6;
G = getGlobals();

%% All frequencies and details about them
%Retrieve all of the relevant frequencies
[FreqsAbs, FreqsMotional] = CalculateFreqs(G.I, G.J, G.Jp, CarrierFreq, ...
    G.EnergiesS12, G.EnergiesD52, G.Fs, G.Fps, GeomOrientation, true, MotionalFreq);

%Only add MotionalFreqs to FreqsCare if it's nonempty
if ~isempty(FreqsMotional)
    Freqs= [FreqsAbs; FreqsMotional];
else
    Freqs = FreqsAbs;
end

%Get which frequencies actually matter for this encoding
Care = GetCareTransitions(Levels, Freqs, GeomOrientation);
FreqsCareOverall = Freqs(Care, :);
%Pick out the encoded transitions
FreqsCareEncoded = FreqsCareOverall(1:Levels, :);

Enc = [];
for i = 1:size(FreqsCareOverall)
    Fs = FreqsCareOverall(i,2:5);
    Enc(i) = any(any(all(FreqsCareEncoded(:,2:5) == Fs, 2)));
end
FreqsCareOverall = [FreqsCareOverall Enc.'];

%Scale Frequencies
%MotionalFreqsInside = [MotionalFreqsInside(:,1)*G.ScaleX MotionalFreqsInside(:,2:8)];
%MotionalFreqsOutside = [MotionalFreqsOutside(:,1)*G.ScaleX MotionalFreqsOutside(:,2:8)];
%MotionalFreqs = [MotionalFreqs(:,1)*G.ScaleX MotionalFreqs(:,2:8)];
%FreqsCare = [FreqsCare(:,1)*G.ScaleX FreqsCare(:,2:8)];
FreqsCareOverall = [FreqsCareOverall(:,1)*G.ScaleX FreqsCareOverall(:,2:8)];
Detuning = Detuning*G.ScaleX;

%Find the strongest transition's coefficient
MaxClebschs = max(FreqsCareOverall(:, 6));

%% Plot all frequencies
fig = figure(1);
ax = gca;
hold on;

%j and k iterates the number of encoded transitions plotted and the number
%of other transitions plotted respectively
j = 0;
k = 0;
for i = 1:length(FreqsCareOverall)
    Trans = FreqsCareOverall(i, :);
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
    LeftBound = abs(min(FreqsCareOverall(1:Levels,1))) - G.GraphOverShoot;
    RightBound = abs(max(FreqsCareOverall(1:Levels,1))) + G.GraphOverShoot;
    if abs(Trans(1)) > LeftBound && ...
            abs(Trans(1)) < RightBound
        [Plot, Line, Text, Area] = PlotTransition_V2(Trans, Color, MaxClebschs, Detuning);
    end
end

%% Touch up the graph
ax.XLim = [LeftBound RightBound];
Legend = sprintf(...
    'Encoded: Blue/Purple\nOther: Red/Orange\nLaserSweep: Shaded Areas\nIrrelevant: Grey\nMotional Sidebands: White Arrow');
LegendXPosition = ((max(FreqsCareOverall(1:Levels,1)) + min(FreqsCareOverall(1:Levels,1)))/2 + G.GraphOverShoot/2);
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