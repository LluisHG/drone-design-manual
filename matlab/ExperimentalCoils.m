
close all
clear all
clc

global rhoC

select = input('--> Press 1... L-R vs. f\n--> Press 2... Q vs. f\n--> Press 3... Q COILS\n--> Press 4... Resistance Comparison\n');
if select~=3
prompt = 'MODEL SELECTION     Enter key\nModel Atx            a1\nModel Arx            a2\nModel Btx            b1\nModel Brx            b2\nModel Ctx            c1\nModel Crx            c2\nModel D1             d1\nModel D2             d2\n';
key = input(prompt,'s');

if strcmp(key,'a1') == 1; modelo = 'modeloATX'; N = 8; Radius = 0.05; end
if strcmp(key,'a2') == 1; modelo = 'modeloARX'; N = 8; Radius = 0.05; end
if strcmp(key,'b1') == 1; modelo = 'modelo0TX'; N = 19; Radius = 0.02; end
if strcmp(key,'b2') == 1; modelo = 'modelo0RX'; N = 19; Radius = 0.02;end
if strcmp(key,'c1') == 1; modelo = 'modelo00TX'; N = 10;Radius = 0.04;end
if strcmp(key,'c2') == 1; modelo = 'modelo00RX'; N = 10;Radius = 0.04;end
if strcmp(key,'d1') == 1; modelo = 'modeloCobreGrande'; N = 7;Radius =0.04; end
if strcmp(key,'d2') == 1; modelo = 'modeloCobrePequena'; N = 11; Radius = 0.015;end
end

%% Inductance and Resistance w.r.t Frequency
if select == 1
    for i=1:1
        Coil = LRF(modelo);
        f = Coil(:,1);
        L = Coil(:,2)*1e6;
        R = Coil(:,3);
        Q = Coil(:,4);
        [ax,p1,p2] = plotyy(f,L,f,R,'semilogx','semilogx');
        
        % Plots
        xlabel(ax(1),'Frequency, Hz','FontSize',20)
        ylabel(ax(1),'Inductance, \muH','FontSize',20)
        ylabel(ax(2),'Resistance, \Omega','FontSize',20)
        set(gcf,'color','white')
        set(ax(1),'fontsize',18)
        set(ax(2),'fontsize',18)
        set(p1,'LineWidth',2)
        set(p2,'LineWidth',2)
        
%         set(ax(2),'YTick',[0.05 0.1 0.15]);
    end
end

%% Q-Factor w.r.t Frequency
if select == 2
    for i=1:1
        Coil = LRF(modelo);
        f = Coil(:,1);
        L = Coil(:,2)*1e6;
        R = Coil(:,3);
        Q = 1e-6*2*pi*f.*L./R;
        
        % Plots
        plot(f,Q,'LineWidth',2)
        xlabel('Frequency, Hz','FontSize',17)
        ylabel('Q factor','FontSize',17)
        set(gcf,'color','white')
        set(gca,'fontsize',15)
        grid on
    end
end

%% All Q-Factors
if select == 3
C = {[1 .8 0],[1 .8 0],'r','r','k','k',[1 .6 .2],[1 .6 .2]};
figure    
for i=1:8
    % Type: 1-->Tx / 0-->Rx
    if i == 1; modelo = 'modeloATX'; type = 1; end
    if i == 2; modelo = 'modeloARX'; type = 0; end
    if i == 3; modelo = 'modelo0TX'; type = 1; end
    if i == 4; modelo = 'modelo0RX'; type = 0; end
    if i == 5; modelo = 'modelo00TX'; type = 1; end
    if i == 6; modelo = 'modelo00RX'; type = 0; end
    if i == 7; modelo = 'modeloCobreGrande'; type = 2; end
    if i == 8; modelo = 'modeloCobrePequena'; type = 2; end
    Coil = LRF(modelo);
    f = Coil(:,1);
    L = Coil(:,2)*1e6;
    R = Coil(:,3);
    Q = 1e-6*2*pi*f.*L./R;
    f = f/1e6;
    if type == 1
        plot(f,Q,'LineWidth',2,'color',C{i})
    elseif type == 0
        plot(f,Q,'LineWidth',1,'color',C{i})
    end
    hold on
end
xlabel('Frequency, MHz','FontSize',17)
ylabel('Q factor','FontSize',17)
set(gcf,'color','white')
set(gca,'fontsize',15)
grid on
axis([0 2.2 0 200])
legend('Model A_{Tx}','Model A_{Rx}','Model B_{Tx}','Model B_{Rx}','Model C_{Tx}','Model C_{Rx}','Model D1','Model D2','Location','southeast')
end

if select == 4
    Coil = LRF(modelo);
        f = Coil(:,1);
        L = Coil(:,2)*1e6;
        R = Coil(:,3);
        Q = Coil(:,4);
        % Select wire diameter
        if strcmp(key,'d1') == 1 || strcmp(key,'d2') == 1
            D = 1e-3;
        else
            D = 0.597e-3;
        end
        
        rhoC = 1.68e-8;
        frequency = 1e4:1e3:1e7;
        lth1=2*pi*Radius*N;
        S = pi*(D^2)/4;
        
        for j=1:length(frequency)
            Rac(j) = AC_Resistance(lth1,S,D,frequency(j),N);
        end
        
        % Plots
        semilogx(f,R,frequency,Rac,'LineWidth',2);
        xlabel('Frequency, Hz','FontSize',17)
        ylabel('Resistance, \Omega','FontSize',17)
        set(gcf,'color','white')
        set(gca,'fontsize',15)
        legend('Experimental','Theoretical','Location','northwest')
        legend boxoff
        axis([0 1e7 0 4])
end
    
