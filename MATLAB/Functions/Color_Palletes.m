%Color pallete from blue to purple, 6 colors, colorblind
ColorsPuBu = [[158 188 218];[140 150 198];[140 107 177];[136 65 157];[129 15 124];[77 0 75]];
%Color pallette from Orange to Red, 5 colors, colorblind
ColorsOrRed = [[253 187 132];[252 141 89];[239 101 72];[215 48 31];[179 0 0];[127 0 0]];

hold on;
for i=1:10
    x = rand(2, 1);
    y = rand(2, 1);
    Color = ColorsPuBu(mod(i, 6) + 1, :)/255;
    plot(x, y, 'Color', Color)
end

%plot(x, y, 'Color', Color)