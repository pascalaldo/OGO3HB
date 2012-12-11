function FitModel(vt,v,hbt,hbp)

x = lsqnonlin(@(par)(Fit.ModelWrapper(vt,v,hbt,hbp,1000,par)),0);

[odp odv] = Fit.ModelWrapper(vt,v,hbt,hbp,1000,[]);
[ndp ndv] = Fit.ModelWrapper(vt,v,hbt,hbp,1000,x);

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

