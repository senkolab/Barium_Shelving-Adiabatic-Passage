function [Geom, Carrier, Det, LineW, F] = getVarGlobalsPop
global GeomOrientation;
Geom = GeomOrientation;
global CarrierFreq;
Carrier = CarrierFreq;
global Detuning;
Det = Detuning;
global Linewidth;
LineW = Linewidth;
global Fidelity;
F = Fidelity;
end