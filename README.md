
# LEAP Auditory Habituation

Analysis code for the LEAP auditory habituation EEG study of repetition suppression (Standard 2 − Standard 1) in ASD and TD participants aged 6–30 years (children, adolescents, adults). Analyses cover ERPs, time-frequency power (ERSP) and inter-trial phase coherence (ITPC), PLS regression of EEG features on IQ, and k-means and hierarchical clustering.

Scripts are named by the figure or table they produce. MATLAB (.m) scripts use FieldTrip, Python notebooks (.ipynb) use the plsdo package for PLS, and R scripts (.R) produce the ERP tables and boxplots.

## Pipeline

1. **MATLAB:** compute ERP, ERSP and ITPC measures and extract per-participant features (`figure_4_7_*`).
2. **Notebook:** merge the feature files with demographic and clinical data (`figure_4_5_generate_csv_arrays.ipynb`).
3. **Notebook:** PLS regression (`figure_4_5_pls_analysis_plot.ipynb`).
4. **Notebooks:** clustering (`figure_6_*`, `suppl_fig_3_*`).

## Sample

**`Table_1_demographic.ipynb`**
Summarizes age, sex, IQ and clinical measures by age group and diagnostic group (Table 1). Missing values (999) are excluded.

## Figure 1: ERP topographies

**`figure_1_prepare_selected_neighbours.m`**
Builds the electrode neighborhoods (triangulation of the electrode layout) used for cluster formation, from the channel list and layout file. Saves `neighbours_triangulation.mat` and `.csv`.

**`figure_1_topoplot_plotting.m`**
Runs cluster-based permutation tests (FieldTrip) on Standard 2 − Standard 1 within groups and between groups, and plots difference topographies in 50 ms windows from −50 to 450 ms.

## Figure 2: ERP waveforms and components

**`figure_2_ERP_plot_all_ages.m`**
Plots Fz waveforms for each age group and diagnostic group and tests Standard 1 against Standard 2 and TD against ASD at every time point.

**`figure_2_ERP_amplitude_final.m`**
Extracts P1, N1, P2 and N2 amplitude and latency per participant, taken as the mean voltage within ±5 ms of the peak in a participant-specific search window. Saves `ERP_features_all_ages.mat`.

**`fgure_2_N1_amp_all_age.R`, `fgure_2_N1_amp_all_age_final.R`**
Box plots of N1 amplitude by group and stimulus (earlier and final versions).

## Figure 3: ERSP

**`figure_3_PSD_check_all_ages.m`**
Welch power spectral density check on each participant before the time-frequency analysis. Participants whose mean PSD lies outside 2.5 × IQR in either condition are excluded (3 participants).

**`figure_3_ERSP_compute_all_age.m`**
Complex Morlet wavelet decomposition at 35 linearly spaced frequencies (2–35 Hz, 3–10 cycles), averaged across trials and expressed in dB relative to a −200 to −50 ms baseline.

**`figure_3_ERSP_plot_all_age.m`**
Plots ERSP maps at Fz for each age group and diagnostic group. Standard 1 against Standard 2 within groups and TD against ASD between groups are tested with permutation tests.

## Feature extraction for PLS and clustering

**`figure_4_7_extract_power_phase.m`**
Averages power and ITPC over the post-stimulus window (0–300 ms) in five bands (2–6, 6–9, 9–13, 13–20, 20–30 Hz) and takes Standard 2 − Standard 1. Saves `spectral_RS_all_ages.csv`.

**`figure_4_7_erp_component_organize.m`**
Organizes the P1, N1, P2 and N2 amplitude and latency differences (Standard 2 − Standard 1) per participant into `component_RS_all_ages.csv`.

**`figure_4_7_channel_cluster_prepare.m`**
Computes the mean amplitude of the frontocentral channel cluster in five time windows (50–300 ms) from the difference waves. Saves `cluster_RS_all_ages.csv`.

## Figures 4–5: PLS regression

**`figure_4_5_generate_csv_arrays.ipynb`**
Merges the spectral, component, cluster and demographic files by participant ID into the master file for PLS. Missing codes (999, 777) become NaN.

**`figure_4_5_pls_analysis_plot.ipynb`**
Behavioral PLS (plsdo) of the EEG features on VIQ, PIQ and FSIQ with age regressed out. Includes permutation testing, bootstrap loadings and LV1 score plots, with group comparisons of LV1 scores.

## Figure 6: k-means clustering

**`figure_6_k_means_temporal.ipynb`**
k-means (k = 2) on the 11 temporal (ERP) features after outlier removal, age residualization and standardization. Produces PCA projections and cluster means.

**`figure_6_k_means_spectral_ten.ipynb`**
Same pipeline on the ten combined spectral features (power and ITPC differences in five bands).

**`figure_6_k_means_five_power_feat.ipynb`**
Same pipeline on the five power features only.

**`figure_6_k_means_five_phase_feat.ipynb`**
Same pipeline on the five phase features only.

**`figure_6_k_means_cluster_raw_diff.ipynb`**
Raw Standard 2 − Standard 1 means of each feature by k-means cluster (Supplementary Table 6).

**`figure_6_hierarc_spectral_ten.ipynb`**
Hierarchical (Ward) clustering on the ten combined spectral features, reported in Supplementary Table 5.

## Figure 7: clinical comparison

**`figure_7_piq_violin_plots_090726.ipynb`**
Compares PIQ between the two temporal clusters (k-means and hierarchical) with a permutation test and violin plots.

## Supplementary figures

**`suppl_fig_1_ITPC_compute_all_age.m`**
Computes ITPC with the same wavelet decomposition as the ERSP. ITPC ranges from 0 to 1.

**`suppl_fig_1_ITPC_plot_all_age.m`**
Plots ITPC maps at Fz and runs the group and condition tests.

**`suppl_fig_2_LV1_clinical_corr.ipynb`**
Correlates LV1 EEG scores with clinical measures within the ASD group (SRS T-score, CSS total).

**`suppl_fig_3_hierarc_temporal_feat.ipynb`**
Hierarchical (Ward) clustering on the temporal features.

**`suppl_fig_3_hierarc_five_power_feat.ipynb`**
Hierarchical clustering on the five power features.

**`suppl_fig_3_hierarc_five_phase_feat.ipynb`**
Hierarchical clustering on the five phase features.

**`suppl_fig_3_hierarc_cluster_raw_diff.ipynb`**
Raw Standard 2 − Standard 1 means of each feature by hierarchical cluster (Supplementary Table 6).

## Supplementary tables

**`supplementary_table_1A.R`, `supplementary_table_1B.R`**
Children: amplitude (1A) and latency (1B) of P1, N1, P2 and N2 by group and stimulus. Outliers beyond ±3 SD are removed and the remainder winsorized (1.5 × IQR). Two-way ANOVA (Group × Stimulus).

**`supplementary_table_2A.R`, `supplementary_table_2B.R`**
Same for adolescents.

**`supplementary_table_3A.R`, `supplementary_table_3B.R`**
Same for adults.

**`suppl_table_7_cross_tabulation.ipynb`**
Cross-tabulates the temporal clusters against the power-only and phase-only clusters for k-means and hierarchical clustering, with the adjusted Rand index.
