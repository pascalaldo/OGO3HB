function [xi yi] = EstimateVolume(t,v, points)
%PLOTVOLUME Summary of this function goes here
%   Detailed explanation goes here
global debug;

xi = points;
yi = interp1(t,v,xi,'linear');

if debug
    figure(2);
    plot(t,v,'r.',xi,yi,'b-');
end

end
