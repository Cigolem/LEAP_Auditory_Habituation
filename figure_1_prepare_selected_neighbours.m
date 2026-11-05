
%% Prepare using ft_prepare_neighbours

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
load channels.mat 
load LEAP_layout.mat

cfg                      = [];
cfg.layout               = 'LEAP_layout.lay'; 
cfg.channel = channels;
cfg.method = 'triangulation';


[neighbours]=ft_prepare_neighbours(cfg);

clearvars -except channels lay

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
save neighbours_triangulation neighbours  -v7.3


% Define output folder
output_folder = 'C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\';
output_file = fullfile(output_folder, 'neighbours_triangulation.csv');

% Convert struct to table
T = struct2table(neighbours);
writetable(T, output_file);

%% Prepare manually

for i = 1: length(standard1.label)
selected_neighbours(i).label = standard1.label{i};
end



for i = 1: length(standard1.label)
selected_neighbours{i}.neighblabel = standard1.label{i};
end

selected_neighbours(1).neighblabel = {'Fp1','AF4','AF8','F2','F4'}; % Fp2
selected_neighbours(2).neighblabel = {'Fp2','AF3','AF7','F1','F3'}; % Fp1
selected_neighbours(3).neighblabel = {'Fp2','AF3','AF8','F2','F4'}; % AF4
selected_neighbours(4).neighblabel = {'Fp1','AF4','AF7','F1','F3'}; % AF3
selected_neighbours(5).neighblabel = {'Fp2','AF4','F4','F6','F8'}; % AF8
selected_neighbours(6).neighblabel = {'Fp1','AF3','F3','F5','F7'}; % AF7
selected_neighbours(7).neighblabel = {'AF3','AF4','F1','F2','FC1', 'FCz','FC2'}; % Fz
selected_neighbours(8).neighblabel = {'AF4','Fz','F4','FCz', 'FC2','FC4'}; % F2
selected_neighbours(9).neighblabel = {'AF3','Fz','F3','FCz', 'FC1','FC3'}; % F1
selected_neighbours(10).neighblabel = {'AF4','AF8','F2','F6', 'FC2','FC4'}; % F4
selected_neighbours(11).neighblabel = {'AF3','AF7','F1','F5', 'FC1','FC3'}; % F3
selected_neighbours(12).neighblabel = {'AF4','AF8','F4','F8', 'FC4','FC6'}; % F6
selected_neighbours(13).neighblabel = {'AF3','AF7','F3','F7', 'FC3','FC5'}; % F5
selected_neighbours(14).neighblabel = {'AF8','F6','F4','FC6','FT8'}; % F8
selected_neighbours(15).neighblabel = {'AF7','F5','F3','FC5','FT7'}; % F7
selected_neighbours(16).neighblabel = {'F1','Fz','F2','FC1','FC2', 'C1', 'Cz', 'C2'}; % FCz
selected_neighbours(17).neighblabel = {'Fz','F2','F4','FCz', 'FC4', 'Cz', 'C2', 'C4'}; % FC2
selected_neighbours(18).neighblabel = {'Fz','F1','F3','FCz', 'FC3', 'Cz', 'C1', 'C3'}; % FC1
selected_neighbours(19).neighblabel = {'F2','F4','F6','FC2', 'FC6', 'C2', 'C4', 'C6'}; % FC4
selected_neighbours(20).neighblabel = {'F1','F3','F5','FC1', 'FC5', 'C1', 'C3', 'C5'}; % FC3
selected_neighbours(21).neighblabel = {'F4','F6','F8','FC4', 'FT8', 'C4', 'C6'}; % FC6
selected_neighbours(22).neighblabel = {'F3','F5','F7','FC3', 'FT7', 'C3', 'C5'}; % FC5
selected_neighbours(23).neighblabel = {'F6','F8','FC6', 'C6', 'T8'}; % FT8
selected_neighbours(24).neighblabel = {'F5','F7','FC5', 'C5', 'T7'}; % FT7
selected_neighbours(25).neighblabel = {'FC1','FCz','FC2', 'C1', 'C2', 'CP1', 'CPz', 'CP2'}; % Cz
selected_neighbours(26).neighblabel = {'FCz','FC2','FC4', 'Cz', 'C4', 'CPz', 'CP2', 'CP4'}; % C2
selected_neighbours(27).neighblabel = {'FCz','FC1','FC3', 'Cz', 'C3', 'CPz', 'CP1', 'CP3'}; % C1
selected_neighbours(28).neighblabel = {'FC2','FC4','FC6', 'C2', 'C6', 'CP2', 'CP4', 'CP6'}; % C4
selected_neighbours(29).neighblabel = {'FC1','FC3','FC5', 'C1', 'C5', 'CP1', 'CP3', 'CP5'}; % C3
selected_neighbours(30).neighblabel = {'FC4','FC6','FT8', 'C4', 'T8', 'CP4', 'CP6', 'TP8'}; % C6
selected_neighbours(31).neighblabel = {'FC3','FC5','FT7', 'C3', 'T7', 'CP3', 'CP5', 'TP7'}; % C5
selected_neighbours(32).neighblabel = {'FC6','FT8','C6', 'CP6', 'TP8'}; % T8
selected_neighbours(33).neighblabel = {'FC5','FT7','C5', 'CP5', 'TP7'}; % T7
selected_neighbours(34).neighblabel = {'C6','T8','CP6', 'P6', 'P8'}; % TP8
selected_neighbours(35).neighblabel = {'C5','T7','CP5', 'P5', 'P7'}; % TP7
selected_neighbours(36).neighblabel = {'C4','C6','T8', 'CP4', 'TP8', 'P4', 'P6', 'P8'}; % CP6
selected_neighbours(37).neighblabel = {'C3','C5','T7', 'CP3', 'TP7', 'P3', 'P5', 'P7'}; % CP5
selected_neighbours(38).neighblabel = {'C2','C4','C6', 'CP2', 'CP6', 'P2', 'P4', 'P6'}; % CP4
selected_neighbours(39).neighblabel = {'C1','C3','C5', 'CP1', 'CP5', 'P1', 'P3', 'P5'}; % CP3
selected_neighbours(40).neighblabel = {'Cz','C2','C4', 'CPz', 'CP4', 'Pz', 'P2', 'P4'}; % CP2
selected_neighbours(41).neighblabel = {'Cz','C1','C3', 'CPz', 'CP3', 'Pz', 'P1', 'P3'}; % CP1
selected_neighbours(42).neighblabel = {'Cz','C1','C2', 'CP1', 'CP2', 'Pz', 'P1', 'P2'}; % CPz
selected_neighbours(43).neighblabel = {'CP6','TP8','P6', 'PO8'}; % P8
selected_neighbours(44).neighblabel = {'CP5','TP7','P5', 'PO7'}; % P7
selected_neighbours(45).neighblabel = {'CP4','CP6','TP8', 'P4', 'P8', 'PO4', 'PO8'}; % P6
selected_neighbours(46).neighblabel = {'CP3','CP5','TP7', 'P3', 'P7', 'PO3', 'PO7'}; % P5
selected_neighbours(47).neighblabel = {'CP2','CP4','CP6', 'P2', 'P6', 'PO4', 'PO8'}; % P4
selected_neighbours(48).neighblabel = {'CP1','CP3','CP5', 'P1', 'P5', 'PO3', 'PO7'}; % P3
selected_neighbours(49).neighblabel = {'CPz','CP2','CP4', 'Pz', 'P4', 'POz', 'PO4'}; % P2
selected_neighbours(50).neighblabel = {'CPz','CP1','CP3', 'Pz', 'P3', 'POz', 'PO3'}; % P1
selected_neighbours(51).neighblabel = {'CPz','CP1','CP2', 'P1', 'P2', 'POz', 'PO3', 'PO4'}; % Pz
selected_neighbours(52).neighblabel = {'P7','P5','P3', 'PO3', 'O1'}; % PO7
selected_neighbours(53).neighblabel = {'P8','P6','P4', 'PO4', 'O2'}; % PO8
selected_neighbours(54).neighblabel = {'P2','P4','POz', 'PO8', 'O2'}; % PO4
selected_neighbours(55).neighblabel = {'P1','P3','POz', 'PO7', 'O1'}; % PO3
selected_neighbours(56).neighblabel = {'Pz','PO3','PO4', 'Oz'}; % POz
selected_neighbours(57).neighblabel = {'POz','PO8','PO4', 'Oz'}; % O2
selected_neighbours(58).neighblabel = {'POz','PO7','PO3', 'Oz'}; % O1
selected_neighbours(59).neighblabel = {'POz','PO3','PO4', 'O1','O2'}; % Oz

cd('C:\Users\cigde\MATLAB Drive\MMN_Study\ERP_analysis\ERP_Habit\CLUSTER_FT\')
save neighbours_manual selected_neighbours  -v7.3

%% end









