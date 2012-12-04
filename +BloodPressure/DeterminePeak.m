function [timesecondpeak t2] = DeterminePeak(timepressureloop,valuespressureloop)
%Input arguments:
    %timepressureloop is a list containing a sequence of time.
    %valuespressureloop is a list containing a sequence of values of pressure.
    %This pressureloop corresponds to a pressure curve in the arterials during a heartbeat.
    
%Output arguments:
    %timesecondpeak is the time at the second peak of the pressure curve.
    %This peak corresponds to the opening of the AV valve.
 
 %Testing
 %This program was tested with the file: REC-205_040.csv
 %The selected part was 1 - 2.
 %For the final version of the program the inputarguments have to be
 %defined (This was not the case during testing)
 
global debug;
 
%% Define timepressureloop and valuespressureloop - Not in final version of program!
%databp = Nexfin.readNexfin('part');
%tbp = databp.tBP;
%bp = databp.BP;

%Selecting a pressure curve corresponding to one heartbeat
%timepressureloop = tbp(50:200);
%valuespressureloop = bp(50:200);

%% Method - Based on searching the timesecondpeak from steepest drop position
%Differential list of the pressure values
diffofvalues = diff(valuespressureloop);
%Determine the index of the point at which the drop is steepest (is equal to smallest differential)
steepestdropindex = find(diffofvalues == min(diffofvalues), 1,'last');

%% First while loop to determine the index of the (last) point of the second local minimum
%Determine value at current index (initial = steepestdropindex) and
%value at next index
currentvalue = valuespressureloop(steepestdropindex);
selectedvalue = valuespressureloop(steepestdropindex+1);
index = steepestdropindex+1;
%While the current value is larger or equal to the neighbouring value, the current
%value is replaced by the neighbouring value
while currentvalue >= selectedvalue
    currentvalue = selectedvalue;
    selectedvalue = valuespressureloop(index+1);
    index = index+1;
end
%Current index is equal to the selected index minus one. The current index
%corresponds to the last value that was equal to it's neigbouring value.
currentindex = index-1;
plotpoint = currentindex;

%% Second while loop to determine the index of the (last) point of the second local maximum
%Determine value at current index (initial = currentindex) and
%value at next index
currentvalue = valuespressureloop(currentindex);
selectedvalue = valuespressureloop(currentindex+1);
index = currentindex+1;
%While the current value is smaller or equal to the neighbouring value, the current
%value is replaced by the neighbouring value
while currentvalue <= selectedvalue
        currentvalue = selectedvalue;
    selectedvalue = valuespressureloop(index+1);
    index = index+1;
end
%Current index is equal to the selected index minus one. The current index
%corresponds to the last value that was equal to it's neigbouring value.
currentindex = index-1;
lastindex = currentindex;

%% Third while loop to determine all indexes of the points with the same value that are equal to the second local maximum value
currentvalue = valuespressureloop(currentindex);
selectedvalue = valuespressureloop(currentindex-1);
index = currentindex-1;
indexlist = [currentindex];
%While the current value is equal to the neighbouring value, the current
%index is replaced by the neighbouring index and added to a list
while currentvalue == selectedvalue
    indexlist = [indexlist, index];
    currentvalue = selectedvalue;
    selectedvalue = valuespressureloop(index-1);
    index = index-1;
end

%% Calculate a final index in the middle of the local maximum
finalindex = round(mean(indexlist));
timesecondpeak = timepressureloop(finalindex);

%Define characteristic points in pressure curve
%point 1 represent the point with the steepest drop
%point 2 represent the (last)point of the second local minimum
%point 3 represent the (middle)point of the second local maximum
t1 = timepressureloop(steepestdropindex);
v1 = valuespressureloop(steepestdropindex);
t2 = timepressureloop(plotpoint);
v2 = valuespressureloop(plotpoint);
t3 = timesecondpeak;
v3 = valuespressureloop(finalindex);

%% Testing - Not in final version of program!
%Plotting the data, timepressureloop and valuespressureloop
if debug
figure();
%subplot(3,1,1), plot(tbp,bp)
subplot(3,1,2), plot(timepressureloop,valuespressureloop,t1,v1,'o',t2,v2,'o',t3,v3,'o')

range = 1:length(diffofvalues);
refline = 0.*range;
%subplot(3,1,3), plot(range,diffofvalues,range,refline)
end

end