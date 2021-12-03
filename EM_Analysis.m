
%------INPUT DATA------
fprintf("Select the raw data file to be analysed.\n")
[fname_data, path_data] = uigetfile('*.csv');
fprintf("Opening %s\n\n", fname_data)
raw_data = table2array(readtable(fullfile(path_data, fname_data)));

%Sample freq, time period etc
sample_freq = input("Enter the sampling freq of the data (Hz): ");
T = 1/sample_freq;
L = length(raw_data(:,1)); %Length of data
t = (0:L-1) * T; %Time vector (s)





%------APPLY CALIBRATION------
%Import the calibration file folder
fprintf("Select the folder all the calibration files are in.\n")
path_cal = uigetdir('*.csv');
files_calibration = dir(fullfile(path_cal, '*.csv'));

cal_matrix = zeros(4,3);
for i = 1:length(files_calibration) %Loop through all files in folder specified 
    fname_cal = files_calibration(i).name;
    full_fname_cal = fullfile(path_cal, fname_cal);
    fprintf("Reading %s\n", fname_cal)
    %Add to calibration matrix
    cal_matrix = cal_matrix + table2array(readtable(full_fname_cal));
end
%Divide by number of elements to get mean
cal_matrix = cal_matrix / length(files_calibration);

%Apply the calibration
calibrated_data = calibrate(raw_data, cal_matrix);

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









%------SPECTRAL ANALYSIS OF DATA------
%? Add peak finder (easier error analysis)

%Do FFT of the data (adding all XYZ components together to get one FT)
[fft_x, fft_y] = spectral_analysis(calibrated_data, sample_freq);

%Plot the FT
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
