function FitModel(vt,v,hbt,hbp)

x0 = [0];
x = lsqnonlin(@(par)(Fit.ModelWrapper(vt,v,hbt,hbp,1000,par)),x0);

% Difference using default parameters
[temp1 odp odv] = Fit.ModelWrapper(vt,v,hbt,hbp,1000,[]);
% Difference using optimal parameters
[temp2 ndp ndv] = Fit.ModelWrapper(vt,v,hbt,hbp,1000,x);

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

x

end

