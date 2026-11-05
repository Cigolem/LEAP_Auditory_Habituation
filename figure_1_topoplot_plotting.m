
clear all, close all


%% Step 1 Organize TD-child Difference topoplot

% Step 1.1 put all standard 1 and standard 2 str arrays in one str array 

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\child\TD\standard_stim';
subFolders_TD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_TD = subFolders_TD([subFolders_TD.isdir]);        % keep only folders

comments = {'-50 - 0','0 - 50','50 - 100','100 - 150','150 - 200', ...
            '200 - 250','250 - 300','300 - 350','350 - 400','400 - 450'};

standard1_all = cell(1,length(subFolders_TD));
standard2_all = cell(1,length(subFolders_TD));

for ii = 1:length(subFolders_TD)
  folder = fullfile(output_location, subFolders_TD(ii).name);
  load([folder filesep 'standard1.mat']);
  standard1_all(ii)        = { standard1 };
  load([folder filesep 'standard2.mat']);
  standard2_all(ii)      = { standard2 };
end

clearvars -except standard1_all standard2_all comments subFolders_TD


% Step 1.2 Calculate grand average for both conditions separately and their difference

cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard1        = ft_timelockgrandaverage(cfg, standard1_all{:});
grandavg_standard2         = ft_timelockgrandaverage(cfg, standard2_all{:});
grandavg_diff_standard1_standard2 = ft_math(cfg, grandavg_standard2, grandavg_standard1); % std 2 minus std 1
TD_grand = grandavg_diff_standard1_standard2;

% Step 1.3: cluster-based permutation statistics correcting for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder


cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo'; % use the Monte Carlo Method to calculate the significance probability
cfg.statistic             = 'ft_statfun_depsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05; % alpha level of the sample-specific test statistic that will be used for thresholding
cfg.clusterstatistic      = 'maxsum'; % test statistic that will be evaluated under the permutation distribution.
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0; % -1 (one-tailed (negative)), 1 one-tailed (positive) or 0 two-tailed test 
cfg.clustertail           = 0; % detect both positive and negative clusters
cfg.alpha                 = 0.025;% alpha level of the permutation test
                            % final statistical threshold used to evaluate clusters.
                            % Because we used a two-tailed test, the alpha is split                          
cfg.numrandomization      = 1000; 

Nsubj                      = length(subFolders_TD);
cfg.design = zeros(2, Nsubj*2);
cfg.design(1,:) = [1:Nsubj 1:Nsubj];
cfg.design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];
cfg.uvar   = 1; % the unit variable, i.e. subjects
cfg.ivar   = 2; % independent variable, i.e. trials(condition)

stat_standard1_standard2_clusstats  = ft_timelockstatistics(cfg, standard2_all{:}, standard1_all{:});
TD_stat  = stat_standard1_standard2_clusstats;


% Step 1.4 Plot std 2- std1 difference 
% Find clusters with a 5% two-sided cutoff based on the cluster p-values

