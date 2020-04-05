function [G] = QuadrupoleGeometricConstant(q, phi, gamma)
if q == 0
    G = 1/2*abs(cos(gamma)*sin(2*phi));
elseif abs(q) == 1
    G = (1/sqrt(6))*abs(cos(gamma)*cos(2*phi) + 1i*sin(gamma)*cos(phi));
elseif abs(q) == 2
    G = (1/sqrt(6))*abs(1/2*cos(gamma)*sin(2*phi) + 1i*sin(gamma)*sin(phi));
end