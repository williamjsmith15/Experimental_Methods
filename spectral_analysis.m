function [fft_x, fft_y] = spectral_analysis(data, sample_freq)
%SPECTRAL_ANALYSIS Performs spectral analysis of inputted data
%   Take in data from the DAQ and perform a fourier analysis on it
%   ? Add in peak finder to FFT 
%   

L = length(data); %Length of data

%Following method in MATLAB documentation for this function
freq_data = fft(data);

P2 = abs(freq_data/L); %2 Sided spectrum
P1 = P2(1:L/2+1); %1 Sided spectrum based on P2 and even-valued L
P1(2:end-1) = 2*P1(2:end-1);

f = sample_freq * (0:(L/2))/L; % Set the x-values for the FT data

fft_x = f;
fft_y = P1;
end