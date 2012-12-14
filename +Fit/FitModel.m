function FitModel(vt,v,hbt,hbp)

%Determine tcycle and tact
[tcycle, tact] = DetermineTime(hbt,hbp);

%Determine vblood, vven and vart
bodylength = 1.80;
bodymass = 80;
[vblood] = DetermineBloodV(bodylength,bodymass);

x0 = [0,0.007,0.3];

%Define new initial parameter list (nipar):
nipar = [tact,tcycle,vblood];

%Define new parameter list with lsqnonlin
x = lsqnonlin(@(par)(Fit.ModelWrapper(vt,v,hbt,hbp,par,nipar)),x0);

% Difference using default parameters
[temp1 odp odv] = Fit.ModelWrapper(vt,v,hbt,hbp,[],nipar);
% Difference using optimal parameters
[temp2 ndp ndv] = Fit.ModelWrapper(vt,v,hbt,hbp,x,nipar);

figure(1);
plot(odp,'b:');
hold on;
plot(ndp,'r-');
hold off;

figure(2);
plot(odv,'b:');
hold on;
plot(ndv,'r-');
hold off;

%figure(3);
%plot(temp1,'b:');
%hold on;
%plot(temp2,'r-');
%hold off;

display ('The following list contains: V0, Epas, Emax')
x
end