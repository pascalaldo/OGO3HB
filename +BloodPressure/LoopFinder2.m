function [t p] = LoopFinder2(time, values, pointInTime)
time = time-min(time);
plot(time(1:(end-2)),diff(diff(values))*20,time(1:(end-1)),diff(values)*20,time,values);
end

