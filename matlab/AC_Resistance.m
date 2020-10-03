function [Rac,R_skin,R_proximity,R_dc] = AC_Resistance(lth1,S,d,f,N1)

global rhoC


R_dc = rhoC*lth1/S;                    % DC Resistance

R_skin = R_dc*(d*20.8*pi/rhoC.*...     % Skin effect Resistance
    f.^(1/2)*1e-9);

sigma = 6.74./sqrt(f);                 % Skin depth

eps = d./(2*sigma)*sqrt((pi*N1*d)/(N1*d));

R_proximity = R_dc*eps*((sinh(2*...   % Proximity effect Resistance
    eps)+sin(2*eps))/(cosh(2*eps)-...
    cos(2*eps)));

Rac = R_dc+R_skin+R_proximity;        % AC Resistance

end