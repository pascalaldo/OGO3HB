function [c bw] = DetermineAxis(bw)
%DETERMINEAXIS determines the long axis of the freehand drawing
skel = bwulterode(bw);
tot = sum(sum(skel));
if tot <= 1
    c = [1 0];
    disp('Warning: Drawing is too round, using random axis');
    return;
end
datap = zeros([sum(sum(skel)) 2]);
cnt = 1;
sz = size(skel);
for iy=1:sz(1)
    for ix=1:sz(2)
        if skel(iy,ix)
            datap(cnt,1) = ix;
            datap(cnt,2) = iy;
            cnt = cnt+1;
        end
    end
end
afit = fit(datap(:,1),datap(:,2),'poly1');
c = coeffvalues(afit);
if c(1) > 1
    disp('Note: Rotating image for better results');
    bw = bw';
    c = [(1/c(1)) (c(2)/c(1))];
end
end