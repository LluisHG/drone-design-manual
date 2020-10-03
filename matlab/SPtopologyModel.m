function [eff,Pout,Pin,I1,I2] = SPtopologyModel(L1,L2,f,Zs,ZL,Vamp,R1,R2,C1,C2,M)

w = 2*pi*f;             % Angular frequency [rad/s]

% C2 = L2/ZL*1/(R2+ZL);

fres = 1/(2*pi*sqrt(C1*L1));

Z1 = Zs+R1+1i*w*L1-1i./(w*C1);
modZ1 = abs(Z1);

Z2 = R2+1i*w*L2+1./(1./ZL+1i*w*C2);
modZ2 = abs(Z2);

ZR = w.^2.*M.^2./Z2;
modZR = abs(ZR);

Zeq = Z1+ZR;
modZeq = abs(Zeq);
argZeq = angle(Zeq);

I1 = Vamp./modZeq;
I1eff = I1/sqrt(2);

I2 = w.*M.*I1./modZ2;
I2eff = I2/sqrt(2);

V2 = abs(ZL./(1+1i*w*C1*ZL)).*I2eff;
Iload = V2/ZL;

powerfactor = cos(argZeq);
Pin = Vamp/sqrt(2).*I1eff.*cos(argZeq);
Pout = Iload.^2*ZL;
eff = (Pout./Pin)*100;

figure;
semilogx(f/fres,modZeq,'r','linewidth',2);
hold on
semilogx(f/fres,imag(Zeq),'Color',[0.2 0.8 0.4],'linewidth',2);
semilogx(f/fres,real(Zeq),'k','linewidth',2);
xlabel('Normalized frequency (f/f_0)','FontSize',17)
ylabel('Impedance, \Omega','FontSize',17)
set(gcf,'color','white')
legend('Z_{eq}','X_{eq}','R_{eq}','Location','Northwest')
legend boxoff
axis([10^(-1) 5e1 -1000 1500])
plot([min(f)/fres, max(f)/fres],[0,0],'k--')

end