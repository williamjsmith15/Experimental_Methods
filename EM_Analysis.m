
%------INPUT DATA------
fprintf("Select the raw data file to be analysed.\n\n")
[fname_data, path_data] = uigetfile('*.csv');
data = readtable(fullfile(path_data, fname_data)); %? Also use csvread if this doesnt work...

%Sample freq, time period etc
sample_freq = input("Enter the sampling freq of the data (Hz).");
T = 1/sample_freq;
L = length(data(:,1)); %Length of data
t = (0:L-1) * T; %Time vector (s)





%------APPLY CALIBRATION------
%Import the calibration file
fprintf("Select the calibration data file to be analysed.\n\n")
[fname_calibration, path_calibration] = uigetfile('*.csv');
calibration_matrix = readtable(fullfile(path_calibration, fname_calibration));

%Apply the calibration
data(:,4) = 1;
calibrated_data = data * calibration_matrix;

%Normalise the Z Axis to 0 (As only looking at the acceleration extra to g)
calibrated_data(:,3) = calibrated_data(:,3) - 1;

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
%Need FFT, peak finder, ploting - which way do we want to do this, add all
%the values together, average XYZ, just take XYZ all seperatley??

%FFT of just z for now, possible to do for other axes? - Following method
%in the MATLAB documentation for FFTs
freq_data = fft(calibrated_data(:,3));

P2 = abs(freq_data/L); %2 Sided spectrum
P1 = P2(1:L/2+1); %1 Sided spectrum based on P2 and even-valued L
P1(2:end-1) = 2*P1(2:end-1);

f = sample_freq * (0:(L/2))/L;


%Plot the fft
fig_fft = figure;
figure(fig_fft);
plot(f,P1);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("FT of the Calibrated Data in the Z Axis");



%------ACCELERATION ANALYSIS OF DATA-------
%Need Peak finder, see amplitude changes, plotting


%------ERROR ANALYSIS------
%Error handling of above cases...
