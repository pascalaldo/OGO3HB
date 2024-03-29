function [mt mpart mvlvs mvlv mplv] = Circulation(par, nipar)
global showplots;
% par(1) = V0

%
%      ---- Rven ----+---- Rart-------
%      |             |               |
%      |       E(t) ===              |
%      |             |               |
%      |             0               |
%      |                             |
%      + --------  Rper -------------+
%      |                             |
%     === Cven                 Cart ===
%      |                             |
%      0                             0
%
% >>> parameters
%
% ventricle
%
% plv = (Epas + act*(Emax-Epas))(Vlv-V0)
%
lp = length(par);
    function ret = ep(nr, defaultvalue)
        if lp>(nr-1)
            ret = par(nr);
        else
            ret = defaultvalue;
        end
    end

V0      = ep(1,0);		% [ml]  - intercept volume
Epas    = ep(2,0.007);    % [kPa/ml] - passive elastance 
Emax    = ep(3,0.3);      % [kPa/ml] - active elastance  
tact    = nipar(1);      % [ms]  - duration activation
tcycle  = nipar(2);     % [ms]  - duration cycle
%
% vessels
%
Cart    = nipar(6);		% [ml/kPa] - compliance arterial system
Cven    = 1000;%ep(4,1000);		% [ml/kPa] - compliance venous system
%
Vblood  = nipar(3);             % [ml] - total blood volume;
Vven0   = 0.5*nipar(3);          % [ml] - venous blood volume at zero pressure
Vart0   = 0.1*nipar(3);       % [ml] - arterial blood volume at zero pressure
%
Rart    = nipar(5);		% [kPa.ms/ml] - characteristic arterial impedance
Rp      = nipar(4);		% [kPa.ms/ml] - peripheral resistance
Rven    = 1;%ep(5,1);		% [kPa.ms/ml] - venous resistance
%
% discretisation

dt      = 1.;		 % [ms] - time step
ncycle  = 10;         % [-] - number of cycles
ninc    = ncycle*tcycle/dt;   % [-] - number of increments

% <<< parameters
%
% increment 1 : initialisation
%
j        = 1;			% [-]   - counter increment
t(j)     = 0;			% [ms]  - time increment
%
Vlv(j)   = 1/Epas;
plv(j)   = Model.varelast(Emax,Epas,V0,Vlv(j),tact,tcycle,t(j));
%
part(j)  = 13;		                % [kPa] - arterial pressure
Vart(j)  = Vart0+part(j)*Cart;	    % [ml] - arterial blood volume
Vven(j)  = Vblood-Vlv(j)-Vart(j);	% [ml] - venous blood volume 
pven(j)  = (Vven(j)-Vven0)/Cven; 	% [kPa] - left atrial pressure
%
qav(j)   = max(0,(plv(j)-part(j))/Rart);     % [ml/ms] - aortic flow
qmv(j)   = max(0,(pven(j)-plv(j))/Rven);    % [ml/ms] - mitral flow
qp(j)    = (part(j)-pven(j))/Rp;	        % [ml/ms] - peripheral flow
%
% next increments
%
while(j<=ninc)
    %
    j       = j+1;
    t(j)    = t(j-1)+dt;

    dVlvdt  = qmv(j-1)-qav(j-1);
    dVartdt = qav(j-1)-qp(j-1);

    Vlv(j)  = Vlv(j-1)+dVlvdt*dt;
    Vart(j) = Vart(j-1)+dVartdt*dt;
    Vven(j) = Vblood-Vlv(j)-Vart(j);

    plv(j)   = Model.varelast(Emax,Epas,V0,Vlv(j),tact,tcycle,t(j));
    part(j)  = (Vart(j)-Vart0)/Cart;	   
    pven(j)  = (Vven(j)-Vven0)/Cven; 	    

    qav(j)  = max(0,(plv(j)-part(j))/Rart);    
    qmv(j)  = max(0,(pven(j)-plv(j))/Rven);     
    qp(j)   = (part(j)-pven(j))/Rp;	   

end

%% Plotting
%
if showplots
figure;
subplot(2,2,1)
hold on
plot(t,plv,t,part,t,pven,'linewidth',2)
xlabel('time [ms]','FontSize',16);
ylabel('pressure [kPa]','FontSize',16);
legend('p_{lv}','p_{art}','p_{ven}')
subplot(2,2,2)
hold on
plot(t,qav,t,qmv,'linewidth',2)
xlabel('time [ms]','FontSize',16);
ylabel('flow [ml/ms]','FontSize',16);
legend('q_{av}','q_{mv}')
subplot(2,2,3)
hold on
plot(t,Vlv,'linewidth',2)
xlabel('time [ms]','FontSize',16);
ylabel('volume [ml]','FontSize',16);
subplot(2,2,4)
hold on
plot(Vlv,plv,'linewidth',2)
xlabel('volume [ml]','FontSize',16);
ylabel('pressure [kPa]','FontSize',16);
%
end

tcycle = nipar(2);
vtimeshift = round(par(end)*1000);

% Find the last cycle
lcib = (find(t > (max(t)-(2*tcycle)), 1, 'first')-1);
lcie = (find(t > (max(t)-tcycle), 1, 'first')-1);
mt = t(lcib:lcie);
mt = (mt-mt(1))./1000; % Convert from ms to s
mpart = part(lcib:lcie).*7.50061683; % Convert from kPa to mmHg
mplv = plv(lcib:lcie).*7.50061683; % Convert from kPa to mmHg
mvlv = Vlv(lcib:lcie);
mvlvs = Vlv((lcib+vtimeshift):(lcie+vtimeshift));

end

