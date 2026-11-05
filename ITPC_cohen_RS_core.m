
function [tf] = ITPC_cohen_RS_core(data)

% wavelet parameters
num_frex = 35;
min_freq =  2;
max_freq = 35;

% set range for variable number of wavelet cycles
range_cycles = [ 3 10 ];

% parameters 
frex = linspace(min_freq, max_freq, num_frex);
nCycs = logspace(log10(range_cycles(1)),log10(range_cycles(end)),num_frex);
srate = 1000;
time  = -2:1/srate:2;
half_wave = (length(time)-1)/2;

% FFT parameters
n_points = size(data,1);
n_trials = size(data,2);
nWave = length(time);
nData = n_points * n_trials;
nConv = nWave + nData - 1;

% FFT of data (doesn't change on frequency iteration)
dataX = fft( reshape(data,1,nData) ,nConv);

% initialize output time-frequency data
tf = zeros(num_frex,n_points);

% loop over frequencies
for fi=1:num_frex
    
    % create wavelet and get its FFT
    s = nCycs(fi)/(2*pi*frex(fi));
    wavelet  = exp(2*1i*pi*frex(fi).*time) .* exp(-time.^2./(2*s^2));
    waveletX = fft(wavelet,nConv);
    
    % run convolution
    as = ifft(waveletX.*dataX,nConv);
    as = as(half_wave+1:end-half_wave);
    
    % reshape back to time X trials
    as = reshape (as, n_points, n_trials);
    
    % compute ITPC (we are computing ITPC for all time points, one frequency at a time.)
    tf(fi,:) = abs (mean(exp(1i*angle(as)),2));
end
