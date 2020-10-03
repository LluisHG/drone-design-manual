clear all
close all
clc

% //////////////////////////
% ///                    ///
% ///   Power Analysis   ///
% ///                    ///
% //////////////////////////

% The power received by the RX mainly depends upon the separation
% between the coils or the mutual coupling. Two coils are said to be linked
% inductively, when the primary coil excited by the external source is able
% to have a magnetic field induced in the secondary coil, producing a
% voltage across its terminals as a result.

% Define Global Variables
global u0 rhoC

u0 = 4*pi*1e-7;     % Permeability of air [H/m]
rhoC = 1.71e-8;     % Copper Resistivity [Ohm*m]

%% Coil Parameters and Theoretical Inductance Values
R1 = 0.5;
R2 = 0.5;
L1 = 10e-6;
L2 = 10e-6;
C1 = 2e-9;
C2 = 2e-9;
M = 3e-6;

fres = 1/(2*pi*sqrt(L1*C1));
%% Define system parameters
Vs = 5;
Vamp = Vs*sqrt(2);
Zs = 50;
ZL = 100;
%% Operating frequency
f = 1:1000:0.5e8;
% f = fres;
% f = 1.05e6:1e3:1.2e7;
% f = 1.064e6;
%% Secondary Capacitor in Series

% Primary Capacitor in SERIES / Secondary Capacitor in SERIES
[eff,Pout,Pin,I1,I2] = SStopologyModel(L1,L2,f,Zs,ZL,Vamp,R1,R2,C1,C2,M);

% Primary Capacitor in SERIES / Secondary Capacitor in PARALLEL
[eff2,Pout2,Pin2,I12,I22] = SPtopologyModel(L1,L2,f,Zs,ZL,Vamp,R1,R2,C1,C2,M);

% Primary Capacitor in PARALLEL / Secondary Capacitor in SERIES
[eff3,Pout3,Pin3,I13,I23] = PStopologyModel(L1,L2,f,Zs,ZL,Vamp,R1,R2,C1,C2,M);

% Primary Capacitor in PARALLEL / Secondary Capacitor in PARALLEL
[eff4,Pout4,Pin4,I14,I24] = PPtopologyModel(L1,L2,f,Zs,ZL,Vamp,R1,R2,C1,C2,M);

close all

figure;
semilogx(f/fres,eff,'r','linewidth',1.5);
hold on
semilogx(f/fres,eff2,'y','linewidth',1.5);
semilogx(f/fres,eff3,'Color',[0.2 0.8 0.4],'linewidth',1.5);
semilogx(f/fres,eff4,'Color',[0.0 0.2 1.0],'linewidth',1.5);

xlabel('Normalized frequency (f/f_0)','FontSize',17)
ylabel('Efficiency, %','FontSize',17)
set(gcf,'color','white')
axis([10^(-2) 4e1 0 30])
legend('SS','SP','PS','PP');
legend('PS','PP');
legend('SS','SP');
legend boxoff

% close all

figure;
semilogx(f/fres,Pout,'r','linewidth',1.5);
hold on
semilogx(f/fres,Pout2,'y','linewidth',1.5);
semilogx(f/fres,Pout3,'Color',[0.2 0.8 0.4],'linewidth',1.5);
semilogx(f/fres,Pout4,'Color',[0.0 0.2 1.0],'linewidth',1.5);

xlabel('Normalized frequency (f/f_0)','FontSize',17)
ylabel('Output Power, W','FontSize',17)
set(gcf,'color','white')
axis([10^(-1) 10^1 0 0.12])
legend('SS','SP','PS','PP');
legend boxoff