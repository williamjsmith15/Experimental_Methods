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
data = data * 9.80665; %Convert 'gs' to ms^-1

%Find peaks
[pks, locs] = findpeaks(data, 'MinPeakDistance', 5);

%Assign peaks into an array with their corresponding time value
peaks = zeros(1, 2);
av_acc = mean(pks);
std_acc = std(pks);
count = 1;

for i = 1:length(pks)
    % Add in if statement for outlier removal using Chauvenet;s Criterion
    if abs((pks(i) - av_acc) / std_acc) < 1
        peaks(count,1) = pks(i);
        peaks(count,2) = t(locs(i));
        count = count + 1;
    end
end
% Remove non-zero values from matrix (better perfomrance wise than
% dynamically allocating the matrix size in the for loop
%peaks = nonzeros(peaks);

%Average and maximum
av_acc = mean(peaks(:,1));
max_acc = max(peaks(:,1));
end

