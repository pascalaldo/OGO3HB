function AnalyseVideo(filenameLongAxis, filenameShortAxis)
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
[frame1 frame2 time1 time2] = GUI.ChooseFrame(filenameLongAxis, filenameShortAxis);

Volume.AnalyseFrame(frame1, frame2);

end

