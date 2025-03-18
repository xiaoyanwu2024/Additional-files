%--------------------------------------------------------------------------
% Function Name: LMM_BehavioralAnalysis
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: March 18, 2025
% Usage: This script fits GLMM1, LMM1, and LMM3 models.
% 
% Notes:
% - Path separators differ across operating systems:
%     * Windows uses a backslash (\) as the path separator.
%     * macOS/Linux use a forward slash (/) as the path separator.
% - Ensure you use the correct path separator for your operating system.
% 
% Dataset:
% - 'dataset.mat' contains data from all participants, with each row 
%   representing one trial.
% - Trials with participants' inaction have been excluded.
%--------------------------------------------------------------------------

%% Load dataset for model fitting
clear; clc;
load('dataset.mat');

%% Generalized Linear Mixed Model (GLMM1)
% GLMM1: Participants' decision is the dependent variable.
GLMM1 = fitglme(dataset, ...
    'Choice ~ Gender + trialNumber + Group * PartnerChoice * Timing + (1 + Gender + trialNumber + Group + PartnerChoice + Timing | subid)', ...
    'Distribution', 'Binomial');

%% Linear Mixed Model (LMM1)
% LMM1: Participants' expectation (estimated from the best-fitting model) is the dependent variable.
LMM1 = fitglme(dataset, ...
    'PartnerExpectation ~ Gender + trialNumber + Group * PartnerChoice * Timing + (1 + Gender + trialNumber + Group + PartnerChoice + Timing | subid)', ...
    'Distribution', 'Normal');

%% Linear Mixed Model (LMM3)
% LMM3: The intrinsic reward of reciprocity (estimated from the best-fitting model) is the dependent variable.
LMM3 = fitglme(dataset, ...
    'IntrinsicReward ~ Gender + trialNumber + Group * PartnerChoice * Timing + (1 + Gender + trialNumber + Group + PartnerChoice + Timing | subid)', ...
    'Distribution', 'Normal');
