%--------------------------------------------------------------------------
% Function Name: LMM2_SubjectiveRatingAnalysis
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: March 18, 2025
% Usage: This script fits a Linear Mixed Model (LMM2) to subjective rating scores.
% 
% Notes: 
% - Path separators differ across operating systems:
%     - Windows uses a backslash (\)
%     - macOS/Linux use a forward slash (/)
%   Ensure you use the correct path separator for your operating system.
%
% Data: 
% - dataset.mat contains data from all participants, with each row 
%   representing one trial. Trials with participant inaction have been excluded.
%--------------------------------------------------------------------------

%% Load data
clear; clc;
load('Data.mat');

%% Generate data for LMM2
nTrials = 8; % Number of rating trials per participant

% Extract key variables
cooperativeness = vertcat(Data.cooperativeness); 
order = [Data.order]';
subid = [Data.subid]';
group = string({Data.group})';
gender = string([Data.gender])';

% Create table for LMM analysis
SubjectiveRatingScore = table(...
    repelem(subid, nTrials), ...                  % Unique participant ID
    repelem(group, nTrials), ...                  % Participant age group (adult/adolescent)
    repelem(gender, nTrials), ...                 % Participant gender (1 = male, 2 = female)
    repelem(order, nTrials), ...                  % Order of partner’s cooperation probability change
    reshape(cooperativeness', [], 1), ...         % Partner cooperativeness score
    repmat((1:nTrials)', length(Data), 1) ...     % Time point of the rating (every 15 trials)
);

% Rename table columns for clarity
SubjectiveRatingScore.Properties.VariableNames = ...
    {'SubID', 'Group', 'Gender', 'Order', 'Cooperativeness', 'Time'};

% % Save SubjectiveRatingScore
% save('SubjectiveRatingScore.mat','SubjectiveRatingScore');

%% Fit Linear Mixed Model (LMM2)
md = fitglme(SubjectiveRatingScore, ...
    'Cooperativeness ~ Group * Order + Time + Gender + (1 + Group + Gender + Order | SubID)', ...
    'Distribution', 'Normal');

%% Plot subjective rating scores
% Normalize cooperativeness scores to [0, 1]
cooperativeness = cooperativeness / 9;

% Group indices based on age and order
idx_adult_sv = find(group == 'adult' & order == 1);
idx_adult_vs = find(group == 'adult' & order == 2);
idx_adole_sv = find(group == 'adolescent' & order == 1);
idx_adole_vs = find(group == 'adolescent' & order == 2);

% Calculate mean and standard error
coop.mean.adult_sv = nanmean(cooperativeness(idx_adult_sv, :));
coop.mean.adult_vs = nanmean(cooperativeness(idx_adult_vs, :));
coop.mean.adole_sv = nanmean(cooperativeness(idx_adole_sv, :));
coop.mean.adole_vs = nanmean(cooperativeness(idx_adole_vs, :));

coop.se.adult_sv = nanstd(cooperativeness(idx_adult_sv, :)) / sqrt(length(idx_adult_sv));
coop.se.adult_vs = nanstd(cooperativeness(idx_adult_vs, :)) / sqrt(length(idx_adult_vs));
coop.se.adole_sv = nanstd(cooperativeness(idx_adole_sv, :)) / sqrt(length(idx_adole_sv));
coop.se.adole_vs = nanstd(cooperativeness(idx_adole_vs, :)) / sqrt(length(idx_adole_vs));

% Plot for Order = 1
figure;
x = 1:120;
x2 = [16, 31, 46, 61, 76, 91, 106, 120];
design = [ones(60,1)*0.78; ones(20,1)*0.2; ones(20,1)*0.8; ones(20,1)*0.2];

plot(x, design, '--k', 'LineWidth', 1);
hold on;
errorbar(x2 + 2, coop.mean.adole_sv, coop.se.adole_sv, 'Color', '#fb8072', 'LineWidth', 2);
hold on;
errorbar(x2, coop.mean.adult_sv, coop.se.adult_sv, 'Color', '#80b1d3', 'LineWidth', 2);
box off;
xlim([1, 120]);
xlabel('Trials');
ylabel({'Subjective Rating', 'Cooperativeness of the Partner'});
ylim([0, 1]);

% Plot for Order = 2
figure;
design = [ones(20,1)*0.2; ones(20,1)*0.8; ones(20,1)*0.2; ones(60,1)*0.78];

plot(x, design, '--k', 'LineWidth', 1);
hold on;
errorbar(x2 + 2, coop.mean.adole_vs, coop.se.adole_vs, 'Color', '#fb8072', 'LineWidth', 2);
hold on;
errorbar(x2, coop.mean.adult_vs, coop.se.adult_vs, 'Color', '#80b1d3', 'LineWidth', 2);
box off;
xlabel('Trials');
ylabel({'Subjective Rating', 'Cooperativeness of the Partner'});
ylim([0, 1]);
xlim([1, 120]);
