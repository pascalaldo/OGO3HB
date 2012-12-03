function CreatePVLoop(tv, v, tp, p)
%CREATEPVLOOP Summary of this function goes here
%   Detailed explanation goes here
global debug;
debug = true;

[temp mint] = BloodPressure.DeterminePeak(tp,p)
lastindex = find(tv>mint,1,'first')

figure(3);
    
    function RefreshPlot(~,~)        
        [tpn pn] = BloodPressure.EstimateVolume(tp, p,tv(1:lastindex));

        figure(3);
        plot(v(1:lastindex),pn,'r.-');
        axis([50 200 0 140]);
    end

RefreshPlot();
debug = false;

end

