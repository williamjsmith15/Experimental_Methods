
%------INPUT DATA------
fprintf("Select the raw data file to be analysed.\n\n")
[fname_data, path_data] = uigetfile('*.csv');
data = readtable(fullfile(path_data, fname_data)); %? Also use csvread if this doesnt work...

%------APPLY CALIBRATION------
%Import the calibration file
fprintf("Select the calibration data file to be analysed.\n\n")
[fname_calibration, path_calibration] = uigetfile('*.csv');
calibration_matrix = readtable(fullfile(path_calibration, fname_calibration));

%Apply the calibration
data(:,4) = 1;
calibrated_data = data * calibration_matrix;

%Plot the calibrated data and save plot to folder of fname_data
f1 = figure;
figure(f1);
hold on;
plot(calibrated_data(:,1));
plot(calibrated_data(:,2));
plot(calibrated_data(:,3));
xlabel("Data Point");
ylabel("Acceleration (g)");
title("Raw Calibrated Data Plot");


%------SPECTRAL ANALYSIS OF DATA------
%Need FFT, peak finder, ploting



%------ACCELERATION ANALYSIS OF DATA-------
%Need Peak finder, see amplitude changes, plotting


%------ERROR ANALYSIS------
%Error handling of above cases...
