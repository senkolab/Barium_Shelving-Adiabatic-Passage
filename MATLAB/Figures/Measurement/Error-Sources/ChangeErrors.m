function G = ChangeErrors(G, Error)
if Error == "Prep"
    G.DetuningErrorOn = true;
    G.DephasingErrorOn = false;
    G.LZErrorOn = false;
    G.OffResErrorOn = false;
    G.DecayTimeErrorOn = false;
elseif Error == "OffRes"
    G.DetuningErrorOn = false;
    G.DephasingErrorOn = false;
    G.LZErrorOn = false;
    G.OffResErrorOn = true;
    G.DecayTimeErrorOn = false;
elseif Error == "Adiabadicity"
    G.DetuningErrorOn = false;
    G.DephasingErrorOn = false;
    G.LZErrorOn = true;
    G.OffResErrorOn = false;
    G.DecayTimeErrorOn = false;
elseif Error == "Dephasing"
    G.DetuningErrorOn = false;
    G.DephasingErrorOn = true;
    G.LZErrorOn = false;
    G.OffResErrorOn = false;
    G.DecayTimeErrorOn = false;
elseif Error == "Decay"
    G.DetuningErrorOn = false;
    G.DephasingErrorOn = false;
    G.LZErrorOn = false;
    G.OffResErrorOn = false;
    G.DecayTimeErrorOn = true;
end
end