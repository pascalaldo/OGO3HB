function [vt v vdd hbt hbp] = AnalyseVideo(filenameLongAxis, filenameShortAxis, filenameNexfin)
%ANALYSEVIDEO Summary of this function goes here
%   Detailed explanation goes here

%% Handle default arguments
if nargin < 1
    [tempf tempp] = uigetfile('*.avi', 'Select long axis video...');
    filenameLongAxis = fullfile(tempp,tempf)
end
if nargin < 2
    [tempf tempp] = uigetfile('*.avi', 'Select short axis video...');
    filenameShortAxis = fullfile(tempp,tempf)
end
if nargin < 3
    [tempf tempp] = uigetfile('*040.csv', 'Select Nexfin file...');
    filenameNexfin = fullfile(tempp,tempf)
end

% Read the nexfin data
bpdata = Nexfin.readNexfin('part',filenameNexfin);

% Let the user select the frame where the A-V valves open
[frame1 frame2 framenr1 framenr2 framerate] = GUI.ChooseFrame(filenameLongAxis, filenameShortAxis);
reftime = (framenr1/framerate);

% Determine the starting point of the heartbeat
[hbt hbp] = BloodPressure.LoopFinder2(bpdata.tBP, bpdata.BP, reftime);
hbpos = BloodPressure.DeterminePeak(hbt, hbp);

figure('Toolbar','none',...
          'Menubar', 'none',...
          'Name','Selected Pressure Pulse',...
          'NumberTitle','off',...
          'IntegerHandle','off');
plot(hbt, hbp, 'r-');
hold on;
plot([hbpos hbpos], [0 200], 'b:');
xlabel('Time (s)');
ylabel('Pressure (mmHg)');
title('Selected Pressure Pulse');
hold off;

framesback = ceil(hbpos*framerate);
framesforth = ceil((max(hbt)-hbpos)*framerate);

framerange1 = [(framenr1-framesback) (framenr1+framesforth)];
framerange2 = [(framenr2-framesback) (framenr2+framesforth)];

movie1 = VideoReader(filenameLongAxis);
frames1 = read(movie1, framerange1);
movie2 = VideoReader(filenameShortAxis);
frames2 = read(movie2, framerange2);

vt = [];
v = [];
vdd = [];
settings = [];
for i=0:(framerange1(2)-framerange1(1))
    fprintf('# Frame %d of %d \n', i+1,(framerange1(2)-framerange1(1)));
    [I dd settings] = Volume.AnalyseFrame(frames1(:,:,:,(i+1)),frames2(:,:,:,(i+1)),settings);
    if I ~= -1
        vt = [vt; i/framerate];
        v = [v; I];
        vdd = [vdd; dd];
    end
    save('temp.mat', 'vt', 'v', 'vdd', 'hbt', 'hbp');
end

end

