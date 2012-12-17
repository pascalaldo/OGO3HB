function FitModel(vt,v,hbt,hbp)

%Determine tcycle and tact
[tcycle, tact] = Fit.DetermineTime(hbt,hbp);

%Determine vblood, vven and vart
bodylength = 1.80;
bodymass = 80;
[vblood] = Fit.DetermineBloodV(bodylength,bodymass);

%Determine Rp, Rart and Cart
[Rp Rart Cart] = Fit.DetermineRpRartCart(hbt,hbp,vt,v);

x0 = [0 0.007 0.3 1000 1 0];
xmin = [0 0 0 0 0 -0.500];
xmax = [100 0.1 3 3000 5 0.500];

%Define new initial parameter list (nipar):
nipar = [tact tcycle vblood Rp Rart Cart];

%Define new parameter list with lsqnonlin
x = lsqnonlin(@(par)(Fit.ModelWrapper(vt,v,hbt,hbp,par,nipar)),x0,xmin,xmax);

% Difference using default parameters
[temp1 odp odv] = Fit.ModelWrapper(vt,v,hbt,hbp,x0,nipar);
% Difference using optimal parameters
[temp2 ndp ndv] = Fit.ModelWrapper(vt,v,hbt,hbp,x,nipar);

figure(1);
plot(abs(odp),'b:');
hold on;
plot(abs(ndp),'r-');
hold off;

figure(2);
plot(abs(odv),'b:');
hold on;
plot(abs(ndv),'r-');
hold off;

[oldt oldpart oldVlvs] = Model.Circulation(x0,nipar);
[newt newpart newVlvs newVlv newplv] = Model.Circulation(x,nipar);

figure(3);
plot(hbt,hbp,'g-',oldt,oldpart,'b:',newt,newpart,'r-');

figure(4);
plot(vt+x(end),v,'g-',oldt,oldVlvs,'b:',newt,newVlvs,'r-');

x
save('fit.mat','x','oldt','newt','oldt','oldpart','newpart','oldVlvs','newVlvs','newVlv','newplv','nipar');
[pv1p pv1v] = BloodPressure.CreatePVLoop(vt+x(end),v,hbt,hbp,1);
[pv2p pv2v] = BloodPressure.CreateBasicPVLoop(newt',newVlv',newt',newplv',2);

figure(5);
plot(pv2v,pv2p,'b:',pv1v,pv1p,'r-');

display ('The following list contains: V0, Epas, Emax')

end