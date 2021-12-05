function [peaks, max_acc, av_acc] = acceleration_analysis(data, sample_freq)
%ACCELERATION_ANALYSIS Finds amplitude of acceleration from data (1D array)
%   Uses peak finder to give amplitudes of all peaks (see how they decay
%   etc) and then gives average amplitude and maximun / minimum ampltude
%   Should input a 1D array so that the analysis of the vertical and
%   horizontal directions should be done in two seperate calls to the
%   function
%   Outputs peaks, a 1D array of all the peaks so that the decay over time
%   can be seen (? add time for each of these?), max_acc which gives the
%   value of the maximum acceleration experienced, and av_acc which gives a
%   mean of peaks and can be used as a check for anomalous acceleration
%   results

%Get sample freq and time vector to line peaks up with their time (good to
%measure decay or damping
T = 1/sample_freq;
L = length(data);
t = (0:L-1) * T; %Time vector (s)

data = abs(data); %Only concerned about the ablsolute value of the acceleration

%Find peaks
[pks, locs] = findpeaks(data, 'MinPeakDistance', 5);

%Assign peaks into an array with their corresponding time value
peaks = zeros(length(pks), 2);
for i = 1:length(pks)
    peaks(i) = [pks(i), t(locs(i))];
end

%Average and maximum
av_acc = mean(pks);
max_acc = max(pks);
end

