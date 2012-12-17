function FitModel(vt,v,hbt,hbp)

%Determine tcycle and tact
[tcycle, tact] = Fit.DetermineTime(hbt,hbp);

%Determine vblood, vven and vart
bodylength = 1.80;
bodymass = 80;
[vblood] = Fit.DetermineBloodV(bodylength,bodymass);

%Determine Rp, Rart and Cart
[Rp Rart Cart] = Fit.DetermineRpRartCart(hbt,hbp,vt,v);

x0 = [0 0.007 0.3 0 0];
xmin = [0 0 0 -0.1 -0.3];
xmax = [100 0.1 3 0.1 0.3];

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

[oldt oldpart oldVlv] = Model.Circulation(x0,nipar);
[newt newpart newVlv newplv] = Model.Circulation(x,nipar);

figure(3);
lci = (find(oldt > (max(oldt)-tcycle), 1, 'first')-1);
plot(hbt.*1000,hbp./7.50061683,'g-',oldt(lci:end)-oldt(lci),oldpart(lci:end),'b:',newt(lci:end)-newt(lci)+(x(end-1)*1000),newpart(lci:end),'r-');

figure(4);
plot(vt.*1000,v,'g-',oldt(lci:end)-oldt(lci),oldVlv(lci:end),'b:',newt(lci:end)-newt(lci)+(x(end)*1000),newVlv(lci:end),'r-');

x
save('fit.mat','x','lci','oldt','newt','oldt','oldpart','newpart','oldVlv','newVlv','newplv','nipar');
[pv1p pv1v] = BloodPressure.CreatePVLoop(vt,v,hbt,hbp,1);
[pv2p pv2v] = BloodPressure.CreateBasicPVLoop((newt(lci:end)-newt(lci))',newVlv(lci:end)',(newt(lci:end)-newt(lci))',newplv(lci:end)'.*7.50061683,2);

figure(5);
plot(pv2v,pv2p,'b:',pv1v,pv1p,'r-');

display ('The following list contains: V0, Epas, Emax')

end