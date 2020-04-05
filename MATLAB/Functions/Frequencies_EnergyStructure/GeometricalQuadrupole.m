addpath('DrosteEffect-BrewerMap-b6a6efc');
%Let's look at the geometrical dependence
%Setup a Phi matrix
Phi = 0:pi/5000:pi/2;
Gamma = (0:pi/5000:pi/2).';
%Pick q
figure;
q = 0;
Vals = QuadrupoleGeometricConstant(q, Phi, Gamma);
%colormap(brewermap(4000, 'BuPu'));
h = pcolor(180*Gamma/pi,180*Phi/pi,Vals.');
title('q = 0', 'Fontsize', 25);
xlabel('\gamma', 'Fontsize', 20);
ylabel('\phi', 'Fontsize', 20);
set(h, 'EdgeColor', 'none')
%Add colorbar
%cb2 = colorbar;
%Set background color white
set(gcf,'color','white');
export_fig('Quad0.pdf', '-pdf', '-opengl')
figure;
q = 1;
Vals = QuadrupoleGeometricConstant(q, Phi, Gamma);
%colormap(brewermap(4000, 'BuPu'));
h = pcolor(180*Gamma/pi,180*Phi/pi,Vals.');
title('q = \pm 1', 'Fontsize', 25);
xlabel('\gamma', 'Fontsize', 20);
ylabel('\phi', 'Fontsize', 20);
set(h, 'EdgeColor', 'none')
%Set background color white
set(gcf,'color','white');
export_fig('Quad1.pdf', '-pdf', '-opengl')
figure;
q = 2;
Vals = QuadrupoleGeometricConstant(q, Phi, Gamma);
%colormap(brewermap(4000, 'BuPu'));
h = pcolor(180*Gamma/pi,180*Phi/pi,Vals.');
title('q = \pm 2', 'Fontsize', 25);
xlabel('\gamma', 'Fontsize', 20);
ylabel('\phi', 'Fontsize', 20);
set(h, 'EdgeColor', 'none')
%Set background color white
set(gcf,'color','white');
export_fig('Quad2.pdf', '-pdf', '-opengl')