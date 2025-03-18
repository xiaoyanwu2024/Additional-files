%--------------------------------------------------------------------------
% Function Name: ModelRecovery
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: March 18, 2025
% Usage: This script performs model recovery by comparing the true and 
%        recovered parameter values. The script utilizes parallel computing
%        to optimize the parameters and then plots the correlation between 
%        the true and recovered values for each parameter.
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------
clear; clc;

% Load dataset and previous results
load('Data.mat');          % Load the dataset with trial information
load('results.mat');       % Load results from the previous ModelFitting

% Add 'functions' folder to path
addpath(fullfile(pwd, 'functions'));

% Select the best-fitting model (assumed to be model 8)
bestFitModel = results(8); 

% Generate behavioral data based on the best-fitting model
for s = 1:length(Data)
    % Extract the parameters for the subject
    x = bestFitModel.x(s,:);
    
    % Generate the behavioral data using the best-fitting model
    Data(s).sub_res = res_lik8(x, Data(s)); 
end

% Set parameters for optimization
param = bestFitModel.param;
NumMoltiiStart = 1000;  % Number of initial starts for global optimization
NumMaxTry = 500;        % Maximum number of attempts to optimize the starting point

% Set up parallel computing environment
coreCount = 4; 
p = parpool(coreCount);

% Perform the model recovery by optimizing all subjects
recovery = optimizeAllsubs(@lik8, param, Data, NumMoltiiStart, NumMaxTry);

% Close parallel pool
delete(p);

% Save the recovery results
save('recovery.mat', 'recovery');

%% Plot correlation figure for free parameters
paramNames = {'α+', 'α-', 'ω', 'β'};

% Iterate through each free parameter
for p = 1:length(bestFitModel.x(1,:))
    subplot(1, 4, p);  % Create subplot for each parameter
    
    % Extract true and recovered values for the parameter
    trueValues = bestFitModel.x(:, p);  % True values from best-fitting model
    recoveredValues = recovery.x(:, p);  % Recovered values from optimization
    
    % Plot a scatter plot
    scatter(trueValues, recoveredValues, 20, 'MarkerEdgeColor', 'none', ...
        'MarkerFaceColor', [0.5, 0.5, 0.5], 'MarkerFaceAlpha', 0.2);
    
    % Compute Pearson correlation coefficient and p-value
    [r, p_val] = corr(trueValues, recoveredValues, 'Type', 'Pearson');
    
    % Determine significance level
    if p_val < 0.001
        significance_text = 'p < 0.001';
    elseif p_val < 0.01
        significance_text = 'p < 0.01';
    elseif p_val < 0.05
        significance_text = 'p < 0.05';
    else
        significance_text = 'p > 0.05';
    end
    
    % Display correlation and significance text on the plot
    text(0.1, 0.9, ['r = ' num2str(r, '%.2f') ', ' significance_text], ...
        'Units', 'normalized', 'FontSize', 10, 'Color', 'k');
    
    % Label axes with parameter names
    xlabel(['True ' paramNames{p}]);
    ylabel(['Recovered ' paramNames{p}]);
end


