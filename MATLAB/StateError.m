Rabi = 0:.1:1000;
Rabi = Rabi.*1e-3;
Detuning = 0:.001:4;
Detuning = Detuning.';
DetuningMat = repmat(Detuning, 1, length(Rabi));
RabiMat = repmat(Rabi, length(Detuning), 1);

%Theta = 1/2*atan(RabiMat./DetuningMat);
%Initial adiabatic state error based on detuning not being infinite
StateDetuningError = sin(1/2*atan(RabiMat./DetuningMat)).^2;
Prob = 1 - StateDetuningError;
Prob(Prob<.9) = -inf;
h = pcolor(Detuning, Rabi, Prob.');
set(h, 'EdgeColor', 'none');
cb = colorbar;
colormap(hot(4096));