pos_cluster_pvals       = [TD_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(TD_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [TD_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(TD_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(TD_stat.time);
j                       = [TD_stat.time(1):timestep:TD_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(TD_grand.label, TD_stat.label); % matching channel labels

TD_grand.time(51) = 0;
TD_grand.time(101) = 0.05;


figure(1); clf;
set(gcf,'Position',[100 100 1800 1800])
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(TD_grand.label),1);
  neg_int              = zeros(numel(TD_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
   cfg.comment          = comments{1,k};
   cfg.commentpos       = [0,0.8];
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
   cfg.fontsize     = 20;
  ft_topoplotER(cfg, TD_grand)
  colormap(jet)
end

set(findall(gcf,'Type','text','FontSize',20),'FontWeight','bold')

clearvars -except comments

%% Step 2: Organize ASD child Difference topoplot

% Step 2.1: Put all standard 1 and standard 2 str arrays in one str array 

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\child\ASD\standard_stim';
subFolders_ASD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_ASD = subFolders_ASD([subFolders_ASD.isdir]);        % keep only folders

standard1_all = cell(1,length(subFolders_ASD));
standard2_all = cell(1,length(subFolders_ASD));

for ii = 1:length(subFolders_ASD)
  folder = fullfile(output_location, subFolders_ASD(ii).name);
  load([folder filesep 'standard1.mat']);
  standard1_all(ii)        = { standard1 };
  load([folder filesep 'standard2.mat']);
  standard2_all(ii)      = { standard2 };
end

clearvars -except standard1_all standard2_all comments subFolders_ASD


%Step 2.2: Calculate grand average for both conditions separately and their difference
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard1        = ft_timelockgrandaverage(cfg, standard1_all{:});
grandavg_standard2         = ft_timelockgrandaverage(cfg, standard2_all{:});
grandavg_diff_standard1_standard2 = ft_math(cfg, grandavg_standard2, grandavg_standard1); % std 2 minus std 1
ASD_grand = grandavg_diff_standard1_standard2;

%Step 2.3: Cluster-based permutation statistics correcting for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes with ft_timelockstatistics

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_depsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 

Nsubj                      = length(subFolders_ASD);
cfg.design = zeros(2, Nsubj*2);
cfg.design(1,:) = [1:Nsubj 1:Nsubj];
cfg.design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];
cfg.uvar   = 1; % the unit variable, i.e. subjects
cfg.ivar   = 2; % independent variable, i.e. trials(condition)

stat_standard1_standard2_clusstats  = ft_timelockstatistics(cfg, standard2_all{:}, standard1_all{:});
ASD_stat  = stat_standard1_standard2_clusstats;


% Step 2.4: std 2- std1 difference
% Find clusters with a 5% two-sided cutoff based on the cluster p-values

pos_cluster_pvals       = [ASD_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(ASD_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [ASD_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(ASD_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(ASD_stat.time);
j                       = [ASD_stat.time(1):timestep:ASD_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(ASD_grand.label, ASD_stat.label); % matching channel labels

ASD_grand.time(51) = 0;
ASD_grand.time(101) = 0.05;


figure(1);
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,10+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(ASD_grand.label),1);
  neg_int              = zeros(numel(ASD_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
   % cfg.comment          = comments{1,k};
   % cfg.commentpos       = [0,0.8];
   cfg.comment = 'no';
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
   cfg.fontsize     = 20;
  ft_topoplotER(cfg, ASD_grand)
  colormap(jet)
end


%% Step 3: Calculate group difference and plot Children

clearvars -except comments

% Step 3.1: put all standard_diff_TD and  standard_diff_ASD arrays in one array

% TD
cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\child\TD\standard_stim';
subFolders_TD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_TD = subFolders_TD([subFolders_TD.isdir]);        % keep only folders

standard_diff_TD_all = cell(1,length(subFolders_TD));

for ii = 1:length(subFolders_TD)
  folder = fullfile(output_location, subFolders_TD(ii).name);
  load([folder filesep 'standard_diff_TD.mat']);
  standard_diff_TD_all(ii)        = { standard_diff_TD };
end
clearvars ii

% ASD
cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\child\ASD\standard_stim';
subFolders_ASD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_ASD = subFolders_ASD([subFolders_ASD.isdir]);        % keep only folders

standard_diff_ASD_all = cell(1,length(subFolders_ASD));

for ii = 1:length(subFolders_ASD)
  folder = fullfile(output_location, subFolders_ASD(ii).name);
  load([folder filesep 'standard_diff_ASD.mat']);
  standard_diff_ASD_all(ii)        = { standard_diff_ASD };
end

clearvars -except standard_diff_TD_all standard_diff_ASD_all comments

% Step 3.2: Calculate difference TD - ASD
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard_diff_TD          = ft_timelockgrandaverage(cfg, standard_diff_TD_all{:});
grandavg_standard_diff_ASD         = ft_timelockgrandaverage(cfg, standard_diff_ASD_all{:});
grandavg_diff_standard_TD_ASD = ft_math(cfg, grandavg_standard_diff_TD, grandavg_standard_diff_ASD); % TD - ASD
DIFF_grand = grandavg_diff_standard_TD_ASD;

% Step 3.3: Perform cluster-based permutation statistics correcting 
% for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes with ft_timelockstatistics

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_indepsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
 cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 
Nsubj                      = length(standard_diff_TD_all) + length(standard_diff_ASD_all);
n_TD  = length(standard_diff_TD_all);
n_ASD  = length(standard_diff_ASD_all);
cfg.design           = [ones(1,n_TD), ones(1,n_ASD)*2];
cfg.ivar   = 1; % the independent variable, i.e. subjects

stat_standard_diff_TD_ASD_clusstats  = ft_timelockstatistics(cfg, standard_diff_TD_all{:}, standard_diff_ASD_all{:});
DIFF_stat  = stat_standard_diff_TD_ASD_clusstats;


% Step 3.4: Plot TD-ASD difference topoplots

% Find clusters with a 5% two-sided cutoff based on the cluster p-values
pos_cluster_pvals       = [DIFF_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(DIFF_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [DIFF_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(DIFF_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(DIFF_stat.time);
j                       = [DIFF_stat.time(1):timestep:DIFF_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(DIFF_grand.label, DIFF_stat.label); % matching channel labels

DIFF_grand.time(51) = 0;
DIFF_grand.time(101) = 0.05;

figure(1); 
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,20+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(DIFF_grand.label),1);
  neg_int              = zeros(numel(DIFF_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
  %  cfg.comment          = comments{1,k};
  % cfg.commentpos       = [0,0.8];
  cfg.comment = 'no';
   cfg.fontsize     = 16;
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
  % cfg.figure = 'gca';
  ft_topoplotER(cfg, DIFF_grand)
  colormap(jet)
  % sgt = sgtitle('(std 2 - std 1) TD - ASD Children','Color','red', 'FontSize', 20);
end

% sgtitle('Children: Std2 - Std1 (TD / ASD / TD-ASD)', 'Color','red','FontSize',20);

clearvars -except comments

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Step 1 Organize TD-adolescent Difference topoplot

% Step 1.1 put all standard 1 and standard 2 str arrays in one str array 

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adolescent\TD\standard_stim';
subFolders_TD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_TD = subFolders_TD([subFolders_TD.isdir]);        % keep only folders

standard1_all = cell(1,length(subFolders_TD));
standard2_all = cell(1,length(subFolders_TD));

for ii = 1:length(subFolders_TD)
  folder = fullfile(output_location, subFolders_TD(ii).name);
  load([folder filesep 'standard1.mat']);
  standard1_all(ii)        = { standard1 };
  load([folder filesep 'standard2.mat']);
  standard2_all(ii)      = { standard2 };
end

clearvars -except standard1_all standard2_all comments subFolders_TD


% Step 1.2 Calculate grand average for both conditions (std1, std2) separately 
% and their difference

cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard1        = ft_timelockgrandaverage(cfg, standard1_all{:});
grandavg_standard2         = ft_timelockgrandaverage(cfg, standard2_all{:});
grandavg_diff_standard1_standard2 = ft_math(cfg, grandavg_standard2, grandavg_standard1); % std 2 minus std 1
TD_grand = grandavg_diff_standard1_standard2;

% Step 1.3: Perform cluster-based permutation statistics 
% correcting for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_depsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 

Nsubj                      = length(subFolders_TD);
cfg.design = zeros(2, Nsubj*2);
cfg.design(1,:) = [1:Nsubj 1:Nsubj];
cfg.design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];
cfg.uvar   = 1; % the unit variable, i.e. subjects
cfg.ivar   = 2; % independent variable, i.e. trials(condition)

stat_standard1_standard2_clusstats  = ft_timelockstatistics(cfg, standard2_all{:}, standard1_all{:});
TD_stat  = stat_standard1_standard2_clusstats;


% Step 1.4 Plot std 2- std1 difference 
% Find clusters with a 5% two-sided cutoff based on the cluster p-values

pos_cluster_pvals       = [TD_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(TD_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [TD_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(TD_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(TD_stat.time);
j                       = [TD_stat.time(1):timestep:TD_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(TD_grand.label, TD_stat.label); % matching channel labels

TD_grand.time(51) = 0;
TD_grand.time(101) = 0.05;


figure(1); 
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,30+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(TD_grand.label),1);
  neg_int              = zeros(numel(TD_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
   % cfg.comment          = comments{1,k};
   % cfg.commentpos       = [0,0.8];
   cfg.comment          = 'no';
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
   cfg.fontsize     = 16;
  % cfg.figure = 'gca';
  ft_topoplotER(cfg, TD_grand)
  colormap(jet)
  % sgt = sgtitle('TD Children Std 2 - Std 1','Color','red', 'FontSize', 20);
end


clearvars -except comments

%% Step 2: Organize ASD Adolescent Difference topoplot

% Step 2.1: Put all standard 1 and standard 2 str arrays in one str array 

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adolescent\ASD\standard_stim';
subFolders_ASD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_ASD = subFolders_ASD([subFolders_ASD.isdir]);        % keep only folders

standard1_all = cell(1,length(subFolders_ASD));
standard2_all = cell(1,length(subFolders_ASD));

for ii = 1:length(subFolders_ASD)
  folder = fullfile(output_location, subFolders_ASD(ii).name);
  load([folder filesep 'standard1.mat']);
  standard1_all(ii)        = { standard1 };
  load([folder filesep 'standard2.mat']);
  standard2_all(ii)      = { standard2 };
end

clearvars -except standard1_all standard2_all comments subFolders_ASD


%Step 2.2: Calculate grand average for both conditions separately and their difference
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard1        = ft_timelockgrandaverage(cfg, standard1_all{:});
grandavg_standard2         = ft_timelockgrandaverage(cfg, standard2_all{:});
grandavg_diff_standard1_standard2 = ft_math(cfg, grandavg_standard2, grandavg_standard1); % std 2 minus std 1
ASD_grand = grandavg_diff_standard1_standard2;

%Step 2.3: Perform cluster-based permutation statistics correcting 
% for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes with ft_timelockstatistics

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_depsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 

Nsubj                      = length(subFolders_ASD);
cfg.design = zeros(2, Nsubj*2);
cfg.design(1,:) = [1:Nsubj 1:Nsubj];
cfg.design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];
cfg.uvar   = 1; % the unit variable, i.e. subjects
cfg.ivar   = 2; % independent variable, i.e. trials(condition)

stat_standard1_standard2_clusstats  = ft_timelockstatistics(cfg, standard2_all{:}, standard1_all{:});
ASD_stat  = stat_standard1_standard2_clusstats;


% Step 2.4: std 2- std1 difference
% Find clusters with a 5% two-sided cutoff based on the cluster p-values

pos_cluster_pvals       = [ASD_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(ASD_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [ASD_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(ASD_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(ASD_stat.time);
j                       = [ASD_stat.time(1):timestep:ASD_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(ASD_grand.label, ASD_stat.label); % matching channel labels

ASD_grand.time(51) = 0;
ASD_grand.time(101) = 0.05;


figure(1);
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,40+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(ASD_grand.label),1);
  neg_int              = zeros(numel(ASD_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
   % cfg.comment          = comments{1,k};
   % cfg.commentpos       = [0,0.8];
   cfg.comment = 'no';
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
   cfg.fontsize     = 16;
  ft_topoplotER(cfg, ASD_grand)
  colormap(jet)
end


%% Step 3: Calculate group difference and plot adolescents

clearvars -except comments

% Step 3.1: put all standard_diff_TD and  standard_diff_ASD arrays in one array

% TD
cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adolescent\TD\standard_stim';
subFolders_TD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_TD = subFolders_TD([subFolders_TD.isdir]);        % keep only folders

standard_diff_TD_all = cell(1,length(subFolders_TD));

for ii = 1:length(subFolders_TD)
  folder = fullfile(output_location, subFolders_TD(ii).name);
  load([folder filesep 'standard_diff_TD.mat']);
  standard_diff_TD_all(ii)        = { standard_diff_TD };
end
clearvars ii

% ASD
cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adolescent\ASD\standard_stim';
subFolders_ASD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_ASD = subFolders_ASD([subFolders_ASD.isdir]);        % keep only folders

standard_diff_ASD_all = cell(1,length(subFolders_ASD));

for ii = 1:length(subFolders_ASD)
  folder = fullfile(output_location, subFolders_ASD(ii).name);
  load([folder filesep 'standard_diff_ASD.mat']);
  standard_diff_ASD_all(ii)        = { standard_diff_ASD };
end

clearvars -except standard_diff_TD_all standard_diff_ASD_all comments

% Step 3.2: Calculate difference TD - ASD
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard_diff_TD          = ft_timelockgrandaverage(cfg, standard_diff_TD_all{:});
grandavg_standard_diff_ASD         = ft_timelockgrandaverage(cfg, standard_diff_ASD_all{:});
grandavg_diff_standard_TD_ASD = ft_math(cfg, grandavg_standard_diff_TD, grandavg_standard_diff_ASD); % TD - ASD
DIFF_grand = grandavg_diff_standard_TD_ASD;

% Step 3.3: Perform cluster-based permutation statistics correcting 
% for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes with ft_timelockstatistics

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_indepsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
 cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 
Nsubj                      = length(standard_diff_TD_all) + length(standard_diff_ASD_all);
n_TD  = length(standard_diff_TD_all);
n_ASD  = length(standard_diff_ASD_all);
cfg.design           = [ones(1,n_TD), ones(1,n_ASD)*2];
cfg.ivar   = 1; % the independent variable, i.e. subjects

stat_standard_diff_TD_ASD_clusstats  = ft_timelockstatistics(cfg, standard_diff_TD_all{:}, standard_diff_ASD_all{:});
DIFF_stat  = stat_standard_diff_TD_ASD_clusstats;


% Step 3.4: Plot TD-ASD difference topoplots

% Find clusters with a 5% two-sided cutoff based on the cluster p-values
pos_cluster_pvals       = [DIFF_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(DIFF_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [DIFF_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(DIFF_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(DIFF_stat.time);
j                       = [DIFF_stat.time(1):timestep:DIFF_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(DIFF_grand.label, DIFF_stat.label); % matching channel labels

DIFF_grand.time(51) = 0;
DIFF_grand.time(101) = 0.05;

figure(1); 
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,50+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(DIFF_grand.label),1);
  neg_int              = zeros(numel(DIFF_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
  %  cfg.comment          = comments{1,k};
  % cfg.commentpos       = [0,0.8];
  cfg.comment = 'no';
   cfg.fontsize     = 16;
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
  ft_topoplotER(cfg, DIFF_grand)
  colormap(jet)
end

clearvars -except comments

%% Step 1 Organize TD-adults Difference topoplot

% Step 1.1 put all standard 1 and standard 2 str arrays in one str array 

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adult\TD\standard_stim';
subFolders_TD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_TD = subFolders_TD([subFolders_TD.isdir]);        % keep only folders

standard1_all = cell(1,length(subFolders_TD));
standard2_all = cell(1,length(subFolders_TD));

for ii = 1:length(subFolders_TD)
  folder = fullfile(output_location, subFolders_TD(ii).name);
  load([folder filesep 'standard1.mat']);
  standard1_all(ii)        = { standard1 };
  load([folder filesep 'standard2.mat']);
  standard2_all(ii)      = { standard2 };
end

clearvars -except standard1_all standard2_all comments subFolders_TD


% Step 1.2 Calculate grand average for both conditions separately and their difference

cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard1        = ft_timelockgrandaverage(cfg, standard1_all{:});
grandavg_standard2         = ft_timelockgrandaverage(cfg, standard2_all{:});
grandavg_diff_standard1_standard2 = ft_math(cfg, grandavg_standard2, grandavg_standard1); % std 2 minus std 1
TD_grand = grandavg_diff_standard1_standard2;

% Step 1.3: Cluster-based permutation statistics correcting for multiple comparisons
% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes 
% with ft_timelockstatistics

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_depsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 

Nsubj                      = length(subFolders_TD);
cfg.design = zeros(2, Nsubj*2);
cfg.design(1,:) = [1:Nsubj 1:Nsubj];
cfg.design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];
cfg.uvar   = 1; % the unit variable, i.e. subjects
cfg.ivar   = 2; % independent variable, i.e. trials(condition)

stat_standard1_standard2_clusstats  = ft_timelockstatistics(cfg, standard2_all{:}, standard1_all{:});
TD_stat  = stat_standard1_standard2_clusstats;


% Step 1.4 Plot std 2- std1 difference 
% Find clusters with a 5% two-sided cutoff based on the cluster p-values

pos_cluster_pvals       = [TD_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(TD_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [TD_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(TD_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(TD_stat.time);
j                       = [TD_stat.time(1):timestep:TD_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(TD_grand.label, TD_stat.label); % matching channel labels

TD_grand.time(51) = 0;
TD_grand.time(101) = 0.05;


figure(1); 
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,60+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(TD_grand.label),1);
  neg_int              = zeros(numel(TD_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
   % cfg.comment          = comments{1,k};
   cfg.commentpos       = [0,0.8];
   cfg.comment          = 'no';
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
   cfg.fontsize     = 16;
  ft_topoplotER(cfg, TD_grand)
  colormap(jet)
end


clearvars -except comments 

%% Step 2: Organize ASD adult Difference topoplot

% Step 2.1: Put all standard 1 and standard 2 str arrays in one str array 

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adult\ASD\standard_stim';
subFolders_ASD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_ASD = subFolders_ASD([subFolders_ASD.isdir]);        % keep only folders

standard1_all = cell(1,length(subFolders_ASD));
standard2_all = cell(1,length(subFolders_ASD));

for ii = 1:length(subFolders_ASD)
  folder = fullfile(output_location, subFolders_ASD(ii).name);
  load([folder filesep 'standard1.mat']);
  standard1_all(ii)        = { standard1 };
  load([folder filesep 'standard2.mat']);
  standard2_all(ii)      = { standard2 };
end

clearvars -except standard1_all standard2_all comments subFolders_ASD


%Step 2.2: Calculate grand average for both conditions separately and their difference
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard1        = ft_timelockgrandaverage(cfg, standard1_all{:});
grandavg_standard2         = ft_timelockgrandaverage(cfg, standard2_all{:});
grandavg_diff_standard1_standard2 = ft_math(cfg, grandavg_standard2, grandavg_standard1); % std 2 minus std 1
ASD_grand = grandavg_diff_standard1_standard2;

%Step 2.3: Cluster-based permutation statistics correcting for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes with ft_timelockstatistics

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_depsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 

Nsubj                      = length(subFolders_ASD);
cfg.design = zeros(2, Nsubj*2);
cfg.design(1,:) = [1:Nsubj 1:Nsubj];
cfg.design(2,:) = [ones(1,Nsubj) ones(1,Nsubj)*2];
cfg.uvar   = 1; % the unit variable, i.e. subjects
cfg.ivar   = 2; % independent variable, i.e. trials(condition)

stat_standard1_standard2_clusstats  = ft_timelockstatistics(cfg, standard2_all{:}, standard1_all{:});
ASD_stat  = stat_standard1_standard2_clusstats;


% Step 2.4: std 2- std1 difference
% Find clusters with a 5% two-sided cutoff based on the cluster p-values

pos_cluster_pvals       = [ASD_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(ASD_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [ASD_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(ASD_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(ASD_stat.time);
j                       = [ASD_stat.time(1):timestep:ASD_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(ASD_grand.label, ASD_stat.label); % matching channel labels

ASD_grand.time(51) = 0;
ASD_grand.time(101) = 0.05;


figure(1);
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,70+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(ASD_grand.label),1);
  neg_int              = zeros(numel(ASD_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
   % cfg.comment          = comments{1,k};
   % cfg.commentpos       = [0,0.8];
   cfg.comment = 'no';
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
   cfg.fontsize     = 16;
  % cfg.figure = 'gca';
  ft_topoplotER(cfg, ASD_grand)
  colormap(jet)
  % sgt = sgtitle('ASD Children Std 2 - Std 1','Color','red', 'FontSize', 20);
end


%% Step 3: Calculate group difference and plot

clearvars -except comments

% Step 3.1: put all standard_diff_TD and  standard_diff_ASD arrays in one array

% TD
cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adult\TD\standard_stim';
subFolders_TD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_TD = subFolders_TD([subFolders_TD.isdir]);        % keep only folders

standard_diff_TD_all = cell(1,length(subFolders_TD));

for ii = 1:length(subFolders_TD)
  folder = fullfile(output_location, subFolders_TD(ii).name);
  load([folder filesep 'standard_diff_TD.mat']);
  standard_diff_TD_all(ii)        = { standard_diff_TD };
end
clearvars ii

% ASD
cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load LEAP_layout.mat
output_location = 'D:\LEAP_ERP\CLUSTER_ft\RS\adult\ASD\standard_stim';
subFolders_ASD = dir(fullfile(output_location,'s*'));   % finds s001, s002 etc
subFolders_ASD = subFolders_ASD([subFolders_ASD.isdir]);        % keep only folders

standard_diff_ASD_all = cell(1,length(subFolders_ASD));

for ii = 1:length(subFolders_ASD)
  folder = fullfile(output_location, subFolders_ASD(ii).name);
  load([folder filesep 'standard_diff_ASD.mat']);
  standard_diff_ASD_all(ii)        = { standard_diff_ASD };
end

clearvars -except standard_diff_TD_all standard_diff_ASD_all comments

% Step 3.2: Calculate difference TD - ASD
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
cfg.operation             = 'subtract';
grandavg_standard_diff_TD          = ft_timelockgrandaverage(cfg, standard_diff_TD_all{:});
grandavg_standard_diff_ASD         = ft_timelockgrandaverage(cfg, standard_diff_ASD_all{:});
grandavg_diff_standard_TD_ASD = ft_math(cfg, grandavg_standard_diff_TD, grandavg_standard_diff_ASD); % TD - ASD
DIFF_grand = grandavg_diff_standard_TD_ASD;

% Step 3.3: Cluster-based permutation statistics correcting for multiple comparisons

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load neighbours_triangulation.mat % prepared before and saved in the folder

% rmpath('eeglab2023.1\') % remove eeglab from the path otherwise it interferes with ft_timelockstatistics

cfg                       = [];
cfg.channel               = 'eeg';
cfg.latency               = 'all';
cfg.method                = 'montecarlo';
cfg.statistic             = 'ft_statfun_indepsamplesT';
cfg.correctm              = 'cluster';
cfg.clusteralpha          = 0.05;
cfg.clusterstatistic      = 'maxsum';
cfg.minnbchan             = 2;
cfg.neighbours            = neighbours;
cfg.tail                  = 0;
cfg.clustertail           = 0;
 cfg.alpha                 = 0.025;
cfg.numrandomization      = 1000; 
Nsubj                      = length(standard_diff_TD_all) + length(standard_diff_ASD_all);
n_TD  = length(standard_diff_TD_all);
n_ASD  = length(standard_diff_ASD_all);
cfg.design           = [ones(1,n_TD), ones(1,n_ASD)*2];
cfg.ivar   = 1; % the independent variable, i.e. subjects

stat_standard_diff_TD_ASD_clusstats  = ft_timelockstatistics(cfg, standard_diff_TD_all{:}, standard_diff_ASD_all{:});
DIFF_stat  = stat_standard_diff_TD_ASD_clusstats;


% Step 3.4: Plot TD-ASD difference topoplots

% Find clusters with a 5% two-sided cutoff based on the cluster p-values
pos_cluster_pvals       = [DIFF_stat.posclusters(:).prob];
pos_clust               = find(pos_cluster_pvals < 0.025);
pos                     = ismember(DIFF_stat.posclusterslabelmat, pos_clust);

neg_cluster_pvals       = [DIFF_stat.negclusters(:).prob];
neg_clust               = find(neg_cluster_pvals < 0.025);
neg                     = ismember(DIFF_stat.negclusterslabelmat, neg_clust);


% define parameters for plotting
timestep      = 0.05; % plot every 0.05 sec intervals
sampling_rate = 1000; 
sample_count            = length(DIFF_stat.time);
j                       = [DIFF_stat.time(1):timestep:DIFF_stat.time(end)]; % start of each interval for plotting in seconds
m                       = [1:timestep*sampling_rate:sample_count]; % start of each interval for plotting in sample points
[i1,i2] = match_str(DIFF_grand.label, DIFF_stat.label); % matching channel labels

DIFF_grand.time(51) = 0;
DIFF_grand.time(101) = 0.05;

figure(1); 
for k = 1:10

  cfg                  = [];
  cfg.plotrad          = 0.62;
  cfg.headrad          = 0.62;
  cfg.figure           = subplot(9,10,80+k);
  cfg.xlim             = [j(k) j(k+1)]; % current interval
  cfg.zlim             = [-1.5 1.5]; % set minimum and maximum z-axis
  pos_int              = zeros(numel(DIFF_grand.label),1);
  neg_int              = zeros(numel(DIFF_grand.label),1);
  pos_int(i1)          = all(pos(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (pos cluster)
  neg_int(i1)          = all(neg(i2, m(k):m(k+1)),2); % determine which channels are in a cluster throughout the current time interval (neg cluster)

  cfg.highlight        = {'on', 'on'};
  cfg.layout           =  'LEAP_layout.lay';
  cfg.highlightchannel = {find(pos_int), find(neg_int)}; % highlight channels belonging to a cluster
  cfg.highlightcolor = {'k', 'r'}; % Black (positive clusters (std2 > std1); red (negative clusters ( std2 < std1))
  cfg.highlightsymbol = {'*', '*'}; % star for both
  %  cfg.comment          = comments{1,k};
  % cfg.commentpos       = [0,0.8];
  cfg.comment = 'no';
   cfg.fontsize     = 16;
   cfg.interactive      = 'no';
   cfg.style           = 'straight';
  ft_topoplotER(cfg, DIFF_grand)
  colormap(jet)
end

colormap(jet)

h = colorbar;
h.Position = [0.92 0.15 0.015 0.7];   % [left bottom width height]
caxis([-1.5 1.5])
h.Label.String = 'Amplitude difference (\muV)';
h.Label.FontSize = 20;   % label text
h.FontSize = 16;         % tick numbers (-1.5 ... 1.5)


annotation('textbox',[0 0.96 1 0.04],...
           'String','Scalp Distribution: Standard 2 - Standard 1',...
           'EdgeColor','none',...
           'HorizontalAlignment','center',...
           'FontSize',20,'FontWeight','bold',...
           'Color','black');

% Widen the Adolescents row labels on the existing figure
% delete(findall(gcf,'Type','textboxshape'))   % clears only the annotation textboxes


annotation('textbox',[0.045 0.86 0.09 0.05],'String','Children TD','EdgeColor','none', 'fontsize', 16)
annotation('textbox',[0.045 0.77 0.09 0.05],'String','Children ASD','EdgeColor','none', 'fontsize', 16)
annotation('textbox',[0.045 0.68 0.12 0.05],'String','Children TD-ASD','EdgeColor','none', 'fontsize', 16)

annotation('textbox',[0.045 0.58 0.13 0.05],'String','Adolescents TD','EdgeColor','none', 'fontsize', 16)
annotation('textbox',[0.045 0.49 0.13 0.05],'String','Adolescents ASD','EdgeColor','none', 'fontsize', 16)
annotation('textbox',[0.025 0.39 0.14 0.05],'String','Adolescents TD-ASD','EdgeColor','none', 'fontsize', 16)

annotation('textbox',[0.045 0.30 0.09 0.05],'String','Adults TD','EdgeColor','none', 'fontsize', 16)
annotation('textbox',[0.045 0.21 0.09 0.05],'String','Adults ASD','EdgeColor','none', 'fontsize', 16)
annotation('textbox',[0.045 0.11 0.09 0.05],'String','Adults TD-ASD','EdgeColor','none', 'fontsize', 16)

% add panel letters for the three age blocks
annotation('textbox',[0.005 0.90 0.03 0.04],'String','A','EdgeColor','none','FontSize',22,'FontWeight','bold')
annotation('textbox',[0.005 0.62 0.03 0.04],'String','B','EdgeColor','none','FontSize',22,'FontWeight','bold')
annotation('textbox',[0.005 0.34 0.03 0.04],'String','C','EdgeColor','none','FontSize',22,'FontWeight','bold')

% delete(findall(gcf,'Type','textboxshape')) % use this when you want to
% change coordinate / size for annotations

export_folder = 'C:\Users\cigde\Dropbox\Habituation_paper\August_submission\final_figures\';

fig = findall(0,'Type','figure');

exportgraphics(fig(1), fullfile(export_folder,'figure1_topos.pdf'), 'ContentType','vector');
exportgraphics(fig(1), fullfile(export_folder,'figure1_topos.png'), 'Resolution', 400);
exportgraphics(fig(1), fullfile(export_folder,'figure1_topos.tiff'), 'Resolution', 400);
%% end


