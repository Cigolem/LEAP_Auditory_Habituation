
%% Step 1: load habituation arrays which has 2500 pts long arrays for all participants

load(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'Habituation_arrays_all_ages.mat'])

% in the habituation array one ASD child (number 4) and 2 TD adult (10 and
% 15) are outliers

%% Step 2: Compute ITPC Children

% TD st1
for i = 1: length(Habituation.child.TD_st1) 
     ITPC_habit.child.TD_st1(:,:,i) = ITPC_cohen_RS_core(Habituation.child.TD_st1{1,i}');
end

clearvars i

ITPC_habit.child.TD_st1 = ITPC_habit.child.TD_st1 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.child.TD_st1,3)));
top =    max(max(mean(ITPC_habit.child.TD_st1,3)));
 
ITPC_habit.child.TD_st1_bottom = bottom;
ITPC_habit.child.TD_st1_top = top;
 
clearvars bottom top

% TD st2
for i = 1: length(Habituation.child.TD_st2) 
     ITPC_habit.child.TD_st2(:,:,i) = ITPC_cohen_RS_core(Habituation.child.TD_st2{1,i}');
end

clearvars i

ITPC_habit.child.TD_st2 = ITPC_habit.child.TD_st2 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.child.TD_st2,3)));
top =    max(max(mean(ITPC_habit.child.TD_st2,3)));
 
ITPC_habit.child.TD_st2_bottom = bottom;
ITPC_habit.child.TD_st2_top = top;
 
clearvars bottom top

% ASD st1
for i = 1: length(Habituation.child.ASD_st1_exc) 
     ITPC_habit.child.ASD_st1(:,:,i) = ITPC_cohen_RS_core(Habituation.child.ASD_st1_exc{1,i}');
end

clearvars i

ITPC_habit.child.ASD_st1 = ITPC_habit.child.ASD_st1 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.child.ASD_st1,3)));
top =    max(max(mean(ITPC_habit.child.ASD_st1,3)));
 
ITPC_habit.child.ASD_st1_bottom = bottom;
ITPC_habit.child.ASD_st1_top = top;
 
clearvars bottom top

% ASD st2
for i = 1: length(Habituation.child.ASD_st2_exc) 
     ITPC_habit.child.ASD_st2(:,:,i) = ITPC_cohen_RS_core(Habituation.child.ASD_st2_exc{1,i}');
end

clearvars i

ITPC_habit.child.ASD_st2 = ITPC_habit.child.ASD_st2 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.child.ASD_st2,3)));
top =    max(max(mean(ITPC_habit.child.ASD_st2,3)));
 
ITPC_habit.child.ASD_st2_bottom = bottom;
ITPC_habit.child.ASD_st2_top = top;
 
clearvars -except ITPC_habit Habituation


%% Step 3: Compute ITPC Adolescents

% TD st1
for i = 1: length(Habituation.adol.TD_st1) 
     ITPC_habit.adol.TD_st1(:,:,i) = ITPC_cohen_RS_core(Habituation.adol.TD_st1{1,i}');
end

clearvars i

ITPC_habit.adol.TD_st1 = ITPC_habit.adol.TD_st1 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adol.TD_st1,3)));
top =    max(max(mean(ITPC_habit.adol.TD_st1,3)));
 
ITPC_habit.adol.TD_st1_bottom = bottom;
ITPC_habit.adol.TD_st1_top = top;
 
clearvars bottom top

% TD st2
for i = 1: length(Habituation.adol.TD_st2) 
     ITPC_habit.adol.TD_st2(:,:,i) = ITPC_cohen_RS_core(Habituation.adol.TD_st2{1,i}');
end

clearvars i

ITPC_habit.adol.TD_st2 = ITPC_habit.adol.TD_st2 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adol.TD_st2,3)));
top =    max(max(mean(ITPC_habit.adol.TD_st2,3)));
 
ITPC_habit.adol.TD_st2_bottom = bottom;
ITPC_habit.adol.TD_st2_top = top;
 
clearvars bottom top

