
clear
%% Load ERSP data from all ages

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'ERSP_habituation_all_ages.mat'])

%% Permutation ERSP Children

% TD

Cond1_final_TD = ERSP_habit.child.TD_st1(:, 101:end,:); % freq x time x subj
Cond2_final_TD = ERSP_habit.child.TD_st2(:, 101:end,:); % freq x time x subj

alldata_TD = cat(3,Cond1_final_TD, Cond2_final_TD);
N_TD = floor(size (alldata_TD, 3)/2);

conds_TD = cat(1,ones(N_TD,1),2*ones(N_TD,1)); % condition labels

nPerms = 500;
permdiffs_TD = NaN(size(alldata_TD,1), size(alldata_TD,2), N_TD, nPerms);

for permi=1:nPerms
    fconds = randperm(N_TD*2);
    fconds(fconds<N_TD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_TD(:,:,:, permi) = alldata_TD (:,:,fconds==2) - alldata_TD(:,:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
% for this we calculate z scores

Obs_diff_TD = mean((Cond2_final_TD-Cond1_final_TD),3);
Perm_diff_TD = squeeze(mean(permdiffs_TD, 3)); 


for i = 1 : size (Perm_diff_TD, 1)
    for j = 1: size (Perm_diff_TD, 2)
        zVal_TD(i,j) = (Obs_diff_TD(i,j)-mean(Perm_diff_TD(i,j,:))) / std(Perm_diff_TD(i,j,:));
    end
end

clearvars i j 

% to evaluate the significance of the distance between observed and
% permutated means we generate p values using two methods)

% Method 1: Generate p value by converting the z score of the observed 
% difference to a two-tailed probability 

for i = 1: size(zVal_TD,1)
    for j = 1: size (zVal_TD,2)
        p1_TD(i,j) = 2* (1-normcdf(abs(zVal_TD(i,j))));
    end
end

min_p1_TD = min(p1_TD,[],'all');
[k_TD l_TD] = find(p1_TD==min_p1_TD);

% Method 2: Generate % p value by counting how many permuted differences 
% are as large as the observed difference

p2_TD = mean( abs(Perm_diff_TD) >= abs(Obs_diff_TD), 3 );

% compare normcdf-based and counting-based p values
figure, scatter(p1_TD(:), p2_TD(:), 5, 'filled'); refline(1,0)
xlabel('p from z'), ylabel('p from counting')


% Adjust p values for multiple comparisons FDR across the whole TF map
% used the normcdf-based (method 1) p values 
FDR_TD = reshape( mafdr(p1_TD(:),'BHFDR',true), size(p1_TD) );

p1_adj_TD = FDR_TD;

min_p1_adj_TD = min(p1_adj_TD,[],'all');
[kadj_TD ladj_TD] = find(p1_adj_TD==min_p1_adj_TD);

sig_vals_TD = (p1_adj_TD < 0.05);
sig_vals2_TD = double (sig_vals_TD);


% ASD

Cond1_final_ASD = ERSP_habit.child.ASD_st1(:, 101:end,:); % freq x time x subj
Cond2_final_ASD = ERSP_habit.child.ASD_st2(:, 101:end,:); % freq x time x subj

alldata_ASD = cat(3,Cond1_final_ASD, Cond2_final_ASD);
N_ASD = floor(size (alldata_ASD, 3)/2);

conds_ASD = cat(1,ones(N_ASD,1),2*ones(N_ASD,1)); % condition labels

nPerms = 500;
permdiffs_ASD = NaN(size(alldata_ASD,1), size(alldata_ASD,2), N_ASD, nPerms);

for permi=1:nPerms
    fconds = randperm(N_ASD*2);
    fconds(fconds<N_ASD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_ASD(:,:,:, permi) = alldata_ASD (:,:,fconds==2) - alldata_ASD(:,:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)

Obs_diff_ASD = mean((Cond2_final_ASD-Cond1_final_ASD),3);
Perm_diff_ASD = squeeze(mean(permdiffs_ASD, 3)); 


for i = 1 : size (Perm_diff_ASD, 1)
    for j = 1: size (Perm_diff_ASD, 2)
        zVal_ASD(i,j) = (Obs_diff_ASD(i,j)-mean(Perm_diff_ASD(i,j,:))) / std(Perm_diff_ASD(i,j,:));
    end
end

clearvars i j 

% P value method 1:

for i = 1: size(zVal_ASD,1)
    for j = 1: size (zVal_ASD,2)
        p1_ASD(i,j) = 2 *(1-normcdf(abs(zVal_ASD(i,j))));
    end
end

min_p1_ASD = min(p1_ASD,[],'all');
[k_ASD l_ASD] = find(p1_ASD==min_p1_ASD);

% p value method 2:
p2_ASD = mean( abs(Perm_diff_ASD) >= abs(Obs_diff_ASD), 3 );

% compare normcdf-based and counting-based p values
figure, scatter(p1_ASD(:), p2_ASD(:), 5, 'filled'); refline(1,0)
xlabel('p from z'), ylabel('p from counting')


% Adjust p values for multiple comparisons FDR across the whole TF map
% used the normcdf-based (method 1) p values 

FDR_ASD = reshape( mafdr(p1_ASD(:),'BHFDR',true), size(p1_ASD) );


p1_adj_ASD = FDR_ASD;

min_p1_adj_ASD = min(p1_adj_ASD,[],'all');
[kadj_ASD ladj_ASD] = find(p1_adj_ASD==min_p1_adj_ASD);

sig_vals_ASD = (p1_adj_ASD < 0.05);
sig_vals2_ASD = double (sig_vals_ASD);


% Cluster based permutation test for between groups std2-std2 difference
% time and frequency points will be clustered, only channel Fz line plotted 
% so no channel-based clustering 

Cond_TD_diff = Cond2_final_TD - Cond1_final_TD; % freq x time x subj
Cond_ASD_diff = Cond2_final_ASD - Cond1_final_ASD; % freq x time x subj

% build FieldTrip structures:

TD_ft.powspctrm  = permute(Cond_TD_diff, [3 4 1 2]);  % subj x 1 channel x freq X time
TD_ft.dimord = 'rpt_chan_freq_time'; % rpt = subject (units that is shuffled)
TD_ft.label  = {'Fz'};
TD_ft.freq = linspace(2, 35, size(Cond_TD_diff,1)); % freqs between 2 and 35 Hz
TD_ft.time   = linspace(-0.1, 0.5, size(Cond_TD_diff,2));  % seconds

ASD_ft.powspctrm  = permute(Cond_ASD_diff, [3 4 1 2]);
ASD_ft.dimord = 'rpt_chan_freq_time';
ASD_ft.label  = {'Fz'};
ASD_ft.freq = linspace(2, 35, size(Cond_ASD_diff,1));
ASD_ft.time   = TD_ft.time;

% Set cluster based analysis settings

cfg = [];
cfg.channel          = 'all'; % test all channels in the structures (Fz here)
cfg.latency          = 'all';  % use the whole time axis, no cropping
cfg.frequency = 'all'; % use the whole frequency axis, no cropping
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 5000;
cfg.neighbours(1).label      = 'Fz';
cfg.neighbours(1).neighblabel = {};

% Run cluster-based permutation test: TD vs ASD, Std2 - Std1 difference (children)
nTD  = size(TD_ft.powspctrm, 1);
nASD = size(ASD_ft.powspctrm, 1);
cfg.design = [ones(1,nTD), 2*ones(1,nASD)]; % group label per subject: 
                                            % 1 = TD, 2 = ASD, in the order 
                                            % the structures are given
cfg.ivar = 1;  % design row 1 is the independent variable (group)

%  rng(42) % fix shuffles 
stat_out = ft_freqstatistics(cfg, TD_ft, ASD_ft); % subjects are the shuffled units


% Extract the significant time-frequency points for plotting and add
% clusters to a table
sig_vals_diff = squeeze(stat_out.mask);  % freq x time, 
                                % logical: 1 = point inside a significant cluster
clust_table = table();
if isfield(stat_out, 'posclusters')
    posmat = squeeze(stat_out.posclusterslabelmat);  % freq x time
    for i = 1:numel(stat_out.posclusters)
        [fi, ti] = ind2sub(size(posmat), find(posmat == i));
        clust_table = [clust_table; table({'positive'}, i, stat_out.time(min(ti))*1000, stat_out.time(max(ti))*1000, stat_out.freq(min(fi)), stat_out.freq(max(fi)), stat_out.posclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','start_Hz','end_Hz','p'})];
    end
end
if isfield(stat_out, 'negclusters')
    negmat = squeeze(stat_out.negclusterslabelmat);  % freq x time
    for i = 1:numel(stat_out.negclusters)
        [fi, ti] = ind2sub(size(negmat), find(negmat == i));
        clust_table = [clust_table; table({'negative'}, i, stat_out.time(min(ti))*1000, stat_out.time(max(ti))*1000, stat_out.freq(min(fi)), stat_out.freq(max(fi)), stat_out.negclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','start_Hz','end_Hz','p'})];
    end
end

% generate arrays for plotting
std1_mn_TD = mean(Cond1_final_TD, 3);
std2_mn_TD = mean(Cond2_final_TD, 3);
std1_mn_ASD = mean(Cond1_final_ASD, 3);
std2_mn_ASD = mean(Cond2_final_ASD, 3);
diff_mn_TD = mean(Cond_TD_diff, 3);
diff_mn_ASD = mean(Cond_ASD_diff, 3);
time = TD_ft.time * 1000;  % ms
Freq = TD_ft.freq;

% save everything the plot needs - children
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
'ERSP_plotdata_children.mat'], ...
'std1_mn_TD','std2_mn_TD','sig_vals2_TD', ...
'std1_mn_ASD','std2_mn_ASD','sig_vals2_ASD', ...
'diff_mn_TD','diff_mn_ASD','sig_vals_diff', ...
'clust_table','time','Freq');

clearvars -except ERSP_habit

%% Permutation ERSP Adolescents

% TD

Cond1_final_TD = ERSP_habit.adol.TD_st1(:, 101:end,:); % freq x time x subj
Cond2_final_TD = ERSP_habit.adol.TD_st2(:, 101:end,:); % freq x time x subj

alldata_TD = cat(3,Cond1_final_TD, Cond2_final_TD);
N_TD = floor(size (alldata_TD, 3)/2);

conds_TD = cat(1,ones(N_TD,1),2*ones(N_TD,1)); % condition labels

nPerms = 500;
permdiffs_TD = NaN(size(alldata_TD,1), size(alldata_TD,2), N_TD, nPerms);

for permi=1:nPerms
    fconds = randperm(N_TD*2);
    fconds(fconds<N_TD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_TD(:,:,:, permi) = alldata_TD (:,:,fconds==2) - alldata_TD(:,:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
% for this we calculate z scores

Obs_diff_TD = mean((Cond2_final_TD-Cond1_final_TD),3);
Perm_diff_TD = squeeze(mean(permdiffs_TD, 3)); 


for i = 1 : size (Perm_diff_TD, 1)
    for j = 1: size (Perm_diff_TD, 2)
        zVal_TD(i,j) = (Obs_diff_TD(i,j)-mean(Perm_diff_TD(i,j,:))) / std(Perm_diff_TD(i,j,:));
    end
end

clearvars i j 

% to evaluate the significance of the distance between observed and
% permutated means we generate p values using two methods)

% Method 1: Generate p value by converting the z score of the observed 
% difference to a two-tailed probability 

for i = 1: size(zVal_TD,1)
    for j = 1: size (zVal_TD,2)
        p1_TD(i,j) = 2* (1-normcdf(abs(zVal_TD(i,j))));
    end
end

min_p1_TD = min(p1_TD,[],'all');
[k_TD l_TD] = find(p1_TD==min_p1_TD);

% Method 2: Generate % p value by counting how many permuted differences 
% are as large as the observed difference

p2_TD = mean( abs(Perm_diff_TD) >= abs(Obs_diff_TD), 3 );

% compare normcdf-based and counting-based p values
figure, scatter(p1_TD(:), p2_TD(:), 5, 'filled'); refline(1,0)
xlabel('p from z'), ylabel('p from counting')


% Adjust p values for multiple comparisons FDR across the whole TF map
% used the normcdf-based (method 1) p values 
FDR_TD = reshape( mafdr(p1_TD(:),'BHFDR',true), size(p1_TD) );

p1_adj_TD = FDR_TD;

min_p1_adj_TD = min(p1_adj_TD,[],'all');
[kadj_TD ladj_TD] = find(p1_adj_TD==min_p1_adj_TD);

sig_vals_TD = (p1_adj_TD < 0.05);
sig_vals2_TD = double (sig_vals_TD);


% ASD

Cond1_final_ASD = ERSP_habit.adol.ASD_st1(:, 101:end,:); % freq x time x subj
Cond2_final_ASD = ERSP_habit.adol.ASD_st2(:, 101:end,:); % freq x time x subj

alldata_ASD = cat(3,Cond1_final_ASD, Cond2_final_ASD);
N_ASD = floor(size (alldata_ASD, 3)/2);

conds_ASD = cat(1,ones(N_ASD,1),2*ones(N_ASD,1)); % condition labels

nPerms = 500;
permdiffs_ASD = NaN(size(alldata_ASD,1), size(alldata_ASD,2), N_ASD, nPerms);

for permi=1:nPerms
    fconds = randperm(N_ASD*2);
    fconds(fconds<N_ASD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_ASD(:,:,:, permi) = alldata_ASD (:,:,fconds==2) - alldata_ASD(:,:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)

Obs_diff_ASD = mean((Cond2_final_ASD-Cond1_final_ASD),3);
Perm_diff_ASD = squeeze(mean(permdiffs_ASD, 3)); 


for i = 1 : size (Perm_diff_ASD, 1)
    for j = 1: size (Perm_diff_ASD, 2)
        zVal_ASD(i,j) = (Obs_diff_ASD(i,j)-mean(Perm_diff_ASD(i,j,:))) / std(Perm_diff_ASD(i,j,:));
    end
end

clearvars i j 

% P value method 1:

for i = 1: size(zVal_ASD,1)
    for j = 1: size (zVal_ASD,2)
        p1_ASD(i,j) = 2 *(1-normcdf(abs(zVal_ASD(i,j))));
    end
end

min_p1_ASD = min(p1_ASD,[],'all');
[k_ASD l_ASD] = find(p1_ASD==min_p1_ASD);

% p value method 2:
p2_ASD = mean( abs(Perm_diff_ASD) >= abs(Obs_diff_ASD), 3 );

% compare normcdf-based and counting-based p values
figure, scatter(p1_ASD(:), p2_ASD(:), 5, 'filled'); refline(1,0)
xlabel('p from z'), ylabel('p from counting')


% Adjust p values for multiple comparisons FDR across the whole TF map
% used the normcdf-based (method 1) p values 

FDR_ASD = reshape( mafdr(p1_ASD(:),'BHFDR',true), size(p1_ASD) );


p1_adj_ASD = FDR_ASD;

min_p1_adj_ASD = min(p1_adj_ASD,[],'all');
[kadj_ASD ladj_ASD] = find(p1_adj_ASD==min_p1_adj_ASD);

sig_vals_ASD = (p1_adj_ASD < 0.05);
sig_vals2_ASD = double (sig_vals_ASD);


% Cluster based permutation test for between groups std2-std2 difference
% time and frequency points will be clustered, only channel Fz line plotted 
% so no channel-based clustering 

Cond_TD_diff = Cond2_final_TD - Cond1_final_TD; % freq x time x subj
Cond_ASD_diff = Cond2_final_ASD - Cond1_final_ASD; % freq x time x subj

% build FieldTrip structures:

TD_ft.powspctrm  = permute(Cond_TD_diff, [3 4 1 2]);  % subj x 1 channel x freq X time
TD_ft.dimord = 'rpt_chan_freq_time'; % rpt = subject (units that is shuffled)
TD_ft.label  = {'Fz'};
TD_ft.freq = linspace(2, 35, size(Cond_TD_diff,1)); % freqs between 2 and 35 Hz
TD_ft.time   = linspace(-0.1, 0.5, size(Cond_TD_diff,2));  % seconds

ASD_ft.powspctrm  = permute(Cond_ASD_diff, [3 4 1 2]);
ASD_ft.dimord = 'rpt_chan_freq_time';
ASD_ft.label  = {'Fz'};
ASD_ft.freq = linspace(2, 35, size(Cond_ASD_diff,1));
ASD_ft.time   = TD_ft.time;

% Set cluster based analysis settings

cfg = [];
cfg.channel          = 'all'; % test all channels in the structures (Fz here)
cfg.latency          = 'all';  % use the whole time axis, no cropping
cfg.frequency = 'all'; % use the whole frequency axis, no cropping
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 5000;
cfg.neighbours(1).label      = 'Fz';
cfg.neighbours(1).neighblabel = {};

% Run cluster-based permutation test: TD vs ASD, Std2 - Std1 difference (children)
nTD  = size(TD_ft.powspctrm, 1);
nASD = size(ASD_ft.powspctrm, 1);
cfg.design = [ones(1,nTD), 2*ones(1,nASD)]; % group label per subject: 
                                            % 1 = TD, 2 = ASD, in the order 
                                            % the structures are given
cfg.ivar = 1;  % design row 1 is the independent variable (group)

%  rng(42) % fix shuffles 
stat_out = ft_freqstatistics(cfg, TD_ft, ASD_ft); % subjects are the shuffled units


% Extract the significant time-frequency points for plotting and add
% clusters to a table
sig_vals_diff = squeeze(stat_out.mask);  % freq x time, 
                                % logical: 1 = point inside a significant cluster
clust_table = table();
if isfield(stat_out, 'posclusters')
    posmat = squeeze(stat_out.posclusterslabelmat);  % freq x time
    for i = 1:numel(stat_out.posclusters)
        [fi, ti] = ind2sub(size(posmat), find(posmat == i));
        clust_table = [clust_table; table({'positive'}, i, stat_out.time(min(ti))*1000, stat_out.time(max(ti))*1000, stat_out.freq(min(fi)), stat_out.freq(max(fi)), stat_out.posclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','start_Hz','end_Hz','p'})];
    end
end
if isfield(stat_out, 'negclusters')
    negmat = squeeze(stat_out.negclusterslabelmat);  % freq x time
    for i = 1:numel(stat_out.negclusters)
        [fi, ti] = ind2sub(size(negmat), find(negmat == i));
        clust_table = [clust_table; table({'negative'}, i, stat_out.time(min(ti))*1000, stat_out.time(max(ti))*1000, stat_out.freq(min(fi)), stat_out.freq(max(fi)), stat_out.negclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','start_Hz','end_Hz','p'})];
    end
end

% generate arrays for plotting
std1_mn_TD = mean(Cond1_final_TD, 3);
std2_mn_TD = mean(Cond2_final_TD, 3);
std1_mn_ASD = mean(Cond1_final_ASD, 3);
std2_mn_ASD = mean(Cond2_final_ASD, 3);
diff_mn_TD = mean(Cond_TD_diff, 3);
diff_mn_ASD = mean(Cond_ASD_diff, 3);
time = TD_ft.time * 1000;  % ms
Freq = TD_ft.freq;

% save everything the plot needs - children
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
'ERSP_plotdata_adolescents.mat'], ...
'std1_mn_TD','std2_mn_TD','sig_vals2_TD', ...
'std1_mn_ASD','std2_mn_ASD','sig_vals2_ASD', ...
'diff_mn_TD','diff_mn_ASD','sig_vals_diff', ...
'clust_table','time','Freq');

clearvars -except ERSP_habit

%% Permutation ERSP Adults

% TD

Cond1_final_TD = ERSP_habit.adult.TD_st1(:, 101:end,:); % freq x time x subj
Cond2_final_TD = ERSP_habit.adult.TD_st2(:, 101:end,:); % freq x time x subj

alldata_TD = cat(3,Cond1_final_TD, Cond2_final_TD);
N_TD = floor(size (alldata_TD, 3)/2);

conds_TD = cat(1,ones(N_TD,1),2*ones(N_TD,1)); % condition labels

nPerms = 500;
permdiffs_TD = NaN(size(alldata_TD,1), size(alldata_TD,2), N_TD, nPerms);

for permi=1:nPerms
    fconds = randperm(N_TD*2);
    fconds(fconds<N_TD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_TD(:,:,:, permi) = alldata_TD (:,:,fconds==2) - alldata_TD(:,:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
% for this we calculate z scores

Obs_diff_TD = mean((Cond2_final_TD-Cond1_final_TD),3);
Perm_diff_TD = squeeze(mean(permdiffs_TD, 3)); 


for i = 1 : size (Perm_diff_TD, 1)
    for j = 1: size (Perm_diff_TD, 2)
        zVal_TD(i,j) = (Obs_diff_TD(i,j)-mean(Perm_diff_TD(i,j,:))) / std(Perm_diff_TD(i,j,:));
    end
end

clearvars i j 

% to evaluate the significance of the distance between observed and
% permutated means we generate p values using two methods)

% Method 1: Generate p value by converting the z score of the observed 
% difference to a two-tailed probability 

for i = 1: size(zVal_TD,1)
    for j = 1: size (zVal_TD,2)
        p1_TD(i,j) = 2* (1-normcdf(abs(zVal_TD(i,j))));
    end
end

min_p1_TD = min(p1_TD,[],'all');
[k_TD l_TD] = find(p1_TD==min_p1_TD);

% Method 2: Generate % p value by counting how many permuted differences 
% are as large as the observed difference

p2_TD = mean( abs(Perm_diff_TD) >= abs(Obs_diff_TD), 3 );

% compare normcdf-based and counting-based p values
figure, scatter(p1_TD(:), p2_TD(:), 5, 'filled'); refline(1,0)
xlabel('p from z'), ylabel('p from counting')


% Adjust p values for multiple comparisons FDR across the whole TF map
% used the normcdf-based (method 1) p values 
FDR_TD = reshape( mafdr(p1_TD(:),'BHFDR',true), size(p1_TD) );

p1_adj_TD = FDR_TD;

min_p1_adj_TD = min(p1_adj_TD,[],'all');
[kadj_TD ladj_TD] = find(p1_adj_TD==min_p1_adj_TD);

sig_vals_TD = (p1_adj_TD < 0.05);
sig_vals2_TD = double (sig_vals_TD);


% ASD

Cond1_final_ASD = ERSP_habit.adult.ASD_st1(:, 101:end,:); % freq x time x subj
Cond2_final_ASD = ERSP_habit.adult.ASD_st2(:, 101:end,:); % freq x time x subj

alldata_ASD = cat(3,Cond1_final_ASD, Cond2_final_ASD);
N_ASD = floor(size (alldata_ASD, 3)/2);

conds_ASD = cat(1,ones(N_ASD,1),2*ones(N_ASD,1)); % condition labels

nPerms = 500;
permdiffs_ASD = NaN(size(alldata_ASD,1), size(alldata_ASD,2), N_ASD, nPerms);

for permi=1:nPerms
    fconds = randperm(N_ASD*2);
    fconds(fconds<N_ASD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_ASD(:,:,:, permi) = alldata_ASD (:,:,fconds==2) - alldata_ASD(:,:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)

Obs_diff_ASD = mean((Cond2_final_ASD-Cond1_final_ASD),3);
Perm_diff_ASD = squeeze(mean(permdiffs_ASD, 3)); 


for i = 1 : size (Perm_diff_ASD, 1)
    for j = 1: size (Perm_diff_ASD, 2)
        zVal_ASD(i,j) = (Obs_diff_ASD(i,j)-mean(Perm_diff_ASD(i,j,:))) / std(Perm_diff_ASD(i,j,:));
    end
end

clearvars i j 

% P value method 1:

for i = 1: size(zVal_ASD,1)
    for j = 1: size (zVal_ASD,2)
        p1_ASD(i,j) = 2 *(1-normcdf(abs(zVal_ASD(i,j))));
    end
end

min_p1_ASD = min(p1_ASD,[],'all');
[k_ASD l_ASD] = find(p1_ASD==min_p1_ASD);

% p value method 2:
p2_ASD = mean( abs(Perm_diff_ASD) >= abs(Obs_diff_ASD), 3 );

% compare normcdf-based and counting-based p values
figure, scatter(p1_ASD(:), p2_ASD(:), 5, 'filled'); refline(1,0)
xlabel('p from z'), ylabel('p from counting')


% Adjust p values for multiple comparisons FDR across the whole TF map
% used the normcdf-based (method 1) p values 

FDR_ASD = reshape( mafdr(p1_ASD(:),'BHFDR',true), size(p1_ASD) );


p1_adj_ASD = FDR_ASD;

min_p1_adj_ASD = min(p1_adj_ASD,[],'all');
[kadj_ASD ladj_ASD] = find(p1_adj_ASD==min_p1_adj_ASD);

sig_vals_ASD = (p1_adj_ASD < 0.05);
sig_vals2_ASD = double (sig_vals_ASD);


% Cluster based permutation test for between groups std2-std2 difference
% time and frequency points will be clustered, only channel Fz line plotted 
% so no channel-based clustering 

Cond_TD_diff = Cond2_final_TD - Cond1_final_TD; % freq x time x subj
Cond_ASD_diff = Cond2_final_ASD - Cond1_final_ASD; % freq x time x subj

% build FieldTrip structures:

TD_ft.powspctrm  = permute(Cond_TD_diff, [3 4 1 2]);  % subj x 1 channel x freq X time
TD_ft.dimord = 'rpt_chan_freq_time'; % rpt = subject (units that is shuffled)
TD_ft.label  = {'Fz'};
TD_ft.freq = linspace(2, 35, size(Cond_TD_diff,1)); % freqs between 2 and 35 Hz
TD_ft.time   = linspace(-0.1, 0.5, size(Cond_TD_diff,2));  % seconds

ASD_ft.powspctrm  = permute(Cond_ASD_diff, [3 4 1 2]);
ASD_ft.dimord = 'rpt_chan_freq_time';
ASD_ft.label  = {'Fz'};
ASD_ft.freq = linspace(2, 35, size(Cond_ASD_diff,1));
ASD_ft.time   = TD_ft.time;

% Set cluster based analysis settings

cfg = [];
cfg.channel          = 'all'; % test all channels in the structures (Fz here)
cfg.latency          = 'all';  % use the whole time axis, no cropping
cfg.frequency = 'all'; % use the whole frequency axis, no cropping
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 5000;
cfg.neighbours(1).label      = 'Fz';
cfg.neighbours(1).neighblabel = {};

% Run cluster-based permutation test: TD vs ASD, Std2 - Std1 difference (children)
nTD  = size(TD_ft.powspctrm, 1);
nASD = size(ASD_ft.powspctrm, 1);
cfg.design = [ones(1,nTD), 2*ones(1,nASD)]; % group label per subject: 
                                            % 1 = TD, 2 = ASD, in the order 
                                            % the structures are given
cfg.ivar = 1;  % design row 1 is the independent variable (group)

%  rng(42) % fix shuffles 
stat_out = ft_freqstatistics(cfg, TD_ft, ASD_ft); % subjects are the shuffled units


% Extract the significant time-frequency points for plotting and add
% clusters to a table
sig_vals_diff = squeeze(stat_out.mask);  % freq x time, 
                                % logical: 1 = point inside a significant cluster
clust_table = table();
if isfield(stat_out, 'posclusters')
    posmat = squeeze(stat_out.posclusterslabelmat);  % freq x time
    for i = 1:numel(stat_out.posclusters)
        [fi, ti] = ind2sub(size(posmat), find(posmat == i));
        clust_table = [clust_table; table({'positive'}, i, stat_out.time(min(ti))*1000, stat_out.time(max(ti))*1000, stat_out.freq(min(fi)), stat_out.freq(max(fi)), stat_out.posclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','start_Hz','end_Hz','p'})];
    end
end
if isfield(stat_out, 'negclusters')
    negmat = squeeze(stat_out.negclusterslabelmat);  % freq x time
    for i = 1:numel(stat_out.negclusters)
        [fi, ti] = ind2sub(size(negmat), find(negmat == i));
        clust_table = [clust_table; table({'negative'}, i, stat_out.time(min(ti))*1000, stat_out.time(max(ti))*1000, stat_out.freq(min(fi)), stat_out.freq(max(fi)), stat_out.negclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','start_Hz','end_Hz','p'})];
    end
end

% generate arrays for plotting
std1_mn_TD = mean(Cond1_final_TD, 3);
std2_mn_TD = mean(Cond2_final_TD, 3);
std1_mn_ASD = mean(Cond1_final_ASD, 3);
std2_mn_ASD = mean(Cond2_final_ASD, 3);
diff_mn_TD = mean(Cond_TD_diff, 3);
diff_mn_ASD = mean(Cond_ASD_diff, 3);
time = TD_ft.time * 1000;  % ms
Freq = TD_ft.freq;

% save everything the plot needs - children
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
'ERSP_plotdata_adults.mat'], ...
'std1_mn_TD','std2_mn_TD','sig_vals2_TD', ...
'std1_mn_ASD','std2_mn_ASD','sig_vals2_ASD', ...
'diff_mn_TD','diff_mn_ASD','sig_vals_diff', ...
'clust_table','time','Freq');

clear all 

%% plot all age groups as 3 x 7 

% Plot all age groups as 3 x 7 ERSP figure (rows = age groups)

input_dir = ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\' ...
    'input_arrays\'];
agegroups = {'children','adolescents','adults'};
rowlabels = {'Children','Adolescents','Adults'};

bottom = -0.3; top = 0.5;
plotlimlower = 2; plotlimhigher = 35;

figure(1)
set(gcf, 'Position', [50 50 2100 950]);

nrows = numel(agegroups);
ncols = 7;

for r = 1:nrows
    D = load([input_dir 'ERSP_plotdata_' agegroups{r} '.mat']);
    time = D.time; Freq = D.Freq;

    coldata  = {D.std1_mn_TD, D.std2_mn_TD, D.sig_vals2_TD, ...
                D.std1_mn_ASD, D.std2_mn_ASD, D.sig_vals2_ASD, ...
                double(D.sig_vals_diff)}; % D.sig_vals_diff stored as logical, 
                                          % convert to numerical
    coltitle = {'std1 TD','std2 TD','std2-std1 TD', ...
                'std1 ASD','std2 ASD','std2-std1 ASD','ASD-TD Cluster p<.025'};
    coltype  = {'power','power','sig','power','power','sig','sig'};

    for c = 1:ncols
        idx = (r-1)*ncols + c;
        subplot(nrows, ncols, idx)

        Z = coldata{c};
        if strcmp(coltype{c},'sig')
            % force all-zero sig masks to dark blue (local copy only,
            % original saved arrays not modified)
            if ~any(Z(:))
                Z(1,1) = 1;
            end
        end

        contourf(time, Freq, Z, 40, 'linestyle', 'none')
        hold on
        plot([0 0], get(gca,'ylim'), 'k--', 'LineWidth', 2)
        ylim([plotlimlower plotlimhigher])
        xlim([-100 500]); xticks(-100:100:500)
        xtickangle(45)                         % angled x ticks
        colormap('jet')

        if strcmp(coltype{c},'power')
            caxis manual; caxis([bottom top])
        else
            caxis([0 1])
        end

        if r == 1
            title(coltitle{c}, 'FontSize', 18)
        end

        % keep only frequency ticks on column 1, no per-panel ylabel
        if c == 1
            set(gca, 'ytick', [2 5 10 15 20 25 30 35])
        else
            set(gca, 'yticklabel', [])
        end

        % x tick labels only on bottom row
        if r < nrows
            set(gca, 'xticklabel', [])
        end

        set(gca, 'FontSize', 14, 'TickDir', 'out', 'box', 'off')
    end
end

% ---- shared colorbar (power range) on the right ----
h = axes(figure(1), 'visible', 'off');
colormap(h, 'jet'); caxis(h, [bottom top]);
cb = colorbar(h, 'Position', [0.93 0.11 0.015 0.8]);
cb.FontSize = 17;
cb.Label.String = 'Power (dB)';
cb.Label.FontSize = 18;

% ---- shared axis labels ----
han = axes(figure(1), 'visible', 'off');
han.XLim = [0 1]; han.YLim = [0 1];
% Frequency (Hz) - left
text(han, -0.035, 0.5, 'Frequency (Hz)', 'Rotation', 90, ...
     'HorizontalAlignment','center', 'FontSize', 20, 'FontWeight','bold');
% Time (msec) - bottom
text(han, 0.5, -0.08, 'Time (msec)', ...
     'HorizontalAlignment','center', 'FontSize', 20, 'FontWeight','bold');

% ---- age-group labels (further left, so not confused with freq values) ----
yc = [0.80 0.50 0.20];   % vertical centres of the three rows (tweak to align)
for r = 1:nrows
    text(han, -0.06, yc(r), rowlabels{r}, 'Rotation', 90, ...
         'HorizontalAlignment','center', 'FontSize', 20, 'FontWeight','bold');
end

sgtitle('Event-related spectral changes across age groups', 'FontSize', 24,...
    'FontWeight', 'bold');


%% save
export_folder = ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\' ...
    'final_figures\figure_3\'];


exportgraphics(gcf, fullfile(export_folder,'figure3_ersp_all_ages.pdf'), ...
    'ContentType','vector');
exportgraphics(gcf, fullfile(export_folder,'figure3_ersp_all_ages.png'), ...
    'Resolution', 300);
exportgraphics(gcf, fullfile(export_folder,'figure3_ersp_all_ages.tiff'), ...
    'Resolution', 300);

