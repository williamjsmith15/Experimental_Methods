%Close all prev figures
close all

%------INPUT DATA------
fprintf("Select the raw data file to be analysed.\n")
[fname_data, path_data] = uigetfile('*.csv')
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


%------DECIDE RANGE OF DATA TO ANALYSE FROM------
%Some of the data sets (see 1.1 has the direct feedback of the person
%jumping folled by just the bridges natural response so only want to
%analyse the data between certain timesteps
time_start = input("Enter the time at which you want to start the analysis from: ");
time_end = input("Enter the time at which you want to end the analysis: ");

for i = 1:L
    if time_start >= t(i) && time_start <= t(i+1)
        start_posn = i;
    end
    if time_end >= t(i) && time_end <= t(i+1)
        end_posn = i;
    end
end

chopped_data = calibrated_data(start_posn:end_posn,:);
L = length(chopped_data(:,1));
t = (0:L-1) * T;


%Plot final data set to be analysed overriding the prev plot
figure(fig_raw);
clf(fig_raw);
hold on;
plot(t, chopped_data(:,1));
plot(t, chopped_data(:,2));
plot(t, chopped_data(:,3));
xlabel("Time (s)");
ylabel("Acceleration (g)");
title("Chopped Calibrated Data Plot");


%------RESOLVE INTO VERTICAL AND HORIZOLTAL COMPENENTS------
%Find angle of accelerometer from average of all the data
%Take calibrated data and place into array of just vertical / horizontal
resolved_data = angle_calibrate(chopped_data);

%Plot vertical and horizontal on seperate figures
ver_acc = figure;
figure(ver_acc);
plot(t, resolved_data(:,1));
xlabel("Time (s)");
ylabel("Acceleration (g) normalised about 0");
title("Vertical Aacceleration Plot");

hor_acc = figure;
figure(hor_acc);
plot(t, resolved_data(:,2));
xlabel("Time (s)");
ylabel("Acceleration (g) normalised about 0");
title("Horizontal Acceleration Plot");



%------SPECTRAL ANALYSIS OF DATA------
%? Add peak finder (easier error analysis)
%Do FFTs on both componenets
[ver_fft_x, ver_fft_y] = spectral_analysis(resolved_data(:,1), sample_freq); %Vertical
[hor_fft_x, hor_fft_y] = spectral_analysis(resolved_data(:,2), sample_freq); %Horizontal


%Plot the FTs
ver_fig_fft = figure;
figure(ver_fig_fft);
plot(ver_fft_x, ver_fft_y);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("FT of the Calibrated Data in the Vertical Axis");

hor_fig_fft = figure;
figure(hor_fig_fft);
plot(hor_fft_x, hor_fft_y);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("FT of the Calibrated Data in the Horizontal Axis");



%------ACCELERATION ANALYSIS OF DATA-------
%Need Peak finder, see amplitude changes, plotting
%Get accelerations
[ver_acc_peaks, ver_acc_max, ver_acc_av] = acceleration_analysis(resolved_data(:,1), sample_freq); %Vertical
[hor_acc_peaks, hor_acc_max, hor_acc_av] = acceleration_analysis(resolved_data(:,2), sample_freq); %Vertical

%Plot acceleration peaks
ver_fig_acc = figure;
figure(ver_fig_acc);
plot(ver_acc_peaks(:,2), ver_acc_peaks(:,1));
xlabel("Time (s)");
ylabel("Acceleration (g)");
title("Plot of the Acceleration Peaks in the Vertical Axis");

hor_fig_acc = figure;
figure(hor_fig_acc);
plot(hor_acc_peaks(:,2), hor_acc_peaks(:,1));
xlabel("Time (s)");
ylabel("Acceleration (g)");
title("Plot of the Acceleration Peaks in the Horizontal Axis");




%------ERROR ANALYSIS------
%Error handling of above cases...
