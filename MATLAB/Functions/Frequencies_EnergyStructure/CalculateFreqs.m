function [Freqs, FreqsMotional] = CalculateFreqs(I, J, Jp, Carrier, Energies, EnergiesP, Fs, Fps, GeomOrientation, Abs, MotionalFreq)
%This function finds all of the relevant energy levels - all those that
%could be driven by a particular geometrical orientation
%The outputs are these transitions listed as follows:
%1: frequency of the transition
%2:5: F, mF, F', mF'
%6: Clebschs Gordan coefficient
%The inputs are the atomic information I, J, Jp, the laser carrier
%frequency, the energy levels involved in the transition, the F numbers for
%this transition, the geometric orientation of the transition
%The final input is whether or not you want the absoluate value or the
%signed frequencies

%% Take care of Geometrical orientation functions
%XZ or Orthogonal. XZ suppresses \Delta m= +/- 1 transitions, Orthogonal
%suppresses \Delta m = 0, +/- 1 transitions, Average to just set all these
%equal to one
% GeomOrientation = "XZ";
if GeomOrientation == "XZ"
    Phi = pi/4;
    Gamma = 0;
elseif GeomOrientation == "Orthogonal"
    Phi = pi/2;
    Gamma = pi/2;
end
%Calculate geometric constants
if GeomOrientation == "Average"
    G0 = 1;
    G1 = 1;
    G2 = 1;
else
    G0 = QuadrupoleGeometricConstant(0, Phi, Gamma);
    G1 = QuadrupoleGeometricConstant(1, Phi, Gamma);
    G2 = QuadrupoleGeometricConstant(2, Phi, Gamma);
end

%% Generate the F and mF levels from Fs, Fsp
F = [];
mF = [];
for i=1:length(Fs)
    F = [F ones(1, 2*Fs(i)+1)*Fs(i)];
    mF = [mF -Fs(i):1:Fs(i)];
end
Fp = [];
mFp = [];
for i=1:length(Fps)
    Fp = [Fp ones(1, 2*Fps(i)+1)*Fps(i)];
    mFp = [mFp -Fps(i):1:Fps(i)];
end

%% Generate all of the frequency differences between all energy levels
FreqsLower = repmat(Energies, 1, length(EnergiesP));
FreqsUpper = repmat(EnergiesP, length(Energies), 1);
FreqsTransitions = FreqsUpper - FreqsLower + Carrier;
%Go through and pick out the relevant transitions from all of the
%transitions - these are those transitions that are allowed based on atomic
%rules and geometrical constraints from laser orientation and polarization
k = 0;
for i=1:length(mF)
    F0 = F(i);
    mF0 = mF(i);
    for j=1:length(mFp)
        F1 = Fp(j);
        mF1 = mFp(j);
        DeltaM = max(mF1, mF0) - min(mF1, mF0);
        if GeomOrientation == "XZ"
            if DeltaM > 2 || DeltaM == 1
                continue
            end
        elseif GeomOrientation == "Orthogonal"
            if DeltaM ~=2
                continue
            end
        end
        k = k + 1;
        RelevantFreqs(k,1:5) = [FreqsTransitions(i, j) F0 mF0 F1 mF1];
    end
end
if Abs
    RelevantFreqs = [abs(RelevantFreqs(:, 1)) RelevantFreqs(:, 2:5)];
end
%Order the matrix of relevant frequencies by absolute value of frequency
[temp, order] = sort(RelevantFreqs(:, 1));
Freqs = RelevantFreqs(order, :);

%% Calculate the strength coefficient for each transition
%Equation 2.64 in Brendan White's masters thesis
jSix123 = [2 Jp J];
for i = 1:length(Freqs)
    F0 = Freqs(i, 2);
    mF0 = Freqs(i, 3);
    F1 = Freqs(i, 4);
    mF1 = Freqs(i, 5);
    DeltaM = max(mF1, mF0) - min(mF1, mF0);
    mSix123 = [I, F0, F1];
    q = -(mF1 - mF0);
    J123 = [F0, 2, F1];
    Sum3j = 0;
    for j = -2:2
        M123 = [-mF0, j, mF1];
        Wigner3 = Wigner3j(J123, M123);
        if Wigner3 ~=0
            Wig3 = Wigner3;
        end
        if DeltaM == 0
            GG = G0;
        elseif DeltaM == 1
            GG = G1;
        elseif DeltaM == 2
            GG = G2;
        end
        Sum3j = Sum3j + Wigner3*GG;
    end
    Fpart = (-1)^F1*sqrt(2*F1 + 1);
    Wigner6 = Wigner6j(jSix123, mSix123);
    Clebschs(i, :) = [Fpart Wigner6 Wig3 GG Fpart*Wigner6*Sum3j];
end
Freqs = [Freqs Clebschs(:, 5)];
Freqs = Freqs(logical(Freqs(:, 6)), :);
%Add row for the motional order - zeroth order
Freqs = [Freqs zeros(size(Freqs, 1), 1)];

%Generate all motional sidebands up to 2nd order
FreqsMotional = [];
%Last column gives whether red, blue sideband and order
for i = -2:1:2
    if i == 0
        continue
    else
        FreqsMotional = [FreqsMotional; ...
            Freqs(:, 1) + i*MotionalFreq Freqs(:, 2:6) ...
            i*ones(length(Freqs), 1)];
    end
end
end