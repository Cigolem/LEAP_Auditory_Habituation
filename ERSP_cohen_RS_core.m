function [tfdb] = ERSP_cohen_RS_core(data)

%% Time Frequency Power of Multitrial EEG activity
times = linspace(-1000,1500,2500);
basewin = [-200 -50];
baseidx = dsearchn(times',basewin');

% data = MADE.channel_data{1,1}';            % pnts X trials matrix
%% setup wavelet parameters

% frequency parameters
min_freq =  2;
max_freq = 35;
num_frex = 35;
frex = linspace(min_freq,max_freq,num_frex);


% other wavelet parameters
range_cycles = [ 3 10 ];


s = logspace(log10(range_cycles(1)),log10(range_cycles(end)),num_frex) ./ (2*pi*frex);
srate = 1000;
wavtime = -2:1/srate:2;
half_wave = (length(wavtime)-1)/2;


% FFT parameters
n_points = size(data,1);
n_trials = size(data,2);
nWave = length(wavtime);
nData = n_points * n_trials;
nConv = nWave + nData - 1;


% what is the way to perform convolution on pnts X trials matrix over each trial separately without doing a loop?
% answer = we concatanate all trials into one trial and in the convolution
% we pretend there is only one trial 

% now compute the FFT of all trials concatenated - answer
alldata = reshape( data ,1,[]);
dataX   = fft( alldata ,nConv );


% initialize output time-frequency data
tf = zeros(num_frex,n_points);


%% now perform convolution

% loop over frequencies
for fi=1:length(frex)
    
    % create wavelet and get its FFT
    wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*s(fi)^2));
    waveletX = fft(wavelet,nConv);
    waveletX = waveletX ./ max(waveletX);
    
    % now run convolution in one step
    as = ifft(waveletX .* dataX);
    as = as(half_wave+1:end-half_wave);
    
    % and reshape back to time X trials
    as = reshape( as, n_points, n_trials );
    
    % compute power and average over trials
     tf(fi,:) = mean( abs(as).^2 ,2);
end


%% baseline normalization

% baseline power
baseline = mean( tf(:,baseidx(1):baseidx(2)) ,2);

% decibel
tfdb = 10*log10( bsxfun(@rdivide, tf, baseline) );

% same as bxfun
% for i = 1:length(frex)
% tfdb2 (i,:) = 10*log10 (tf(i,:)./baseline(i));
% end

