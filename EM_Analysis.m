
%------INPUT DATA------
fprintf("Select the raw data file to be analysed.\n")
[fname_data, path_data] = uigetfile('*.csv');
fprintf("Opening %s\n\n", fname_data)
data = table2array(readtable(fullfile(path_data, fname_data)));

%Sample freq, time period etc
sample_freq = input("Enter the sampling freq of the data (Hz): ");
T = 1/sample_freq;
L = length(data(:,1)); %Length of data
t = (0:L-1) * T; %Time vector (s)





%------APPLY CALIBRATION------
%Import the calibration file
fprintf("Select the calibration data file to be analysed.\n")
[fname_calibration, path_calibration] = uigetfile('*.csv');
fprintf("Opening %s\n\n", fname_calibration)
calibration_matrix = table2array(readtable(fullfile(path_calibration, fname_calibration)));

%Apply the calibration
data(:,4) = 1;
calibrated_data = data * calibration_matrix;

%Plot the calibrated data and save plot to folder of fname_data
fig_raw = figure;
figure(fig_raw);
hold on;
plot(t, calibrated_data(:,1));
plot(t, calibrated_data(:,2));
plot(t, calibrated_data(:,3));
xlabel("Time (s)");
ylabel("Acceleration (g)");
title("Raw Calibrated Data Plot");

%Normalise the Z Axis to 0 (As only looking at the acceleration extra to g)
calibrated_data(:,3) = calibrated_data(:,3) - 1;








%------SPECTRAL ANALYSIS OF DATA------
%Need FFT, peak finder, ploting - which way do we want to do this, add all
%the values together, average XYZ, just take XYZ all seperatley??

[fft_x, fft_y] = spectral_analysis(calibrated_data, sample_freq);

%Plot the fft
fig_fft = figure;
figure(fig_fft);
plot(fft_x, fft_y);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("FT of the Calibrated Data in the Z Axis");



%------ACCELERATION ANALYSIS OF DATA-------
%Need Peak finder, see amplitude changes, plotting


%------ERROR ANALYSIS------
%Error handling of above cases...
