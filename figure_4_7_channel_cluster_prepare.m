
clear all
close all

%% STEP 1: Define anatomical channel clusters (channels that form fronto-central cluster)


  clusters.frontocentral = {'AF7', 'AF8', ...
                          'F1', 'F2', 'F3', 'F4', 'Fz', ...
                          'FC1', 'FC2', 'FC3', 'FC4', 'FCz', ...
                          'C1', 'C2', 'C3', 'C4'};

                         
%% STEP 2: Define time windows

time_windows.W50_100 = [0.05, 0.10];    % 50-100ms
time_windows.W100_150 = [0.10, 0.15];   % 100-150ms
time_windows.W150_200 = [0.15, 0.20];   % 150-200ms
time_windows.W200_250 = [0.20, 0.25];   % 200-250ms
time_windows.W250_300 = [0.25, 0.30];   % 250-300ms


%% STEP 3: Extract all data and export to CSV

% Initialize results table
results = table();

% SETTINGS
base_path         = 'D:\LEAP_ERP\CLUSTER_ft\Repetition Suppression';
output_folder     = 'C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\pls_regression\';
age_groups        = {'child', 'adolescent', 'adult'};
diagnostic_groups = {'TD', 'ASD'};

% Cluster names
cluster_names = fieldnames(clusters);


% Time window names
window_names = fieldnames(time_windows);

fprintf('Starting extraction for all subjects...\n\n');

% Loop through age groups
for age_idx = 1:length(age_groups)
    age_group = age_groups{age_idx};

    % Loop through diagnostic groups (TD, ASD)
    for diag_idx = 1:length(diagnostic_groups)
        diag_group = diagnostic_groups{diag_idx};

        % Set path
        group_path = fullfile(base_path, age_group, diag_group, 'standard_stim');

        % Get subject folders
        subj_folders = dir(fullfile(group_path, 's*'));
        subj_folders = subj_folders([subj_folders.isdir]);

        fprintf('Processing %s %s: %d subjects\n', age_group, diag_group, length(subj_folders));

        % Loop through subjects
        for subj_idx = 1:length(subj_folders)
            subj_id = subj_folders(subj_idx).name;
            subj_path = fullfile(group_path, subj_id);

            % Load difference data
            S = load(fullfile(subj_path, ['standard_diff_' diag_group '.mat']));
            diff_data = S.(['standard_diff_' diag_group]);

            % Initialize row for this subject
            row = table();
            row.SubjectID = {subj_id};
            row.UniqueID = {diff_data.subjectID};
            row.Group = {diag_group};
            row.Age_Group = {age_group};

            % Extract for each cluster and time window
            for clust_idx = 1:length(cluster_names)
                cluster_name = cluster_names{clust_idx};
                chan_list = clusters.(cluster_name);

                % Find channel indices
                [~, chan_idx] = ismember(chan_list, diff_data.label);
                chan_idx = chan_idx(chan_idx > 0);

                for win_idx = 1:length(window_names)
                    window_name = window_names{win_idx};
                    time_range = time_windows.(window_name);

                    % Find time indices
                    time_idx = find(diff_data.time >= time_range(1) & diff_data.time <= time_range(2));

                    % Extract mean amplitude
                    diff_amp = mean(mean(diff_data.avg(chan_idx, time_idx), 2), 1);

                    % Add to row with column name like "frontal_Early"
                    col_name = sprintf('%s_%s', cluster_name, window_name);
                    row.(col_name) = diff_amp;
                end
            end

            % Append row to results
            results = [results; row];
        end
    end
end

%% Step 4: Export to CSV

output_file = fullfile(output_folder, 'cluster_RS_all_ages.csv'); % Define output folder
writetable(results, output_file);




