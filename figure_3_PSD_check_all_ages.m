
clear all close all

%% CHILD TD - PSD check before ERSP computation

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'MADE_TD_child_habit_all.mat'])

Habituation.child.TD_st1 = MADE.channel_data_st1;
Habituation.child.TD_st2 = MADE.channel_data_st2;

% st1 
for i = 1: length(Habituation.child.TD_st1)
    for j = 1: size (Habituation.child.TD_st1{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.child.TD_st1{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.child.TD_st1)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.child.TD_st2)
    for j = 1: size (Habituation.child.TD_st2{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.child.TD_st2{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.child.TD_st2)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

% Get frequency array for using in plotting 
[~, f_final] = PSD_RS_core(Habituation.child.TD_st1{1,1}(1,:));
save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'f_final_PSD_check.mat'], 'f_final')

figure(1)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 TD Child')

%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 TD Child')

% no exclusion in TD child

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_TD_child.tiff'], 'Resolution', 300)

clearvars -except f_final Habituation  

%% CHILD ASD

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'MADE_ASD_child_habit_all.mat'])

Habituation.child.ASD_st1 = MADE.channel_data_st1;
Habituation.child.ASD_st2 = MADE.channel_data_st2;

% st1 
for i = 1: length(Habituation.child.ASD_st1)
    for j = 1: size (Habituation.child.ASD_st1{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.child.ASD_st1{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.child.ASD_st1)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.child.ASD_st2)
    for j = 1: size (Habituation.child.ASD_st2{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.child.ASD_st2{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.child.ASD_st2)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(2)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 ASD Child')

%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 ASD Child')

% number 4 excluded in ASD (from visual inspection of plots) 

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_ASD_child_before_exc.tiff'], 'Resolution', 300)

% dtermine the outlier and remove from habituation array 
iqr_k = 2.5;
isout = @(x) x < quantile(x,0.25) - iqr_k*iqr(x) | x > quantile(x,0.75) + iqr_k*iqr(x);
excl = find(isout(mean(PSD_all_st1,2)) | isout(mean(PSD_all_st2,2)));
keep = setdiff(1:size(PSD_all_st1,1), excl);
Habituation.child.ASD_st1_exc = Habituation.child.ASD_st1(keep);
Habituation.child.ASD_st2_exc = Habituation.child.ASD_st2(keep);
Habituation.child.ASD_excluded_idx = excl;

clearvars -except f_final Habituation 

% check again after removing the outlier
% st1 
for i = 1: length(Habituation.child.ASD_st1_exc)
    for j = 1: size (Habituation.child.ASD_st1_exc{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.child.ASD_st1_exc{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.child.ASD_st1_exc)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.child.ASD_st2_exc)
    for j = 1: size (Habituation.child.ASD_st2_exc{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.child.ASD_st2_exc{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.child.ASD_st2_exc)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(3)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 ASD Child')

%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 ASD Child')

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_ASD_child_after_exc.tiff'], 'Resolution', 300)


clearvars -except f_final Habituation 

%% ADOLESCENT TD

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'MADE_TD_adolescent_habit_all.mat'])

Habituation.adol.TD_st1 = MADE.channel_data_st1;
Habituation.adol.TD_st2 = MADE.channel_data_st2;

% st1 
for i = 1: length(Habituation.adol.TD_st1)
    for j = 1: size (Habituation.adol.TD_st1{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.adol.TD_st1{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adol.TD_st1)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.adol.TD_st2)
    for j = 1: size (Habituation.adol.TD_st2{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.adol.TD_st2{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adol.TD_st2)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(4)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 TD Adolescent')
%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 TD Adolescent')

% no exclusion in TD adol

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_TD_adol.tiff'], 'Resolution', 300)


clearvars -except f_final Habituation  

%% Adolescent ASD

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'MADE_ASD_adolescent_habit_all.mat'])

Habituation.adol.ASD_st1 = MADE.channel_data_st1;
Habituation.adol.ASD_st2 = MADE.channel_data_st2;

% st1 
for i = 1: length(Habituation.adol.ASD_st1)
    for j = 1: size (Habituation.adol.ASD_st1{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.adol.ASD_st1{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adol.ASD_st1)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.adol.ASD_st2)
    for j = 1: size (Habituation.adol.ASD_st2{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.adol.ASD_st2{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adol.ASD_st2)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(5)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 ASD Adolescent')

%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 ASD Adolescent')

% no exclusion in ASD adolescent 

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_ASD_adol.tiff'], 'Resolution', 300)

clearvars -except f_final Habituation 


%% ADULT TD  

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'MADE_TD_adult_habit_all.mat'])

Habituation.adult.TD_st1 = MADE.channel_data_st1;
Habituation.adult.TD_st2 = MADE.channel_data_st2;

% st1 
for i = 1: length(Habituation.adult.TD_st1)
    for j = 1: size (Habituation.adult.TD_st1{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.adult.TD_st1{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adult.TD_st1)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.adult.TD_st2)
    for j = 1: size (Habituation.adult.TD_st2{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.adult.TD_st2{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adult.TD_st2)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(6)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 TD Adult')
%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 TD Adult')

% number 10 and 15 excluded in TD adult (from visual inspection of plots)

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_TD_adult_before_exc.tiff'], 'Resolution', 300)


% dtermine the outlier and remove from habituation array 
iqr_k = 2.5;
isout = @(x) x < quantile(x,0.25) - iqr_k*iqr(x) | x > quantile(x,0.75) + iqr_k*iqr(x);
excl = find(isout(mean(PSD_all_st1,2)) | isout(mean(PSD_all_st2,2)));
keep = setdiff(1:size(PSD_all_st1,1), excl);
Habituation.adult.TD_st1_exc = Habituation.adult.TD_st1(keep);
Habituation.adult.TD_st2_exc = Habituation.adult.TD_st2(keep);
Habituation.adult.TD_excluded_idx = excl;


% check again after removing outliers
% st1 
for i = 1: length(Habituation.adult.TD_st1_exc)
    for j = 1: size (Habituation.adult.TD_st1_exc{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.adult.TD_st1_exc{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adult.TD_st1_exc)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.adult.TD_st2_exc)
    for j = 1: size (Habituation.adult.TD_st2_exc{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.adult.TD_st2_exc{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adult.TD_st2_exc)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(7)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 TD Adult')
%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 TD Adult')

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_TD_adult_after_exc.tiff'], 'Resolution', 300)

clearvars -except f_final Habituation  


%% Adult ASD

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'MADE_ASD_adult_habit_all.mat'])

Habituation.adult.ASD_st1 = MADE.channel_data_st1;
Habituation.adult.ASD_st2 = MADE.channel_data_st2;

% st1 
for i = 1: length(Habituation.adult.ASD_st1)
    for j = 1: size (Habituation.adult.ASD_st1{1,i}, 1)
    PSD_st1{1,i}(j,:) = PSD_RS_core(Habituation.adult.ASD_st1{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adult.ASD_st1)
    PSD_all_st1(i,:) = mean (PSD_st1{1,i},1);
end

% st2 
for i = 1: length(Habituation.adult.ASD_st2)
    for j = 1: size (Habituation.adult.ASD_st2{1,i}, 1)
    PSD_st2{1,i}(j,:) = PSD_RS_core(Habituation.adult.ASD_st2{1,i}(j,:));
    end
end

clearvars i j

for i = 1: length(Habituation.adult.ASD_st2)
    PSD_all_st2(i,:) = mean (PSD_st2{1,i},1);
end

figure(8)

%std1
subplot (1,2,1)
plot(f_final,PSD_all_st1) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std1 ASD Adult')
%std2
subplot (1,2,2)
plot(f_final,PSD_all_st2) 
set(gca, 'xlim', [0 30])
set(gca, 'xtick', 0:5:30)
xlabel('Frequency (Hz)')
ylabel('log10 Power / Frequency (dB/Hz)')
title('PSD std2 ASD Adult')

% no exclusion in ASD adult 

exportgraphics(gcf, ['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\', ...
    'plots_for_checks\PSD_check_ASD_adult.tiff'], 'Resolution', 300)

clearvars -except Habituation 

% Save Habituation Array

save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'Habituation_arrays_all_ages.mat'], 'Habituation')

%% end - go to figure_3_ERSP_compute_all_age and figure_3_ITPC_compute_all_age scripts 

