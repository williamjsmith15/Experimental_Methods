function [fft_x, fft_y, principal_freq, peaks] = spectral_analysis(data, sample_freq)
%SPECTRAL_ANALYSIS Performs spectral analysis of inputted data
%   [fft_x, fft_y, principal_freq, peaks] = spectral_analysis(data,
%   sample_freq)
%   Take in data from the DAQ and perform a fourier analysis on it
%   ? Add in peak finder to FFT 
%   

L = length(data); %Length of data

%Following method in MATLAB documentation for this function
%Add hann window to data whilst doing the FFT
freq_data = fft(hann(L).*data);

P2 = abs(freq_data/L); %2 Sided spectrum
fft_y = P2(1:floor(L/2+1)); %1 Sided spectrum based on P2 and even-valued L
fft_y(2:end-1) = 2*fft_y(2:end-1);

fft_x = sample_freq * (0:(L/2))/L; % Set the x-values for the FT data



%Find peaks and then corresponding x (frequency) values
average_height = mean(fft_y);
[pks, locs] = findpeaks(fft_y, "MinPeakHeight", average_height); %Only get peaks above the average value
peaks = zeros(length(pks), 2);
for i = 1:length(pks)
    peaks(i,1) = pks(i);
    peaks(i,2) = fft_x(locs(i));
end

[val, index] = max(peaks(:,1));
principal_freq = [val, peaks(index,2)];

end