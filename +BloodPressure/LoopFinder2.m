function [t p] = LoopFinder2(time, values, pointInTime)
time = time-min(time)';
values = values';
d = diff(values);
sd = std(d);

ind = find(time > pointInTime, 1, 'first');

prevminslope = ind+1-find(fliplr(d(1:ind)) < -sd,1,'first');
prevmaxslope = prevminslope-1+find(d(prevminslope:end) > 2*sd,1,'first');
prevmin = prevmaxslope+1-find(fliplr(d(prevminslope:prevmaxslope)) < 0,1,'first');

nextminslope = ind-1+find(d(ind:end) < -sd,1,'first');
nextmaxslope = nextminslope-1+find(d(nextminslope:end) > 2*sd,1,'first');
nextmin = nextmaxslope+1-find(fliplr(d(nextminslope:nextmaxslope)) < 0,1,'first');

%% Plotting
%
figure(2);
plot(time(1:(end-2)),diff(d)*20,time(1:(end-1)),d*20,time,values,[0 max(time)],40*[sd sd],[0 max(time)],-20*[sd sd]);
hold on;
plot([time(ind) time(ind)], [-100 200],'r-',[time(prevminslope) time(prevminslope)], [-100 200],'c:',[time(prevmaxslope) time(prevmaxslope)], [-100 200],'g:',[time(prevmin) time(prevmin)], [-100 200],'b-');
plot([time(nextminslope) time(nextminslope)], [-100 200],'c:',[time(nextmaxslope) time(nextmaxslope)], [-100 200],'g:',[time(nextmin) time(nextmin)], [-100 200],'b-');
%

t = time(prevmin:nextmin);
t = t-t(1);
p = values(prevmin:nextmin);

end
