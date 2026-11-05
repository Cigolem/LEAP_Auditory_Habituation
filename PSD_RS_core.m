function [PSD_final,f_final] = PSD_RS_core(eegsignal)

% this function performs Power Spectral Density analysis 
% (using welch method) on notch filtered EEG data

% eegsignal = MADE.channel_data_201{1,1}(1,:);
% eegsignal = eeg(1,:);
%% Enter analysis parameters and compute PSD
epoch_length = 2500; % PSD computed on 2500 samples (2.5 sec) epochs
srate = 1000;        % Sampling Rate
winsize = srate/1; % 1-second window
% shorter windows give a smoother PSD (more segments averaged)
% but lower frequency resolution
hannw = .5 - cos(2*pi*linspace(0,1,winsize))./2; % for tapering the data
noverlap = winsize/2; % 50% overlap between windows
nfft = 2^(nextpow2(epoch_length)); % number of FFT points 
                                   % (sasy something frequency resolution)


[PSD,f] = pwelch(eegsignal,hannw,noverlap,nfft,srate);

MIN = 0.5;
MAX = 30;
PSD_final = log10(PSD(f>=MIN & f<=MAX));
f_final = f(f>=MIN & f<=MAX);
