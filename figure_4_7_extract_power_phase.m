
clear all

%% Step 1: Extract power - theta, alpha, low beta, high beta 

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'ERSP_habituation_all_ages.mat'])

% Frequency setup
min_freq = 2;
max_freq = 35;
num_frex = 35;
frex = linspace(min_freq, max_freq, num_frex);


% Band indices

bands.slow = frex >= 2 & frex <= 6;
bands.fast_theta    = frex >= 6  & frex < 9;
bands.alpha    = frex >= 9  & frex < 13;
bands.low_beta = frex >= 13 & frex < 20;
bands.high_beta= frex >= 20 & frex <= 30;
band_names = fieldnames(bands);

% Time indices (in 700-point array: 1:200 = baseline, 201:500 = post-stim)
time_windows.baseline  = 1:200;
time_windows.poststim  = 201:500;
time_names = fieldnames(time_windows);

% Age groups and groups
age_groups = {'child', 'adol', 'adult'};
groups     = {'TD', 'ASD'};

% Extract: result stored in PowerRS.(age).(group).(band).(window) = [subjects x 1]
for a = 1:length(age_groups)
    ag = age_groups{a};
    for g = 1:length(groups)
        grp = groups{g};
        
        st1 = ERSP_habit.(ag).([grp '_st1']); % 35 x 700 x N
        st2 = ERSP_habit.(ag).([grp '_st2']); % 35 x 700 x N
        
        for b = 1:length(band_names)
            bn = band_names{b};
            bidx = bands.(bn);
            
            for t = 1:length(time_names)
                tn = time_names{t};
                tidx = time_windows.(tn);
                
                % Mean over frequencies, mean over timepoints -> N x 1
                st1_vals = squeeze(mean(mean(st1(bidx, tidx, :), 1), 2));
                st2_vals = squeeze(mean(mean(st2(bidx, tidx, :), 1), 2));
                
                PowerRS.(ag).(grp).(bn).(tn).st1 = st1_vals;
                PowerRS.(ag).(grp).(bn).(tn).st2 = st2_vals;
                PowerRS.(ag).(grp).(bn).(tn).diff = st2_vals - st1_vals; % RS
            end
        end
    end
end

save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'Power_RS_all_ages.mat'], 'PowerRS', '-v7.3')

clearvars -except PowerRS

%% Step 2: Extract Phase - theta, alpha, low beta, high beta 

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'ITPC_habituation_all_ages.mat'])

% Frequency setup
min_freq = 2;
max_freq = 35;
num_frex = 35;
frex = linspace(min_freq, max_freq, num_frex);


% Band indices
bands.slow = frex >= 2 & frex <= 6;
bands.fast_theta    = frex >= 6  & frex < 9;
bands.alpha    = frex >= 9  & frex < 13;
bands.low_beta = frex >= 13 & frex < 20;
bands.high_beta= frex >= 20 & frex <= 30;
band_names = fieldnames(bands);

% Time indices (in 700-point array: 1:200 = baseline, 201:500 = post-stim)
time_windows.baseline  = 1:200;
time_windows.poststim  = 201:500;
time_names = fieldnames(time_windows);

% Age groups and groups
age_groups = {'child', 'adol', 'adult'};
groups     = {'TD', 'ASD'};

% Extract: result stored in PhaseRS.(age).(group).(band).(window) = [subjects x 1]
for a = 1:length(age_groups)
    ag = age_groups{a};
    for g = 1:length(groups)
        grp = groups{g};
        
        st1 = ITPC_habit.(ag).([grp '_st1']); % 35 x 700 x N
        st2 = ITPC_habit.(ag).([grp '_st2']); % 35 x 700 x N
        
        for b = 1:length(band_names)
            bn = band_names{b};
            bidx = bands.(bn);
            
            for t = 1:length(time_names)
                tn = time_names{t};
                tidx = time_windows.(tn);
                
                % Mean over frequencies, mean over timepoints -> N x 1
                st1_vals = squeeze(mean(mean(st1(bidx, tidx, :), 1), 2));
                st2_vals = squeeze(mean(mean(st2(bidx, tidx, :), 1), 2));
                
                PhaseRS.(ag).(grp).(bn).(tn).st1 = st1_vals;
                PhaseRS.(ag).(grp).(bn).(tn).st2 = st2_vals;
                PhaseRS.(ag).(grp).(bn).(tn).diff = st2_vals - st1_vals; % RS
            end
        end
    end
end

save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'Phase_RS_all_ages.mat'], 'PhaseRS', '-v7.3')

clearvars -except PowerRS PhaseRS

%% Step 3: Export to csv file to move to jupyter lab

% if starting the script at this stape then load power and phase arrays 
% load('C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\Power_RS_all_ages.mat')
% load('C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\Phase_RS_all_ages.mat')

% Step 3.1: load Habitutation array to get the IDs of all
p = 'C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\';
load([p 'Habituation_arrays_all_ages.mat'], 'Habituation')

