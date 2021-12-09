function [mean_out, std_out] = uncertainty_analysis(to_analyse)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
mean_out = mean(to_analyse);
std_out = std(to_analyse);
end

