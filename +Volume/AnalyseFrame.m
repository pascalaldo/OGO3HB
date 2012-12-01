function [I dd settings] = AnalyseFrame(frame1, frame2, settings)
%ANALYSEECHOS Calculate the volume of the left ventricle using echo images
%   [I dd] = AnalyseEchos(filenameLongAxis, filenameShortAxis, loadOld)
%   calculates the volume of the left ventricle using a echo image of the 
%   long axis (filenameLongAxis) and a image of the short axis of the
%   heart. loadOld is optional, when set true the function uses the data
%   stored in 'echodata.mat'. By default the value is false and the GUI is 
%   used to obtain new data.
%   The function returns the volume of the left ventricle (I) in mL. dd is
%   the difference in width of the chambre between both images (in cm).
%   Furthermore the function displays a 3D model of the ventricle.

%% Handle default arguments
if nargin < 3, settings = []; end

%% Load old data or launch GUI to create new data
data1 = GUI.Measure({frame1, frame2},1,settings);
if data1.skip, I = -1; dd = -1; return; end
data2 = GUI.Measure({frame1, frame2},2,settings);
if data2.skip, I = -1; dd = -1; return; end
d = struct('f1',data1.factor,'f2',data2.factor,'freehand',data1.shape,'ellipse',data2.shape,'coefficients',data1.coefficients,'section',data1.section,'type',data1.type);
settings = struct('type',data1.type,'refpos1',data1.refpos,'refpos2',data2.refpos,'refcm1',data1.refcm,'refcm2',data2.refcm,'ellipse',data2.shape);
clear data1 data2;

% Determine the size of the freehand drawing data
sz = size(d.freehand);

%% Short Axis Data
% Calculate short axis ellipse ratio
ellipse_size = d.f2.*[d.ellipse(3) d.ellipse(4)];
if d.type == 2
    % PSL view instead of AP4, so the width and height should have been
    % interchanged.
    ellipse_size = [ellipse_size(2) ellipse_size(1)];
end
ellipse_ratio = ellipse_size(1)/ellipse_size(2);

%% Long Axis Data
% Create the axis function of the freehand drawing
a1 = d.coefficients(1);
b1 = d.coefficients(2);
y1 = @(x)(a1*x+b1);

% Calculate the coefficients of the perpendicular function
a2 = -1/a1;
b2 = d.section(1,2)-a2*d.section(1,1);

% Calculate the distance covered by the lines y=a1*x+b1 and y=a2*x+b2 when
% x increases with 1.
dddx1 = sqrt(a1^2+1);
dddx2 = sqrt(a2^2+1);

%% Calculate Ventricle Diameters
% Walk down the center axis of the free hand drawing
xdata = [];
ydata = [];
k = 0;
while k < sz(2)
    kx = k;
    ky = y1(kx);
    [kdata(1) kdata(2) kdata(3)] = Volume.GetDiameter(kx,ky,a2,d.freehand,d.f1,dddx2);
    if kdata(1) > 0
        xdata = [xdata; kx*dddx1];
        ydata = [ydata; kdata(1)];
    end
    k = k+1;
end

% Close the ventricle at both sides
xdata = [min(xdata)-dddx1;xdata;max(xdata)+dddx1]+dddx1;
xdata = d.f2.*(xdata-min(xdata));
ydata = [0;ydata;0];

%% 3D Model
% Create a mesh of the ventricle
[X Y] = meshgrid(xdata', -10:.01:10);
Z = [];
area = [];
for i=1:length(xdata)
    if d.type == 1
        newz = (ydata(i)/2).*ellipse_ratio.*real(sqrt(1-((-10:.01:10)./(ydata(i)/2)).^2));
        Y(:,i) = max(min(Y(:,i), (ydata(i)/2)), -(ydata(i)/2)); % Cut off x-y plane outside the ventricle
    else
        newz = (ydata(i)/2).*real(sqrt(1-((-10:.01:10)./((ydata(i)/2).*ellipse_ratio)).^2));
        Y(:,i) = max(min(Y(:,i), ellipse_ratio*(ydata(i)/2)), -ellipse_ratio*(ydata(i)/2)); % Cut off x-y plane outside the ventricle
    end
    Z = [Z; newz];
    % Calculate the area of one slice
    area = [area; pi*ellipse_ratio*(ydata(i)/2)^2];
end

figure('Toolbar', 'figure',...
          'Menubar','none',...
          'Name','Model of the left ventricle',...
          'NumberTitle','off',...
          'IntegerHandle','off');
surf(X,Y,Z','FaceColor','interp',...
 'EdgeColor','none',...
 'FaceLighting','phong');
camlight left;
colormap([1 0 0]);
hold on;
surf(X,Y,-1.*Z','FaceColor','interp',...
 'EdgeColor','none',...
 'FaceLighting','phong');
title('3D Model of the Left Ventricle');
xlabel('x (cm)');
ylabel('y (cm)');
zlabel('z (cm)');
axis equal

%% Volume
% Add all slices together to calculate the volume
I = sum(d.f1.*dddx1.*area); % cm^3 == ml
%text(1, -5, 4, sprintf('Volume = %4.3f mL', I), 'BackgroundColor', [.8 .8 .8]);
uicontrol('Style', 'text', 'String', sprintf('Volume = %4.3f mL', I),...
    'Units', 'pixels', 'Position', [0 0 150 20]);

%% Accuracy Check
diam1 = ellipse_size(2);
diam2 = Volume.GetDiameter((b2-b1)/(a1-a2), y1((b2-b1)/(a1-a2)),a2,d.freehand,d.f1,dddx2);
dd = abs(diam1-diam2);
uicontrol('Style', 'text', 'String', sprintf('Diameter 1: %2.2f cm; Diameter 2: %2.2f cm; Difference: %1.3f cm', diam1, diam2, dd),...
    'Units', 'pixels', 'Position', [150 0 400 20]);
hold off;
end

