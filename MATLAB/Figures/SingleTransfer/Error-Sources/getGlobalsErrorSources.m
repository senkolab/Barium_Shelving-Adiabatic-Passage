function G = getGlobalsErrorSources()
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
G.DephasingExp = 2*pi^2;
G.LZErrorOn = true;
G.LZExp = pi^2;
G.OffResErrorOn = true;
G.MotionalErrorOn = true;
G.DecayTimeErrorOn = true;
G.Thresh = 0.975;

%% Energy level Information
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