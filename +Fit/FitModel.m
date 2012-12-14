function FitModel(vt,v,hbt,hbp)

%Determine tcycle and tact and exert a correction from [s] to [ms]
[tcycle, tact] = DetermineTime(hbt,hbp);
tact = tact*1000;
tcycle = tcycle*1000;

%Define initial parameter list following the pattern: [V0, tact, tcycle]
x0 = [0,tact,tcycle];

%Define new parameter list with lsqnonlin
x = lsqnonlin(@(par)(Fit.ModelWrapper(vt,v,hbt,hbp,par)),x0);

% Difference using default parameters
[temp1 odp odv] = Fit.ModelWrapper(vt,v,hbt,hbp,[]);
% Difference using optimal parameters
[temp2 ndp ndv] = Fit.ModelWrapper(vt,v,hbt,hbp,x);

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

display ('The following list contains: [V0, tact, tcycle]')
x
end