function AnalyseVideo(filenameLongAxis, filenameShortAxis, filenameNexfin)
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

% Temporary function TODO: replace with Martijn his function
    function [t bp] = temp1(timelist, pressurelist, time)
        t = timelist(50:200);
        bp = pressurelist(50:200);
        
        t = t-min(t);
    end

% Determine the starting point of the heartbeat
[hbt hbp] = temp1(bpdata.tBP, bpdata.BP, reftime); % TODO: Replace with Martijns function
hbpos = BloodPressure.DeterminePeak(hbt, hbp)

framesback = ceil(hbpos*framerate)
framesforth = ceil((max(hbt)-hbpos)*framerate)

framerange1 = [(framenr1-framesback) (framenr1+framesforth)]
framerange2 = [(framenr2-framesback) (framenr2+framesforth)]

Volume.AnalyseFrame(frame1, frame2);

end