% Load Bond tables
age_groups = {'child', 'adol', 'adult'};
files = dir([p 'BOND_report_*_Habit_all.mat']);
for k = 1:numel(files)
    S = load([p files(k).name]); f = fieldnames(S); Tb = S.(f{1});
    tok = lower(split(erase(files(k).name, {'BOND_report_','_Habit_all.mat'}), '_'));
    ag  = age_groups{cellfun(@(s) startsWith(tok{2}, s), age_groups)};
    grp = upper(tok{1});
    ids = cellstr(string(Tb.ID));
    if isfield(Habituation.(ag), [grp '_excluded_idx'])
        ids(Habituation.(ag).([grp '_excluded_idx'])) = [];
    end
    BONDids.(ag).(grp) = ids;
end
uid = {};

% Step 3.2: makes and saves the list of the 3 excluded participants.

S1 = load([p 'BOND_report_ASD_Child_Habit_all.mat']); 
S2 = load([p 'BOND_report_TD_Adult_Habit_all.mat']);

S = {S1, S2};  keys = {'child','ASD'; 'adult','TD'};
ersp_itpc_excluded_arrays = {};
for k = 1:numel(S)
    f = fieldnames(S{k});  T = S{k}.(f{1});
    idx = Habituation.(keys{k,1}).([keys{k,2} '_excluded_idx']);
    for i = idx(:)'
        ersp_itpc_excluded_arrays(end+1,:) = [keys(k,:), {i}, table2cell(T(i,'ID'))];
    end
end
save([p 'ersp_itpc_excluded_arrays.mat'], 'ersp_itpc_excluded_arrays')

% Step 3.3: Build the table

age_groups  = {'child', 'adol', 'adult'};
age_labels  = {'child', 'adolescent', 'adult'};  % match your existing CSV labels
groups      = {'TD', 'ASD'};
% band_names  = {'theta', 'alpha', 'low_beta', 'high_beta'};
band_names  = fieldnames(PowerRS.child.TD)';
time_names  = {'baseline', 'poststim'};
conditions  = {'st1', 'st2', 'diff'};
itpc_band_names = fieldnames(PhaseRS.child.TD)';

% Step 3.3.1: Build column headers

col_headers = {'SubjectID', 'Group', 'Age_Group'};
for b = 1:length(band_names)
    for t = 1:length(time_names)
        for c = 1:length(conditions)
            col_headers{end+1} = sprintf('power_%s_%s_%s', band_names{b}, time_names{t}, conditions{c});
        end
    end
end

for b = 1:length(itpc_band_names)
    for t = 1:length(time_names)
        for c = 1:length(conditions)
            col_headers{end+1} = sprintf('itpc_%s_%s_%s', itpc_band_names{b}, time_names{t}, conditions{c});
        end
    end
end

% Step 3.3.2: Build rows
all_rows = {};

for a = 1:length(age_groups)
    ag      = age_groups{a};
    ag_label = age_labels{a};

    for g = 1:length(groups)
        grp = groups{g};

        % Get N from first field
        % N = length(PowerRS.(ag).(grp).theta.baseline.st1);
        N = length(PowerRS.(ag).(grp).(band_names{1}).baseline.st1);

        for i = 1:N
            row = {};
            assert(numel(BONDids.(ag).(grp)) == N, 'ID count mismatch: %s %s', ag, grp)
            uid{end+1,1} = BONDids.(ag).(grp){i};

            % Subject ID, Group, Age_Group
            row{end+1} = sprintf('s%03d', i);
            row{end+1} = grp;
            row{end+1} = ag_label;

            % Power values
            for b = 1:length(band_names)
                bn = band_names{b};
                for t = 1:length(time_names)
                    tn = time_names{t};
                    for c = 1:length(conditions)
                        cn = conditions{c};
                        row{end+1} = PowerRS.(ag).(grp).(bn).(tn).(cn)(i);
                    end
                end
            end

            % ITPC values
            for b = 1:length(itpc_band_names)
                bn = itpc_band_names{b};
                for t = 1:length(time_names)
                    tn = time_names{t};
                    for c = 1:length(conditions)
                        cn = conditions{c};
                        row{end+1} = PhaseRS.(ag).(grp).(bn).(tn).(cn)(i);
                    end
                end
            end

            all_rows{end+1} = row;
        end
    end
end


% Step 3.3: Split all_rows into text columns and a numeric matrix
n_rows = length(all_rows);
n_cols = length(col_headers);

% Step 3.5: Separate text columns (1-3) from numeric columns (4-51)
text_cols = cell(n_rows, 3);
num_matrix = zeros(n_rows, n_cols - 3);

for r = 1:n_rows
    text_cols{r,1} = all_rows{r}{1};  % SubjectID
    text_cols{r,2} = all_rows{r}{2};  % Group
    text_cols{r,3} = all_rows{r}{3};  % Age_Group
    for c = 4:n_cols
        num_matrix(r, c-3) = all_rows{r}{c};
    end
end

% Step 3.4: Build table column by column
T = table(text_cols(:,1), text_cols(:,2), text_cols(:,3), ...
    'VariableNames', {'SubjectID','Group','Age_Group'});

for c = 1:size(num_matrix, 2)
    T.(col_headers{c+3}) = num_matrix(:, c);
end

T = addvars(T, uid, 'After', 'SubjectID', 'NewVariableNames', 'UniqueID');

writetable(T, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\pls_regression\', ...
    'spectral_RS_all_ages.csv'])

%% end
