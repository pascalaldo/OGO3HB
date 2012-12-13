function [Vlv plv] = circulation()
%
V0      = 0;		% [ml]  - intercept volume
Epas    = 0.007;    % [kPa/ml] - passive elastance 
Emax    = 0.3;      % [kPa/ml] - active elastance  
tact    = 500;      % [ms]  - duration activation
tcycle  = 1000;     % [ms]  - duration cycle
%
% vessels
%
Cart    = 20;		% [ml/kPa] - compliance arterial system
Cven    = 1000;		% [ml/kPa] - compliance venous system
%
Vblood  = 5000;		% [ml] - total blood volume;
Vven0   = 3000;		% [ml] - venous blood volume at zero pressure
Vart0   = 500;      % [ml] - arterial blood volume at zero pressure
%
Rart     = 5;		% [kPa.ms/ml] - characteristic arterial impedance
Rp      = 120;		% [kPa.ms/ml] - peripheral resistance
Rven    = 1;		% [kPa.ms/ml] - venous resistance
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
plv(j)   = varelast(Emax,Epas,V0,Vlv(j),tact,tcycle,t(j));
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

plv(j)   = varelast(Emax,Epas,V0,Vlv(j),tact,tcycle,t(j));
part(j)  = (Vart(j)-Vart0)/Cart;	   
pven(j)  = (Vven(j)-Vven0)/Cven; 	    

qav(j)  = max(0,(plv(j)-part(j))/Rart);    
qmv(j)  = max(0,(pven(j)-plv(j))/Rven);     
qp(j)   = (part(j)-pven(j))/Rp;	   

end
Vlv = Vlv(tcycle*(ncycle-1):tcycle*ncycle);
plv = plv(tcycle*(ncycle-1):tcycle*ncycle);
end