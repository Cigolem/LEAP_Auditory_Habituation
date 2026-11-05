
%% TD Children
% P1 - 50-100msec after stimulus onset (approx. 90 msec)
% N1 - around 100 msec (approx 120msec) after stimulus onset (approx. 120 msec)
% P2 - 100-150 msec after stimulus onset (approx 135 msec)
% N2 - 200-300 msec after stimulus onset (approx 270 msec)


%% latency the time that spans from the minERP to maxERP or from MaxERP to minERP
%% Load the data 

% eeg = MADE.channel_data_st1{1,40};
% erp_eeg = mean(eeg(:,901:1600),1,'omitnan');
% time = linspace(-100,600,700); % from 100 msec before the stimulus to 600 ms
% figure (1)
% plot(time, erp_eeg,'k','linew',1)
% set(gca,'xlim',[-100 600])

BOND_report = table2struct(BOND_report_table_all);

%% latency the time that spans from the minERP to maxERP or from MaxERP to minERP
%% Load the data

clearvars -except MADE ERP_features BOND_report 
eeg = MADE.channel_data_st1{1,15};
erp_eeg = mean(eeg(:,901:1400),1,'omitnan');
% Plot 
time = linspace(-100,400,500); % from 100 msec before the stimulus to 600 ms
figure (2)
plot(time, erp_eeg,'k','linew',1)
set(gca,'xlim',[-100 400])

P1_patch = ERP_features.Adolescent.TD_Std1(15).P1_patch;
N1_patch = ERP_features.Adolescent.TD_Std1(15).N1_patch;
P2_patch = ERP_features.Adolescent.TD_Std1(15).P2_patch;
N2_patch = ERP_features.Adolescent.TD_Std1(15).N2_patch;

ylim = get(gca,'ylim');
ph = patch(P1_patch([1 1 2 2]),ylim([1 2 2 1]),'y');
set(ph,'facealpha',.8,'edgecolor','none')
ph = patch(N1_patch([1 1 2 2]),ylim([1 2 2 1]),'g');
set(ph,'facealpha',.8,'edgecolor','none')
ph = patch(P2_patch([1 1 2 2]),ylim([1 2 2 1]),'r');
set(ph,'facealpha',.8,'edgecolor','none')
ph = patch(N2_patch([1 1 2 2]),ylim([1 2 2 1]),'b');
set(ph,'facealpha',.8,'edgecolor','none')
set(gca,'Children',flipud( get(gca,'Children') )) % move the patches to the 
%%


eeg = MADE.channel_data_st2{1,29};
erp_eeg = mean(eeg(:,901:1400),1,'omitnan');

% Plot 
time = linspace(-100,400,500); % from 100 msec before the stimulus to 600 ms
figure (2)
plot(time, erp_eeg,'k','linew',1)
set(gca,'xlim',[-100 400])


P1_patch = [ 76 89];
N1_patch = [ 104 114];
P2_patch = [ 117 127];
N2_patch = [ 246 261];

P1_time = dsearchn(time',P1_patch')';
N1_time = dsearchn(time',N1_patch')';
P2_time = dsearchn(time',P2_patch')';
N2_time = dsearchn(time',N2_patch')';


ylim = get(gca,'ylim');
ph = patch(P1_patch([1 1 2 2]),ylim([1 2 2 1]),'y');
set(ph,'facealpha',.8,'edgecolor','none')
ph = patch(N1_patch([1 1 2 2]),ylim([1 2 2 1]),'g');
set(ph,'facealpha',.8,'edgecolor','none')
ph = patch(P2_patch([1 1 2 2]),ylim([1 2 2 1]),'r');
set(ph,'facealpha',.8,'edgecolor','none')
ph = patch(N2_patch([1 1 2 2]),ylim([1 2 2 1]),'b');
set(ph,'facealpha',.8,'edgecolor','none')
set(gca,'Children',flipud( get(gca,'Children') )) % move the patches to the background

%% Calculate peak-to-peak voltages and timings (take mean around the peak instead of picking one absolute peak

% win = 10; % in ms - this means that from the peak we are going to average the data -10 msec + 10 msec.
 win = 5;

% find minimum/maximum peak times
[~,P1MaxTime] = max(erp_eeg(P1_time(1):P1_time(2))); % this is just one peak not the mean in the window
[~,N1MinTime] = min(erp_eeg(N1_time(1):N1_time(2)));
[~,P2MaxTime] = max(erp_eeg(P2_time(1):P2_time(2))); % this is just one peak not the mean in the window
[~,N2MinTime] = min(erp_eeg(N2_time(1):N2_time(2)));

% adjust ERP timings
P1MaxTime = P1MaxTime + P1_patch(1)-1;
N1MinTime = N1MinTime + N1_patch(1)-1;
P2MaxTime = P2MaxTime + P2_patch(1)-1;
N2MinTime = N2MinTime + N2_patch(1)-1;

P1MaxTime_org = dsearchn(time', P1MaxTime')';
N1MinTime_org = dsearchn(time', N1MinTime')';
P2MaxTime_org = dsearchn(time', P2MaxTime')';
N2MinTime_org = dsearchn(time', N2MinTime')';

% now find average values around the peak time
P1MaxAmp = mean( erp_eeg(P1MaxTime_org-win:P1MaxTime_org+win) );
N1MinAmp = mean( erp_eeg(N1MinTime_org-win:N1MinTime_org+win) );
P2MaxAmp = mean( erp_eeg(P2MaxTime_org-win:P2MaxTime_org+win) );
N2MinAmp = mean( erp_eeg(N2MinTime_org-win:N2MinTime_org+win) );


%% Output

output.P1_Amp = P1MaxAmp;
output.N1_Amp = N1MinAmp;
output.P2_Amp = P2MaxAmp;
output.N2_Amp = N2MinAmp;
output.P1_Time = P1MaxTime;
output.N1_Time = N1MinTime;
output.P2_Time = P2MaxTime;
output.N2_Time = N2MinTime;
output.P1_patch = P1_patch;
output.N1_patch = N1_patch;
output.P2_patch = P2_patch;
output.N2_patch = N2_patch;
output.name = BOND_report(15).ID;


ERP_features.Adolescent.TD_Std2(15)=output;
cd('D:\')
save ERP_features_all_ages  ERP_features
clearvars -except MADE ERP_features BOND_report BOND_report_table_all


ERP_features.Adolescent.TD_Std2(6).P1_Amp=P1MaxAmp;
ERP_features.Adolescent.TD_Std2(6).P1_Time=P1MaxTime;

ERP_features.Adolescent.TD_Std2(3).N2_Amp=N2MinAmp;
ERP_features.Adolescent.TD_Std2(3).N2_Time=N2MinTime;

%% end