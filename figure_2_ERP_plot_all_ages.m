 
clear all

%% Load ERP_habituation_all_ages mat array

load(['C:\Users\cigde\Dropbox\Habituation_paper\'... 
    'October_Emily\input_arrays\ERP_habituation_all_ages.mat'])

%% Do permutation Analysis - CHILDREN

% TD
Cond1_final_TD = ERP.child.st1_TD; % (points X subject)
Cond2_final_TD = ERP.child.st2_TD; % (points X subject)

alldata_TD = cat(2,Cond1_final_TD, Cond2_final_TD);

N_TD = floor (size (alldata_TD, 2)/2);

conds_TD = cat(1,ones(N_TD,1),2*ones(N_TD,1)); % condition labels

nPerms = 500;
for permi=1:nPerms
    fconds = randperm(N_TD*2);
    fconds(fconds<N_TD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_TD(:, :, permi) = alldata_TD (:,fconds==2) - alldata_TD(:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
Obs_diff_TD = mean((Cond2_final_TD-Cond1_final_TD),2);
Perm_diff_TD = squeeze(mean(permdiffs_TD, 2)); 


% z score the observed Std2-Std1 difference against the permutation null:
% at each time point, mean and SD are taken across the 500 permutations,
% giving one z per time point (observed - null mean) / null SD

    for i = 1: size (Perm_diff_TD, 1)
        zVal_TD(i) = (Obs_diff_TD(i)-mean(Perm_diff_TD(i,:))) / std(Perm_diff_TD(i,:));
    end

    zVal_TD = zVal_TD';

clearvars i  

% convert each z to a p value: abs(z) treats increases and decreases alike,
% and 1-normcdf gives the tail area beyond that point under the standard normal

for i = 1: size(zVal_TD,1)
      p1_TD(i) = 2*(1-normcdf(abs(zVal_TD(i))));
end

p1_TD = p1_TD';
min_p1_TD = min(p1_TD,[],'all');
[k l] = find(p1_TD==min_p1_TD);

% Adjust p values for multiple comparisons (https://www.r-bloggers.com/2023/07/the-benjamini-hochberg-procedure-fdr-and-p-value-adjusted-explained/

FDR_TD = mafdr(p1_TD,'BHFDR', true);
p1_adj_TD = FDR_TD';

min_p1_adj_TD = min(p1_adj_TD,[],'all');
[kadj_TD ladj_TD] = find(p1_adj_TD==min_p1_adj_TD);


pcond_TD = p1_adj_TD; 
sig_vals_cond_TD = (pcond_TD < 0.05);
sigvalscond_final_TD = ones(1, sum(sig_vals_cond_TD));
sigvalscond_final_TD(sigvalscond_final_TD==1) =1.5;

% set plotting variables
std1_final_TD = Cond1_final_TD';
std2_final_TD = Cond2_final_TD';

% calculate means and sem
std1_mn_TD = mean(std1_final_TD, 1);
std1_sem_TD = std(std1_final_TD, [], 1)./sqrt(size(std1_final_TD, 1));
std1_lo_TD = std1_mn_TD - std1_sem_TD;
std1_hi_TD = std1_mn_TD + std1_sem_TD;

std2_mn_TD = mean(std2_final_TD, 1);
std2_sem_TD = std(std2_final_TD, [], 1)./sqrt(size(std2_final_TD, 1));
std2_lo_TD = std2_mn_TD - std2_sem_TD;
std2_hi_TD = std2_mn_TD + std2_sem_TD;


% ASD

Cond1_final_ASD = ERP.child.st1_ASD;
Cond2_final_ASD = ERP.child.st2_ASD;

alldata_ASD = cat(2,Cond1_final_ASD, Cond2_final_ASD);

N_ASD = floor (size (alldata_ASD, 2)/2);

conds_ASD = cat(1,ones(N_ASD,1),2*ones(N_ASD,1)); % condition labels

nPerms = 500;
for permi=1:nPerms
    fconds = randperm(N_ASD*2);
    fconds(fconds<N_ASD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_ASD(:, :, permi) = alldata_ASD (:,fconds==2) - alldata_ASD(:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
Obs_diff_ASD = mean((Cond2_final_ASD-Cond1_final_ASD),2);
Perm_diff_ASD = squeeze(mean(permdiffs_ASD, 2)); 


    for i = 1: size (Perm_diff_ASD, 1)
        zVal_ASD(i) = (Obs_diff_ASD(i)-mean(Perm_diff_ASD(i,:))) / std(Perm_diff_ASD(i,:));
    end

    zVal_ASD = zVal_ASD';

clearvars i  


for i = 1: size(zVal_ASD,1)
      p1_ASD(i) = 2*(1-normcdf(abs(zVal_ASD(i))));
end

p1_ASD = p1_ASD';
min_p1_ASD = min(p1_ASD,[],'all');
[k l] = find(p1_ASD==min_p1_ASD);

% Adjust p values for multiple comparisons (https://www.r-bloggers.com/2023/07/the-benjamini-hochberg-procedure-fdr-and-p-value-adjusted-explained/

FDR_ASD = mafdr(p1_ASD,'BHFDR', true);
p1_adj_ASD = FDR_ASD';

min_p1_adj_ASD = min(p1_adj_ASD,[],'all');
[kadj_ASD ladj_ASD] = find(p1_adj_ASD==min_p1_adj_ASD);


pcond_ASD = p1_adj_ASD; 
sig_vals_cond_ASD = (pcond_ASD < 0.05);
sigvalscond_final_ASD = ones(1, sum(sig_vals_cond_ASD));
sigvalscond_final_ASD(sigvalscond_final_ASD==1) =1.5;

% set plotting variables
std1_final_ASD = Cond1_final_ASD';
std2_final_ASD = Cond2_final_ASD';

% calculate means and sem
std1_mn_ASD = mean(std1_final_ASD, 1);
std1_sem_ASD = std(std1_final_ASD, [], 1)./sqrt(size(std1_final_ASD, 1));
std1_lo_ASD = std1_mn_ASD - std1_sem_ASD;
std1_hi_ASD = std1_mn_ASD + std1_sem_ASD;

std2_mn_ASD = mean(std2_final_ASD, 1);
std2_sem_ASD = std(std2_final_ASD, [], 1)./sqrt(size(std2_final_ASD, 1));
std2_lo_ASD = std2_mn_ASD - std2_sem_ASD;
std2_hi_ASD = std2_mn_ASD + std2_sem_ASD;

clear

% Cluster based permutation test for between groups std2-std2 difference
% time points will be clustered, only channel Fz line plotted so no
% channel-based clustering 

diff_TD = ERP.child.st2_TD-ERP.child.st1_TD;   % time x subjects
diff_ASD = ERP.child.st2_ASD-ERP.child.st1_ASD; % time x subjects

% build the FieldTrip structures:

TD_ft.trial  = permute(diff_TD, [2 3 1]);  % subjects x 1 channel x time
TD_ft.dimord = 'rpt_chan_time';            % rpt = subjects (units that get shuffled)
TD_ft.label  = {'Fz'};
TD_ft.time   = linspace(-0.1, 0.5, size(diff_TD,1));  % seconds

ASD_ft.trial  = permute(diff_ASD, [2 3 1]);
ASD_ft.dimord = 'rpt_chan_time';
ASD_ft.label  = {'Fz'};
ASD_ft.time   = TD_ft.time;

% Set cluster based analysis settings

cfg = [];
cfg.channel          = 'all';
cfg.latency          = 'all';
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 10000;
cfg.neighbours(1).label      = 'Fz';
cfg.neighbours(1).neighblabel = {};

% Run cluster-based permutation test: TD vs ASD, Std2 - Std1 difference (children)
cfg.design = [ones(1, size(diff_TD,2)), 2*ones(1, size(diff_ASD,2))];  % 1 = TD, 2 = ASD
cfg.ivar   = 1;
%  rng(42) % fix shuffles 
stat_out = ft_timelockstatistics(cfg, TD_ft, ASD_ft);

% Extract the significant time points for plotting and add to a table

sig_vals_diff = stat_out.mask(:)';  % 1 x time, logical: 1 = time point inside a significant cluster
sig_vals_diff_final = 0.5 * ones(1, sum(sig_vals_diff));  % y-position of the significance bar

clust_table = table();

if isfield(stat_out, 'posclusters')
    for i = 1:numel(stat_out.posclusters)
        idx = find(stat_out.posclusterslabelmat == i);
        clust_table = [clust_table; table({'positive'}, i, stat_out.time(idx(1))*1000, stat_out.time(idx(end))*1000, stat_out.posclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','p'})];
    end
end

if isfield(stat_out, 'negclusters')
    for i = 1:numel(stat_out.negclusters)
        idx = find(stat_out.negclusterslabelmat == i);
        clust_table = [clust_table; table({'negative'}, i, stat_out.time(idx(1))*1000, stat_out.time(idx(end))*1000, stat_out.negclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','p'})];
    end
end

% get diff std2-std1 arrys in both groups for plotting later on

diff_TD_2 = diff_TD';
diff_ASD_2 = diff_ASD';

diff_mn_TD = mean(diff_TD_2, 1);
diff_sem_TD = std(diff_TD_2, [], 1)./sqrt(size(diff_TD_2, 1));
diff_lo_TD = diff_mn_TD - diff_sem_TD;
diff_hi_TD = diff_mn_TD + diff_sem_TD;

diff_mn_ASD = mean(diff_ASD_2, 1);
diff_sem_ASD = std(diff_ASD_2, [], 1)./sqrt(size(diff_ASD_2, 1));
diff_lo_ASD = diff_mn_ASD - diff_sem_ASD;
diff_hi_ASD = diff_mn_ASD + diff_sem_ASD;


% get time vector (soft-coded to data length) for plotting later on 
time = linspace(-100, 500, size(std1_mn_TD, 2));
n_TD  = size(Cond1_final_TD, 2);
n_ASD = size(Cond1_final_ASD, 2);


% Save everything the ERP plot needs - children
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\' ...
    'input_arrays\ERP_plotdata_children.mat'], ...
     'std1_mn_TD','std1_lo_TD','std1_hi_TD', ...
     'std2_mn_TD','std2_lo_TD','std2_hi_TD', ...
     'sigvalscond_final_TD', 'sig_vals_cond_TD', ... 
     'std1_mn_ASD','std1_lo_ASD','std1_hi_ASD', ...
     'std2_mn_ASD','std2_lo_ASD','std2_hi_ASD', ...
     'sigvalscond_final_ASD','sig_vals_cond_ASD', ...
     'diff_mn_TD','diff_lo_TD','diff_hi_TD', ...
     'diff_mn_ASD','diff_lo_ASD','diff_hi_ASD', ...
     'sig_vals_diff', 'sig_vals_diff_final', ...
     'time', 'n_TD','n_ASD', ...
     'clust_table','stat_out');


clearvars -except ERP 

%% Do permutation Analysis - ADOLESCENTS

% TD
Cond1_final_TD = ERP.adolescent.st1_TD; % (points X subject)
Cond2_final_TD = ERP.adolescent.st2_TD; % (points X subject)

alldata_TD = cat(2,Cond1_final_TD, Cond2_final_TD);

N_TD = floor (size (alldata_TD, 2)/2);

conds_TD = cat(1,ones(N_TD,1),2*ones(N_TD,1)); % condition labels

nPerms = 500;
for permi=1:nPerms
    fconds = randperm(N_TD*2);
    fconds(fconds<N_TD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_TD(:, :, permi) = alldata_TD (:,fconds==2) - alldata_TD(:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
Obs_diff_TD = mean((Cond2_final_TD-Cond1_final_TD),2);
Perm_diff_TD = squeeze(mean(permdiffs_TD, 2)); 


    for i = 1: size (Perm_diff_TD, 1)
        zVal_TD(i) = (Obs_diff_TD(i)-mean(Perm_diff_TD(i,:))) / std(Perm_diff_TD(i,:));
    end

    zVal_TD = zVal_TD';

clearvars i  


for i = 1: size(zVal_TD,1)
      p1_TD(i) = 2*(1-normcdf(abs(zVal_TD(i))));
end

p1_TD = p1_TD';
min_p1_TD = min(p1_TD,[],'all');
[k l] = find(p1_TD==min_p1_TD);

% Adjust p values for multiple comparisons (https://www.r-bloggers.com/2023/07/the-benjamini-hochberg-procedure-fdr-and-p-value-adjusted-explained/

FDR_TD = mafdr(p1_TD,'BHFDR', true);
p1_adj_TD = FDR_TD';

min_p1_adj_TD = min(p1_adj_TD,[],'all');
[kadj_TD ladj_TD] = find(p1_adj_TD==min_p1_adj_TD);


pcond_TD = p1_adj_TD; 
sig_vals_cond_TD = (pcond_TD < 0.05);
sigvalscond_final_TD = ones(1, sum(sig_vals_cond_TD));
sigvalscond_final_TD(sigvalscond_final_TD==1) =2.6;

% set plotting variables
std1_final_TD = Cond1_final_TD';
std2_final_TD = Cond2_final_TD';

% calculate means and sem
std1_mn_TD = mean(std1_final_TD, 1);
std1_sem_TD = std(std1_final_TD, [], 1)./sqrt(size(std1_final_TD, 1));
std1_lo_TD = std1_mn_TD - std1_sem_TD;
std1_hi_TD = std1_mn_TD + std1_sem_TD;

std2_mn_TD = mean(std2_final_TD, 1);
std2_sem_TD = std(std2_final_TD, [], 1)./sqrt(size(std2_final_TD, 1));
std2_lo_TD = std2_mn_TD - std2_sem_TD;
std2_hi_TD = std2_mn_TD + std2_sem_TD;


% ASD

Cond1_final_ASD = ERP.adolescent.st1_ASD;
Cond2_final_ASD = ERP.adolescent.st2_ASD;

alldata_ASD = cat(2,Cond1_final_ASD, Cond2_final_ASD);

N_ASD = floor (size (alldata_ASD, 2)/2);

conds_ASD = cat(1,ones(N_ASD,1),2*ones(N_ASD,1)); % condition labels

nPerms = 500;
for permi=1:nPerms
    fconds = randperm(N_ASD*2);
    fconds(fconds<N_ASD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_ASD(:, :, permi) = alldata_ASD (:,fconds==2) - alldata_ASD(:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
Obs_diff_ASD = mean((Cond2_final_ASD-Cond1_final_ASD),2);
Perm_diff_ASD = squeeze(mean(permdiffs_ASD, 2)); 


    for i = 1: size (Perm_diff_ASD, 1)
        zVal_ASD(i) = (Obs_diff_ASD(i)-mean(Perm_diff_ASD(i,:))) / std(Perm_diff_ASD(i,:));
    end

    zVal_ASD = zVal_ASD';

clearvars i  


for i = 1: size(zVal_ASD,1)
      p1_ASD(i) = 2*(1-normcdf(abs(zVal_ASD(i))));
end

p1_ASD = p1_ASD';
min_p1_ASD = min(p1_ASD,[],'all');
[k l] = find(p1_ASD==min_p1_ASD);

% Adjust p values for multiple comparisons 

FDR_ASD = mafdr(p1_ASD,'BHFDR', true);
p1_adj_ASD = FDR_ASD';

min_p1_adj_ASD = min(p1_adj_ASD,[],'all');
[kadj_ASD ladj_ASD] = find(p1_adj_ASD==min_p1_adj_ASD);


pcond_ASD = p1_adj_ASD; 
sig_vals_cond_ASD = (pcond_ASD < 0.05);
sigvalscond_final_ASD = ones(1, sum(sig_vals_cond_ASD));
sigvalscond_final_ASD(sigvalscond_final_ASD==1) =2.6;

% set plotting variables
std1_final_ASD = Cond1_final_ASD';
std2_final_ASD = Cond2_final_ASD';

% calculate means and sem
std1_mn_ASD = mean(std1_final_ASD, 1);
std1_sem_ASD = std(std1_final_ASD, [], 1)./sqrt(size(std1_final_ASD, 1));
std1_lo_ASD = std1_mn_ASD - std1_sem_ASD;
std1_hi_ASD = std1_mn_ASD + std1_sem_ASD;

std2_mn_ASD = mean(std2_final_ASD, 1);
std2_sem_ASD = std(std2_final_ASD, [], 1)./sqrt(size(std2_final_ASD, 1));
std2_lo_ASD = std2_mn_ASD - std2_sem_ASD;
std2_hi_ASD = std2_mn_ASD + std2_sem_ASD;


% Cluster based permutation test for between groups std2-std2 difference
% time points will be clustered, only channel Fz line plotted so no
% channel-based clustering 

diff_TD = ERP.adolescent.st2_TD-ERP.adolescent.st1_TD;
diff_ASD = ERP.adolescent.st2_ASD-ERP.adolescent.st1_ASD;

% build the FieldTrip structures:

TD_ft.trial  = permute(diff_TD, [2 3 1]);  % subjects x 1 channel x time
TD_ft.dimord = 'rpt_chan_time';            % rpt = subjects (units that get shuffled)
TD_ft.label  = {'Fz'};
TD_ft.time   = linspace(-0.1, 0.5, size(diff_TD,1));  % seconds

ASD_ft.trial  = permute(diff_ASD, [2 3 1]);
ASD_ft.dimord = 'rpt_chan_time';
ASD_ft.label  = {'Fz'};
ASD_ft.time   = TD_ft.time;

% Set cluster based analysis settings

cfg = [];
cfg.channel          = 'all';
cfg.latency          = 'all';
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 10000;
cfg.neighbours(1).label      = 'Fz';
cfg.neighbours(1).neighblabel = {};

% Run cluster-based permutation test: TD vs ASD, Std2 - Std1 difference (children)
cfg.design = [ones(1, size(diff_TD,2)), 2*ones(1, size(diff_ASD,2))];  % 1 = TD, 2 = ASD
cfg.ivar   = 1;
stat_out = ft_timelockstatistics(cfg, TD_ft, ASD_ft);

% Extract the significant time points for plotting and add to a table

sig_vals_diff = stat_out.mask(:)';  % 1 x time, logical: 1 = time point inside a significant cluster
sig_vals_diff_final = 0.5 * ones(1, sum(sig_vals_diff));  % y-position of the significance bar

clust_table = table();

if isfield(stat_out, 'posclusters')
    for i = 1:numel(stat_out.posclusters)
        idx = find(stat_out.posclusterslabelmat == i);
        clust_table = [clust_table; table({'positive'}, i, stat_out.time(idx(1))*1000, stat_out.time(idx(end))*1000, stat_out.posclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','p'})];
    end
end

if isfield(stat_out, 'negclusters')
    for i = 1:numel(stat_out.negclusters)
        idx = find(stat_out.negclusterslabelmat == i);
        clust_table = [clust_table; table({'negative'}, i, stat_out.time(idx(1))*1000, stat_out.time(idx(end))*1000, stat_out.negclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','p'})];
    end
end


% get diff std2-std1 arrys in both groups for plotting later on

diff_TD_2 = diff_TD';
diff_ASD_2 = diff_ASD';

diff_mn_TD = mean(diff_TD_2, 1);
diff_sem_TD = std(diff_TD_2, [], 1)./sqrt(size(diff_TD_2, 1));
diff_lo_TD = diff_mn_TD - diff_sem_TD;
diff_hi_TD = diff_mn_TD + diff_sem_TD;

diff_mn_ASD = mean(diff_ASD_2, 1);
diff_sem_ASD = std(diff_ASD_2, [], 1)./sqrt(size(diff_ASD_2, 1));
diff_lo_ASD = diff_mn_ASD - diff_sem_ASD;
diff_hi_ASD = diff_mn_ASD + diff_sem_ASD;


% get time vector (soft-coded to data length) for plotting later on 
time = linspace(-100, 500, size(std1_mn_TD, 2));
n_TD  = size(Cond1_final_TD, 2);
n_ASD = size(Cond1_final_ASD, 2);


% Save everything the ERP plot needs - children
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\' ...
    'input_arrays\ERP_plotdata_adolescents.mat'], ...
     'std1_mn_TD','std1_lo_TD','std1_hi_TD', ...
     'std2_mn_TD','std2_lo_TD','std2_hi_TD', ...
     'sigvalscond_final_TD', 'sig_vals_cond_TD', ... 
     'std1_mn_ASD','std1_lo_ASD','std1_hi_ASD', ...
     'std2_mn_ASD','std2_lo_ASD','std2_hi_ASD', ...
     'sigvalscond_final_ASD','sig_vals_cond_ASD', ...
     'diff_mn_TD','diff_lo_TD','diff_hi_TD', ...
     'diff_mn_ASD','diff_lo_ASD','diff_hi_ASD', ...
     'sig_vals_diff', 'sig_vals_diff_final', ...
     'time', 'n_TD','n_ASD', ...
     'clust_table','stat_out');


clearvars -except ERP 

%% Do permutation Analysis - ADULTS


% TD
Cond1_final_TD = ERP.adult.st1_TD; % (points X subject)
Cond2_final_TD = ERP.adult.st2_TD; % (points X subject)

alldata_TD = cat(2,Cond1_final_TD, Cond2_final_TD);

N_TD = floor (size (alldata_TD, 2)/2);

conds_TD = cat(1,ones(N_TD,1),2*ones(N_TD,1)); % condition labels

nPerms = 500;
for permi=1:nPerms
    fconds = randperm(N_TD*2);
    fconds(fconds<N_TD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_TD(:, :, permi) = alldata_TD (:,fconds==2) - alldata_TD(:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
Obs_diff_TD = mean((Cond2_final_TD-Cond1_final_TD),2);
Perm_diff_TD = squeeze(mean(permdiffs_TD, 2)); 


    for i = 1: size (Perm_diff_TD, 1)
        zVal_TD(i) = (Obs_diff_TD(i)-mean(Perm_diff_TD(i,:))) / std(Perm_diff_TD(i,:));
    end

    zVal_TD = zVal_TD';

clearvars i  


for i = 1: size(zVal_TD,1)
      p1_TD(i) = 2*(1-normcdf(abs(zVal_TD(i))));
end

p1_TD = p1_TD';
min_p1_TD = min(p1_TD,[],'all');
[k l] = find(p1_TD==min_p1_TD);

% Adjust p values for multiple comparisons

FDR_TD = mafdr(p1_TD,'BHFDR', true);
p1_adj_TD = FDR_TD';

min_p1_adj_TD = min(p1_adj_TD,[],'all');
[kadj_TD ladj_TD] = find(p1_adj_TD==min_p1_adj_TD);


pcond_TD = p1_adj_TD; 
sig_vals_cond_TD = (pcond_TD < 0.05);
sigvalscond_final_TD = ones(1, sum(sig_vals_cond_TD));
sigvalscond_final_TD(sigvalscond_final_TD==1) =2.6;

% set plotting variables
std1_final_TD = Cond1_final_TD';
std2_final_TD = Cond2_final_TD';

% calculate means and sem
std1_mn_TD = mean(std1_final_TD, 1);
std1_sem_TD = std(std1_final_TD, [], 1)./sqrt(size(std1_final_TD, 1));
std1_lo_TD = std1_mn_TD - std1_sem_TD;
std1_hi_TD = std1_mn_TD + std1_sem_TD;

std2_mn_TD = mean(std2_final_TD, 1);
std2_sem_TD = std(std2_final_TD, [], 1)./sqrt(size(std2_final_TD, 1));
std2_lo_TD = std2_mn_TD - std2_sem_TD;
std2_hi_TD = std2_mn_TD + std2_sem_TD;


% ASD

Cond1_final_ASD = ERP.adult.st1_ASD;
Cond2_final_ASD = ERP.adult.st2_ASD;

alldata_ASD = cat(2,Cond1_final_ASD, Cond2_final_ASD);

N_ASD = floor (size (alldata_ASD, 2)/2);

conds_ASD = cat(1,ones(N_ASD,1),2*ones(N_ASD,1)); % condition labels

nPerms = 500;
for permi=1:nPerms
    fconds = randperm(N_ASD*2);
    fconds(fconds<N_ASD+1) = 1;
    fconds(fconds>1) = 2;
    permdiffs_ASD(:, :, permi) = alldata_ASD (:,fconds==2) - alldata_ASD(:,fconds==1);
end
clearvars permi fconds

% Get observed difference (difference between real / not permutated means)
Obs_diff_ASD = mean((Cond2_final_ASD-Cond1_final_ASD),2);
Perm_diff_ASD = squeeze(mean(permdiffs_ASD, 2)); 


    for i = 1: size (Perm_diff_ASD, 1)
        zVal_ASD(i) = (Obs_diff_ASD(i)-mean(Perm_diff_ASD(i,:))) / std(Perm_diff_ASD(i,:));
    end

    zVal_ASD = zVal_ASD';

clearvars i  


for i = 1: size(zVal_ASD,1)
      p1_ASD(i) = 2*(1-normcdf(abs(zVal_ASD(i))));
end

p1_ASD = p1_ASD';
min_p1_ASD = min(p1_ASD,[],'all');
[k l] = find(p1_ASD==min_p1_ASD);

% Adjust p values for multiple comparisons 

FDR_ASD = mafdr(p1_ASD,'BHFDR', true);
p1_adj_ASD = FDR_ASD';

min_p1_adj_ASD = min(p1_adj_ASD,[],'all');
[kadj_ASD ladj_ASD] = find(p1_adj_ASD==min_p1_adj_ASD);


pcond_ASD = p1_adj_ASD; 
sig_vals_cond_ASD = (pcond_ASD < 0.05);
sigvalscond_final_ASD = ones(1, sum(sig_vals_cond_ASD));
sigvalscond_final_ASD(sigvalscond_final_ASD==1) =2.6;

% set plotting variables
std1_final_ASD = Cond1_final_ASD';
std2_final_ASD = Cond2_final_ASD';

% calculate means and sem
std1_mn_ASD = mean(std1_final_ASD, 1);
std1_sem_ASD = std(std1_final_ASD, [], 1)./sqrt(size(std1_final_ASD, 1));
std1_lo_ASD = std1_mn_ASD - std1_sem_ASD;
std1_hi_ASD = std1_mn_ASD + std1_sem_ASD;

std2_mn_ASD = mean(std2_final_ASD, 1);
std2_sem_ASD = std(std2_final_ASD, [], 1)./sqrt(size(std2_final_ASD, 1));
std2_lo_ASD = std2_mn_ASD - std2_sem_ASD;
std2_hi_ASD = std2_mn_ASD + std2_sem_ASD;


% Cluster based permutation test for between groups std2-std2 difference
% time points will be clustered, 

diff_TD = ERP.adult.st2_TD-ERP.adult.st1_TD;
diff_ASD = ERP.adult.st2_ASD-ERP.adult.st1_ASD;

% build the FieldTrip structures:

TD_ft.trial  = permute(diff_TD, [2 3 1]);  % subjects x 1 channel x time
TD_ft.dimord = 'rpt_chan_time';            % rpt = subjects (units that get shuffled)
TD_ft.label  = {'Fz'};
TD_ft.time   = linspace(-0.1, 0.5, size(diff_TD,1));  % seconds

ASD_ft.trial  = permute(diff_ASD, [2 3 1]);
ASD_ft.dimord = 'rpt_chan_time';
ASD_ft.label  = {'Fz'};
ASD_ft.time   = TD_ft.time;

% Set cluster based analysis settings

cfg = [];
cfg.channel          = 'all';
cfg.latency          = 'all';
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 10000;
cfg.neighbours(1).label      = 'Fz';
cfg.neighbours(1).neighblabel = {};

% Run cluster-based permutation test: TD vs ASD, Std2 - Std1 difference (children)
cfg.design = [ones(1, size(diff_TD,2)), 2*ones(1, size(diff_ASD,2))];  % 1 = TD, 2 = ASD
cfg.ivar   = 1;
stat_out = ft_timelockstatistics(cfg, TD_ft, ASD_ft);

% Extract the significant time points for plotting and add to a table

sig_vals_diff = stat_out.mask(:)';  % 1 x time, logical: 1 = time point inside a significant cluster
sig_vals_diff_final = 0.5 * ones(1, sum(sig_vals_diff));  % y-position of the significance bar

clust_table = table();

if isfield(stat_out, 'posclusters')
    for i = 1:numel(stat_out.posclusters)
        idx = find(stat_out.posclusterslabelmat == i);
        clust_table = [clust_table; table({'positive'}, i, stat_out.time(idx(1))*1000, stat_out.time(idx(end))*1000, stat_out.posclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','p'})];
    end
end

if isfield(stat_out, 'negclusters')
    for i = 1:numel(stat_out.negclusters)
        idx = find(stat_out.negclusterslabelmat == i);
        clust_table = [clust_table; table({'negative'}, i, stat_out.time(idx(1))*1000, stat_out.time(idx(end))*1000, stat_out.negclusters(i).prob, ...
            'VariableNames', {'sign','cluster','start_ms','end_ms','p'})];
    end
end


% get diff std2-std1 arrys in both groups for plotting later on

diff_TD_2 = diff_TD';
diff_ASD_2 = diff_ASD';

diff_mn_TD = mean(diff_TD_2, 1);
diff_sem_TD = std(diff_TD_2, [], 1)./sqrt(size(diff_TD_2, 1));
diff_lo_TD = diff_mn_TD - diff_sem_TD;
diff_hi_TD = diff_mn_TD + diff_sem_TD;

diff_mn_ASD = mean(diff_ASD_2, 1);
diff_sem_ASD = std(diff_ASD_2, [], 1)./sqrt(size(diff_ASD_2, 1));
diff_lo_ASD = diff_mn_ASD - diff_sem_ASD;
diff_hi_ASD = diff_mn_ASD + diff_sem_ASD;


% get time vector (soft-coded to data length) for plotting later on 
time = linspace(-100, 500, size(std1_mn_TD, 2));
n_TD  = size(Cond1_final_TD, 2);
n_ASD = size(Cond1_final_ASD, 2);


% Save everything the ERP plot needs - children
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\' ...
    'input_arrays\ERP_plotdata_adults.mat'], ...
     'std1_mn_TD','std1_lo_TD','std1_hi_TD', ...
     'std2_mn_TD','std2_lo_TD','std2_hi_TD', ...
     'sigvalscond_final_TD', 'sig_vals_cond_TD', ... 
     'std1_mn_ASD','std1_lo_ASD','std1_hi_ASD', ...
     'std2_mn_ASD','std2_lo_ASD','std2_hi_ASD', ...
     'sigvalscond_final_ASD','sig_vals_cond_ASD', ...
     'diff_mn_TD','diff_lo_TD','diff_hi_TD', ...
     'diff_mn_ASD','diff_lo_ASD','diff_hi_ASD', ...
     'sig_vals_diff', 'sig_vals_diff_final', ...
     'time', 'n_TD','n_ASD', ...
     'clust_table','stat_out');


clear all

%% plot

input_dir = ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\' ...
    'input_arrays\'];
agegroups = {'children','adolescents','adults'};
rowlabels = {'Children','Adolescents','Adults'};
nrows = numel(agegroups); ncols = 3;
fs = 14;   % font size for ticks and labels
fst = 20;   % title font size

figure(1)
set(gcf, 'Position', [50 50 1000 1100]);

for r = 1:nrows
    D = load([input_dir 'ERP_plotdata_' agegroups{r} '.mat']);
    t = D.time;

    % ---- Column 1: TD ----
    subplot(nrows, ncols, (r-1)*ncols + 1); hold on
    fill([t fliplr(t)], [D.std1_lo_TD fliplr(D.std1_hi_TD)],...
        [0.6 0.6 0.6], 'EdgeColor','none', 'FaceAlpha',0.3,...
        'HandleVisibility','off');
    fill([t fliplr(t)], [D.std2_lo_TD fliplr(D.std2_hi_TD)],...
        [1 0.6 0.6], 'EdgeColor','none', 'FaceAlpha',0.3,...
        'HandleVisibility','off');
    plot(t, D.std1_mn_TD, 'Color', [0.3 0.3 0.3], 'LineWidth', 1.5,...
        'DisplayName','Std 1');
    plot(t, D.std2_mn_TD, 'Color', [1 0 0], 'LineWidth', 1.5,...
        'DisplayName','Std 2');
    plot(t(logical(D.sig_vals_cond_TD)), D.sigvalscond_final_TD,...
        'r_', 'LineWidth', 3, 'MarkerSize', 8, 'DisplayName','p<.05');
    xlim([-100 500]); ylim([-5 4]);
    plot([0 0], ylim, 'k--', 'HandleVisibility','off'); yline(0,'g--',...
        'LineWidth', 1.5,'HandleVisibility','off');
    if r == 1
        title(sprintf('TD n = %d', D.n_TD), 'FontSize', fst);
        legend('Box','off','Location','southeast');
    else
        title(sprintf('n = %d', D.n_TD));
    end
    if r < nrows, set(gca,'xticklabel',[]); end
    ylabel(rowlabels{r}, 'FontWeight','bold');
    set(gca,'FontSize',fs,'box','off','TickDir','out');

    % ---- Column 2: ASD ----
    subplot(nrows, ncols, (r-1)*ncols + 2); hold on
    fill([t fliplr(t)], [D.std1_lo_ASD fliplr(D.std1_hi_ASD)], [0.6 0.6 0.6],...
        'EdgeColor','none', 'FaceAlpha',0.3, 'HandleVisibility','off');
    fill([t fliplr(t)], [D.std2_lo_ASD fliplr(D.std2_hi_ASD)], [1 0.6 0.6],...
        'EdgeColor','none', 'FaceAlpha',0.3, 'HandleVisibility','off');
    plot(t, D.std1_mn_ASD, 'Color', [0.3 0.3 0.3], 'LineWidth', 1.5);
    plot(t, D.std2_mn_ASD, 'Color', [1 0 0], 'LineWidth', 1.5);
    plot(t(logical(D.sig_vals_cond_ASD)), D.sigvalscond_final_ASD, 'r_',...
        'LineWidth', 3, 'MarkerSize', 8);
    xlim([-100 500]); ylim([-5 4]);
    plot([0 0], ylim, 'k--', 'HandleVisibility','off'); yline(0,'g--',...
        'LineWidth', 1.5,'HandleVisibility','off');
    if r == 1
        title(sprintf('ASD n = %d', D.n_ASD), 'FontSize', fst);
    else
        title(sprintf('n = %d', D.n_ASD));
    end
    if r < nrows, set(gca,'xticklabel',[]); end
    set(gca,'yticklabel',[],'FontSize',fs,'box','off','TickDir','out');

    % ---- Column 3: TD-ASD difference ----
    subplot(nrows, ncols, (r-1)*ncols + 3); hold on
    fill([t fliplr(t)], [D.diff_lo_TD fliplr(D.diff_hi_TD)], [0.6 0.6 0.6],...
        'EdgeColor','none', 'FaceAlpha',0.3, 'HandleVisibility','off');
    fill([t fliplr(t)], [D.diff_lo_ASD fliplr(D.diff_hi_ASD)], [1 0.6 0.6],...
        'EdgeColor','none', 'FaceAlpha',0.3, 'HandleVisibility','off');
    plot(t, D.diff_mn_TD, 'Color', [0.3 0.3 0.3], 'LineWidth', 1.5,...
        'DisplayName','TD');
    plot(t, D.diff_mn_ASD, 'Color', [1 0 0], 'LineWidth', 1.5,...
        'DisplayName','ASD');
    plot(t(logical(D.sig_vals_diff)), D.sig_vals_diff_final, 'r_',...
        'LineWidth', 3, 'MarkerSize', 8, 'DisplayName','Cluster p<.025');
    xlim([-100 500]); ylim([-2 1]);
    plot([0 0], ylim, 'k--', 'HandleVisibility','off'); yline(0,'g--',...
        'LineWidth', 1.5,'HandleVisibility','off');
    if r == 1
        title('Habituation: TD vs ASD', 'FontSize', fst);
        legend('Box','off','Location','northeast');
    end
    if r < nrows, set(gca,'xticklabel',[]); end
    set(gca,'FontSize',fs,'box','off','TickDir','out');
end

% shared axis labels
han = axes(figure(1), 'visible','off'); han.XLim=[0 1]; han.YLim=[0 1];
uistack(han, 'bottom');
text(han, -0.06, 0.5, 'Voltage (\muV)', 'Rotation',90,...
    'HorizontalAlignment','center','FontSize',16,'FontWeight','bold');
text(han, 0.5, -0.06, 'Time (msec)', 'HorizontalAlignment','center',...
    'FontSize',16,'FontWeight','bold');
sgtitle('ERP habituation across age groups','FontSize',20,'FontWeight','bold');



export_folder = ['C:\Users\cigde\Dropbox\Habituation_paper\' ...
    'October_Emily\final_figures\figure_2\'];

exportgraphics(gcf, fullfile(export_folder,'figure2_erp_line_all_ages.pdf'),...
    'ContentType','vector');
exportgraphics(gcf, fullfile(export_folder,'figure2_erp_line_all_ages.png'),...
    'Resolution', 300);
exportgraphics(gcf, fullfile(export_folder,'figure2_erp_line_all_ages.tiff'),...
    'Resolution', 300);


%% end
