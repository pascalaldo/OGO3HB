function [x nipar] = FitModel(vt,v,hbt,hbp,ppnr)

%Determine tcycle and tact
[tcycle, tact] = Fit.DetermineTime(hbt,hbp);

%Determine vblood, vven and vart
bodylength = 1.80;
bodymass = 80;
[vblood] = Fit.DetermineBloodV(bodylength,bodymass);

%Determine Rp, Rart and Cart
[Rp Rart Cart] = Fit.DetermineRpRartCart(hbt,hbp,vt,v,ppnr);

x0 = [0 0.007 0.3 0];
xmin = [0 0 0 -0.500];
xmax = [100 0.1 3 0.500];

%Define new initial parameter list (nipar):
nipar = [tact tcycle vblood Rp Rart Cart];

%Define new parameter list with lsqnonlin
x = lsqnonlin(@(par)(Fit.ModelWrapper(vt,v,hbt,hbp,par,nipar)),x0,xmin,xmax);

% Difference using default parameters
[temp1 odp odv] = Fit.ModelWrapper(vt,v,hbt,hbp,x0,nipar);
% Difference using optimal parameters
[temp2 ndp ndv] = Fit.ModelWrapper(vt,v,hbt,hbp,x,nipar);

%figure(1);
%plot(abs(odp),'b:');
%hold on;
%plot(abs(ndp),'r-');
%hold off;

%figure(2);
%plot(abs(odv),'b:');
%hold on;
%plot(abs(ndv),'r-');
%hold off;

[oldt oldpart oldVlvs] = Model.Circulation(x0,nipar);
[newt newpart newVlvs newVlv newplv] = Model.Circulation(x,nipar);

f1 = figure(3);
plot(hbt,hbp,'g-',oldt,oldpart,'b:',newt,newpart,'r-');
saveas(f1,sprintf('FitResults\\%d\\part_%d.fig',ppnr,ppnr));
close(f1);

f2 = figure(4);
plot(vt+x(end),v,'g-',oldt,oldVlvs,'b:',newt,newVlvs,'r-');
saveas(f2,sprintf('FitResults\\%d\\v_%d.fig',ppnr,ppnr));
close(f2);

%x
%save('fit.mat','x','oldt','newt','oldt','oldpart','newpart','oldVlvs','newVlvs','newVlv','newplv','nipar');
[pv1p pv1v] = BloodPressure.CreateBasicPVLoop(vt+x(end),v,hbt,hbp,1);
[pv2p pv2v] = BloodPressure.CreateBasicPVLoop(newt',newVlv',newt',newplv',2);

f3 = figure(5);
plot(pv2v,pv2p,'b:',pv1v,pv1p,'r-');
saveas(f3,sprintf('FitResults\\%d\\pv_%d.fig',ppnr,ppnr));
close(f3);

save(sprintf('FitResults\\%d\\fit_%d.mat',ppnr,ppnr),'x','oldt','newt','oldt','oldpart','newpart','oldVlvs','newVlvs','newVlv','newplv','nipar');

display ('The following list contains: V0, Epas, Emax')

end