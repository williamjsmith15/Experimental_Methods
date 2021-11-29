
%------INPUT DATA------
fprintf("Select the raw data file to be analysed.\n\n")
fname_data = uigetfile('*.csv');
data = readtable(fname_data); %? Also use csvread if this doesnt work...

%------APPLY CALIBRATION------
fprintf("Select the calibration data file to be analysed.\n\n")
fname_calibration = uigetfile('*.csv');
calibration_matrix = readtable(fname_calibration);

data(:,4) = 1;
calibrated_data = data * calibration_matrix;




%------SPECTRAL ANALYSIS OF DATA------
%Need FFT, peak finder, ploting



%------ACCELERATION ANALYSIS OF DATA-------
%Need Peak finder, see amplitude changes, plotting


%------ERROR ANALYSIS------
%Error handling of above cases...
