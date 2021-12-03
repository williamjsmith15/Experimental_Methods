function calibrated_data = calibrate(data, calibration_matrix)
%CALIBRATE Takes raw voltage data and calibrates using the already 
% calculated calibration matrix and removes the bias from gravity

data(:,4) = 1;
temp = data * calibration_matrix;
calibrated_data = temp;
end