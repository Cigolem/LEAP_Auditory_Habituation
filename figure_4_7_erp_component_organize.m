
clear all

%% Step 1: Load ERP_features array 

load('C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\ERP_features_all_ages.mat')

%% Step 2 : Extract Std2 - Std1 difference scores for all age groups 

age_groups = {'child','adol','adult'};
group_names = {'TD', 'ASD'};

% Collector variables
all_IDs    = {};
all_group  = {};
all_age    = {};
all_sid    = {};
all_P1_amp = []; all_N1_amp = []; all_P2_amp = []; all_N2_amp = [];
all_P1_lat = []; all_N1_lat = []; all_P2_lat = []; all_N2_lat = [];

for ag = 1:numel(age_groups)
    age_label = age_groups{ag};

    age_data = ERP_features.(age_label);

    for gr = 1:numel(group_names)
        grp = group_names{gr};

        S1 = age_data.([grp '_Std1']);
        S2 = age_data.([grp '_Std2']);
        n1 = numel(S1);
        n2 = numel(S2);

        % Extract Std1
        nm1=cell(n1,1); a1_p1=nan(n1,1); a1_n1=nan(n1,1); a1_p2=nan(n1,1); a1_n2=nan(n1,1);
        l1_p1=nan(n1,1); l1_n1=nan(n1,1); l1_p2=nan(n1,1); l1_n2=nan(n1,1);
        for i = 1:n1
            nm1{i}   = S1(i).name;
            a1_p1(i) = S1(i).P1_Amp; a1_n1(i) = S1(i).N1_Amp;
            a1_p2(i) = S1(i).P2_Amp; a1_n2(i) = S1(i).N2_Amp;
            l1_p1(i) = S1(i).P1_Time; l1_n1(i) = S1(i).N1_Time;
            l1_p2(i) = S1(i).P2_Time; l1_n2(i) = S1(i).N2_Time;
        end

        % Extract Std2
        nm2=cell(n2,1); a2_p1=nan(n2,1); a2_n1=nan(n2,1); a2_p2=nan(n2,1); a2_n2=nan(n2,1);
        l2_p1=nan(n2,1); l2_n1=nan(n2,1); l2_p2=nan(n2,1); l2_n2=nan(n2,1);
        for i = 1:n2
            nm2{i}   = S2(i).name;
            a2_p1(i) = S2(i).P1_Amp; a2_n1(i) = S2(i).N1_Amp;
            a2_p2(i) = S2(i).P2_Amp; a2_n2(i) = S2(i).N2_Amp;
            l2_p1(i) = S2(i).P1_Time; l2_n1(i) = S2(i).N1_Time;
            l2_p2(i) = S2(i).P2_Time; l2_n2(i) = S2(i).N2_Time;
        end

        % Match subjects
        [~, idx1, idx2] = intersect(nm1, nm2, 'stable');
        n_matched = numel(idx1);
        
        % Stack
        all_sid    = [all_sid; compose('s%03d', (1:n_matched)')];
        all_IDs    = [all_IDs;    nm1(idx1)];
        all_group  = [all_group;  repmat({grp},       n_matched, 1)];
        all_age    = [all_age;    repmat({age_label},  n_matched, 1)];
        all_P1_amp = [all_P1_amp; a2_p1(idx2) - a1_p1(idx1)];
        all_N1_amp = [all_N1_amp; a2_n1(idx2) - a1_n1(idx1)];
        all_P2_amp = [all_P2_amp; a2_p2(idx2) - a1_p2(idx1)];
        all_N2_amp = [all_N2_amp; a2_n2(idx2) - a1_n2(idx1)];
        all_P1_lat = [all_P1_lat; l2_p1(idx2) - l1_p1(idx1)];
        all_N1_lat = [all_N1_lat; l2_n1(idx2) - l1_n1(idx1)];
        all_P2_lat = [all_P2_lat; l2_p2(idx2) - l1_p2(idx1)];
        all_N2_lat = [all_N2_lat; l2_n2(idx2) - l1_n2(idx1)];
    end
end


%% Step 3: build table and write to CSV

T_out = table(all_sid, all_IDs, all_group, all_age, ...
    all_P1_amp, all_N1_amp, all_P2_amp, all_N2_amp, ...
    all_P1_lat, all_N1_lat, all_P2_lat, all_N2_lat, ...
'VariableNames', {'SubjectID', 'UniqueID', 'group', 'age_group', ...
'P1_amp_diff', 'N1_amp_diff', 'P2_amp_diff', 'N2_amp_diff', ...
'P1_lat_diff', 'N1_lat_diff', 'P2_lat_diff', 'N2_lat_diff'});


output_folder = 'C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\pls_regression\';
output_file = fullfile(output_folder, 'component_RS_all_ages.csv');
writetable(T_out, output_file);

%% end
