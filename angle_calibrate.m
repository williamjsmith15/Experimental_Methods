function angle_cal_data = angle_calibrate(calibrated_data)
%ANGLE_CALIBRATE Takes the data calibrated to gravity and gives resolved
%vertical and horizontal components
%   Average all data to fing average angle of the accelerometer for
%   particular dataset. Take angles of accelerometer and then compute the
%   vertical and horizontal acceleration amplitudes from teh XYZ given in
%   the raw data and output as a 2D array for analysis

%Angle finding from Neha here?
average = mean(calibrated_data, 1);

%Using solution set out in https://www.digikey.co.uk/en/articles/using-an-accelerometer-for-inclination-sensing
angle_from_x = atan(average(1) / sqrt(average(2)^2 + average(3)^2));
angle_from_y = atan(average(2) / sqrt(average(1)^2 + average(3)^2));
angle_from_z = atan(sqrt(average(1)^2 + average(2)^2) / average(3));

%Calibrate vertical and horizontal from pitch and roll

vertical = calibrated_data(:,1) * sin(angle_from_x) + calibrated_data(:,2) * sin(angle_from_y) + calibrated_data(:,3) * cos(angle_from_z);
horizontal = calibrated_data(:,1) * cos(angle_from_x) + calibrated_data(:,2) * cos(angle_from_y) + calibrated_data(:,3) * sin(angle_from_z);

%Calibrate such that mean is about 0
vertical_average = mean(vertical);
horizontal_average = mean(horizontal);

angle_cal_data = [vertical - vertical_average, horizontal - horizontal_average];
end