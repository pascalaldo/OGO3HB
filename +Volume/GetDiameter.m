function [d d1 d2] = GetDiameter(x,y,a2,data_shape1,f1,dddx2)
%GETDIAMTERE calculates the ventricle diameter
% Start at the long axis of the free hand drawing and calculate the
% distance to the edge of the ventricle

sz = size(data_shape1);
% Look to the left
i = 1;
% Find the first point that is in the freehand drawing
while x-i > 0
    if data_shape1(min(sz(1),max(1,round(-a2*i+y))), round(x-i)) == 1
        break;
    end
    i = i+1;
end
istart = i;
while x-i > 0
    if data_shape1(min(sz(1),max(1,round(-a2*i+y))), round(x-i)) == 0
        break;
    end
    i = i+1;
end
i = i-istart;
d1 = f1*i*dddx2; %sqrt((f1*-a2*i)^2+(f1*i)^2);

% Look to the right
j = 1;
% Find the first point that is in the freehand drawing
while x+j < sz(2)
    if data_shape1(min(sz(1),max(1,round(a2*j+y))), round(x+j)) == 1
        break;
    end
    j = j+1;
end
jstart = j;
% Find the first point that is zero
while x+j < sz(2)
    if data_shape1(min(sz(1),max(1,round(a2*j+y))), round(x+j)) == 0
        break;
    end
    j = j+1;
end
j = j-jstart;
d2 = f1*j*dddx2; %sqrt((f1*a2*j)^2+(f1*j)^2);

% Calculate the total diameter
d = d1+d2;
end