% ASD st1
for i = 1: length(Habituation.adol.ASD_st1) 
     ITPC_habit.adol.ASD_st1(:,:,i) = ITPC_cohen_RS_core(Habituation.adol.ASD_st1{1,i}');
end

clearvars i

ITPC_habit.adol.ASD_st1 = ITPC_habit.adol.ASD_st1 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adol.ASD_st1,3)));
top =    max(max(mean(ITPC_habit.adol.ASD_st1,3)));
 
ITPC_habit.adol.ASD_st1_bottom = bottom;
ITPC_habit.adol.ASD_st1_top = top;
 
clearvars bottom top

% ASD st2
for i = 1: length(Habituation.adol.ASD_st2) 
     ITPC_habit.adol.ASD_st2(:,:,i) = ITPC_cohen_RS_core(Habituation.adol.ASD_st2{1,i}');
end

clearvars i

ITPC_habit.adol.ASD_st2 = ITPC_habit.adol.ASD_st2 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adol.ASD_st2,3)));
top =    max(max(mean(ITPC_habit.adol.ASD_st2,3)));
 
ITPC_habit.adol.ASD_st2_bottom = bottom;
ITPC_habit.adol.ASD_st2_top = top;
 
clearvars -except ITPC_habit Habituation

%% Step 4: Compute ITPC Adults

% TD st1
for i = 1: length(Habituation.adult.TD_st1_exc) 
     ITPC_habit.adult.TD_st1(:,:,i) = ITPC_cohen_RS_core(Habituation.adult.TD_st1_exc{1,i}');
end

clearvars i

ITPC_habit.adult.TD_st1 = ITPC_habit.adult.TD_st1 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adult.TD_st1,3)));
top =    max(max(mean(ITPC_habit.adult.TD_st1,3)));
 
ITPC_habit.adult.TD_st1_bottom = bottom;
ITPC_habit.adult.TD_st1_top = top;
 
clearvars bottom top

% TD st2
for i = 1: length(Habituation.adult.TD_st2_exc) 
     ITPC_habit.adult.TD_st2(:,:,i) = ITPC_cohen_RS_core(Habituation.adult.TD_st2_exc{1,i}');
end

clearvars i

ITPC_habit.adult.TD_st2 = ITPC_habit.adult.TD_st2 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adult.TD_st2,3)));
top =    max(max(mean(ITPC_habit.adult.TD_st2,3)));
 
ITPC_habit.adult.TD_st2_bottom = bottom;
ITPC_habit.adult.TD_st2_top = top;
 
clearvars bottom top

% ASD st1
for i = 1: length(Habituation.adult.ASD_st1) 
     ITPC_habit.adult.ASD_st1(:,:,i) = ITPC_cohen_RS_core(Habituation.adult.ASD_st1{1,i}');
end

clearvars i

ITPC_habit.adult.ASD_st1 = ITPC_habit.adult.ASD_st1 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adult.ASD_st1,3)));
top =    max(max(mean(ITPC_habit.adult.ASD_st1,3)));
 
ITPC_habit.adult.ASD_st1_bottom = bottom;
ITPC_habit.adult.ASD_st1_top = top;
 
clearvars bottom top

% ASD st2
for i = 1: length(Habituation.adult.ASD_st2) 
     ITPC_habit.adult.ASD_st2(:,:,i) = ITPC_cohen_RS_core(Habituation.adult.ASD_st2{1,i}');
end

clearvars i

ITPC_habit.adult.ASD_st2 = ITPC_habit.adult.ASD_st2 (:,801:1500,:);

bottom = min(min(mean(ITPC_habit.adult.ASD_st2,3)));
top =    max(max(mean(ITPC_habit.adult.ASD_st2,3)));
 
ITPC_habit.adult.ASD_st2_bottom = bottom;
ITPC_habit.adult.ASD_st2_top = top;
 
clearvars -except ITPC_habit 


% Save ITPC Habituation Array

save(['C:\Users\cigde\Dropbox\Habituation_paper\October_Emily\input_arrays\', ...
    'ITPC_habituation_all_ages.mat'], 'ITPC_habit')

%% end - go to figure_3_ITPC_plot_all_ages and figure_3_extract_power_phase scripts

