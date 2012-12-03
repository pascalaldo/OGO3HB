function CreatePVLoop(tv, v, tp, p)
%CREATEPVLOOP Summary of this function goes here
%   Detailed explanation goes here
global debug;
debug = true;

figure(3);
slider = uicontrol('Style', 'slider',...
        'Min',-0.2,'Max',0.2,'Value',0,...
        'Units', 'pixels', 'Position', [0 0 200 20],...
        'Callback', @RefreshPlot);
    
    function RefreshPlot(~,~)
        tvo = tv+get(slider, 'Value');
        
        plv = PVloop.determinePressure(p);
        [tvn vn] = BloodPressure.EstimateVolume(tvo, v,tp);

        figure(3);
        plot(vn,p,'r-',vn,plv,'g-');
    end

RefreshPlot();
debug = false;

end

