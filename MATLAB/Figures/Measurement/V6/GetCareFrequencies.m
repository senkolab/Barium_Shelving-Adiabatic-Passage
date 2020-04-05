function [Freqs] = GetCareFrequencies(G, LevelG, LevelP, CarrierFreq, GeomOrientation)
%MoveEnc moves ground state encoded levels
%MoveEncP moves shelving state encoded levels
%1:2: tells which encodings are being moved
%3:4: tells what they are being moved to



% Here we'll add in the code to change Encoded to whatever we want based on
% hiding a transition. Each time we do any shelving, we need to beforehand
% decide if we're hiding anything, where we're hiding it, and then
% calculate all of the relevant frequencies based on that change. For
% deshelving, we'll change EncodedP instead. Need to structure this function
% so that it only gets relevant frequencies for a particular shelving/deshelving. 
% Setup so that enc goes to NaN when fluoresced. Have G contain the matrices 
% for where encodes states are, pass it onto getfreqs
% Store all states that don't contain the encoding as NaN until they
% contain it. To drive transitions other than the main ones, will have to
% make the Transition spectrum code have more than the Levels number of
% transitions. Also, should change from tag Encoding to tag Shelve
% Setup code to optimize all of this shuffling by literally going through all 
% possibilities and weighing how good they were - part of weight should be eta^n 
% Should also plan for the code
% printing all of the steps of the process. Possibly code that chooses
% which transitions to drive and hide in order to maximize fidelity. Beyond
% that, possibly make it so that we can shelve directly from the hidden
% state.

%Retrieve all of the relevant frequencies
[FreqsAbs, FreqsMot] = CalculateFreqs(G.I, G.J, G.Jp, CarrierFreq, ...
    G.EnergiesS12, G.EnergiesD52, G.Fs, G.Fps, GeomOrientation, true, G.MotionalFreq);
%Only add MotionalFreqs to FreqsCare if it's nonempty and this error is
%turned on
if ~isempty(FreqsMot) && G.MotionalErrorOn
    Freqs = [FreqsAbs; FreqsMot];
else
    Freqs = FreqsAbs;
end

%Go through and get the encoded transitions indices and also get all of 
%the transitions involving encoded energy levels
EncodedList = [];
Care = [];
k = 1;
%Only go through and look at the levels we shelve (the last, we don't)
for i = 1:size(LevelG, 1)
    EncodedList = [EncodedList find(all(Freqs(:, 2:5) == [LevelG(i, :) LevelP(i,:)], 2) & Freqs(:, 7) == 0)];
    Care = [Care find(all(Freqs(:, 2:3) == LevelG(i, :), 2) | all(Freqs(:,4:5) == LevelP(i, :), 2)).'];
end
%Get rid of duplicates
Care = unique(Care);
[a, index] = intersect(Care, EncodedList);
Care(index) = [];
%Get frequencies that care about, adding column for whether encoded or not
FreqsCareEncoded = [Freqs(EncodedList, :) ones(length(EncodedList), 1)];
FreqsCareOther = [Freqs(Care, :) zeros(length(Care), 1)];
Freqs = [FreqsCareEncoded;FreqsCareOther];

% After all the relevant frequencies have been picked out, we can calculate
% the overall error from driving this transition
end