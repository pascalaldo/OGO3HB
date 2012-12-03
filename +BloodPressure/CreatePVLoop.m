function CreatePVLoop(tv, v, tp, p)
%CREATEPVLOOP Summary of this function goes here
%   Detailed explanation goes here

[temp mint] = BloodPressure.DeterminePeak(tp,p);
lastindex = find(tv>mint,1,'first');
[tpn pn] = BloodPressure.Interpolate(tp, p,tv);

v = [v; v(1)];
pn = [pn; pn(1)];

figure(3);
plot(v,pn,'cx-','MarkerSize',8,'MarkerEdgeColor','k');
hold on;
plot(v(1:lastindex),pn(1:lastindex),'mx-','LineWidth',2,'MarkerSize',8,'MarkerEdgeColor','k');
axis([100 300 0 150]);
xlabel('Volume Linker Ventrikel (mL)');
ylabel('Veneuze Druk (mmHg)');
title('PV Loop Proefpersoon 27');
hold off;
end

