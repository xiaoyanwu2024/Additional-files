%--------------------------------------------------------------------------
% Function Name: ModelFitting
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: March 18, 2025
% Purpose: This script performs model fitting using various models.
%
% Notes:
% - Path separators differ across operating systems:
%   * Windows uses a backslash (\).
%   * macOS/Linux use a forward slash (/).
%   Ensure the correct path separator is used for your operating system.
%
% Dataset Information:
% - Each row represents one trial:
%   * group           : 'adult' or 'adolescent'
%   * subid           : Participant's ID
%   * gender          : 2 = female, 1 = male
%   * age             : Participant's age (in years)
%   * order           : Order of two sessions regarding the simulated partner's decisions
%                       (counterbalanced between participants)
%   * partner_res     : Simulated partner's decision (1 = cooperation, 0 = defection)
%   * sub_res         : Participant's decision (1 = cooperation, 0 = defection)
%   * RT              : Reaction time of the participant
%   * cooperativeness : Subjective cooperativeness score regarding partner's cooperativeness
%--------------------------------------------------------------------------

%% Initialize workspace
clear; clc;

%% Load data
load('Data.mat');

%% Add 'functions' folder to path
addpath(fullfile(pwd, 'functions'));

%% Generate parameter structure for all models
param = GetParame();

%% Load information for all log-likelihood functions
modelList = dir(fullfile(pwd, 'functions', 'lik*.m'));
for m = 1:length(modelList)
    modelList(m).model = eval(strcat('@', modelList(m).name(1:end-2)));
    modelList(m).param = param(m).param;
end

%% Set up parallel computation
numCores = 24; % Number of cores for parallel computation
pool = parpool(numCores);

%% Model fitting
numMultiStart = 1000;
numMaxTry = 500;

for m = 1:length(modelList)
    model = modelList(m).model;
    params = modelList(m).param;
    results(m) = optimizeAllsubs(model, params, Data, numMultiStart, numMaxTry);
    fprintf('Model %d fitting complete.\n', m);
end

% Close parallel pool
delete(pool);

%% Assign model names
modelNames = {
    'M1: Baseline';
    'M2: Win stay & lose switch';
    'M3: Reward Learning';
    'M4: Inequality Aversion';
    'M5: Social Reward';
    'M6: Social Reward & RL';
    'M7: Social Reward & Influence';
    'M8: Social Reward & Asym. RL'
};

for m = 1:length(results)
    results(m).name = modelNames{m};
end

%% Save fitting results for adults and adolescents
% Indices for adolescents and adults
idxAdolescent = strcmp({Data.group}, 'adolescent');
idxAdult = strcmp({Data.group}, 'adult');

% Save results for adults
for m = 1:length(results)
    adult(m) = struct(...
        'K', results(m).K, ...
        'param', results(m).param, ...
        'likfun', results(m).likfun, ...
        'subid', results(m).subid(idxAdult), ...
        'logp', results(m).logp(idxAdult), ...
        'loglik', results(m).loglik(idxAdult), ...
        'p', results(m).p(idxAdult), ...
        'x', results(m).x(idxAdult, :), ...
        'aic', results(m).aic(idxAdult), ...
        'aicc', results(m).aicc(idxAdult), ...
        'name', results(m).name ...
    );
end

% Save results for adolescents
for m = 1:length(results)
    adolescent(m) = struct(...
        'K', results(m).K, ...
        'param', results(m).param, ...
        'likfun', results(m).likfun, ...
        'subid', results(m).subid(idxAdolescent), ...
        'logp', results(m).logp(idxAdolescent), ...
        'loglik', results(m).loglik(idxAdolescent), ...
        'p', results(m).p(idxAdolescent), ...
        'x', results(m).x(idxAdolescent, :), ...
        'aic', results(m).aic(idxAdolescent), ...
        'aicc', results(m).aicc(idxAdolescent), ...
        'name', results(m).name ...
    );
end

%% Model comparison and saving
adult = ForModelComparison(adult);
adolescent = ForModelComparison(adolescent);

save('adult.mat', 'adult');
save('adolescent.mat', 'adolescent');