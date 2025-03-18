%--------------------------------------------------------------------------
% Function Name: ModelRecovery
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: March 18, 2025
% Usage: This script is used for Model Recovery by generating synthetic datasets, 
%        fitting models, and comparing their performance.
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

% Clear workspace and command window
clear; clc;

% Load required data
load('Data.mat');
load('results.mat');

%% Add 'functions' folder to path for accessing model functions
addpath(fullfile(pwd, 'functions'));

% Retrieve all model recovery related functions from the 'functions' folder
resmodellist = dir(fullfile(pwd, 'functions', 'res_*'));

% Define parameters for model recovery process
time = 100;  % Number of model recovery iterations
NumMoltiiStart = 500;  % Number of multiple initializations for global search
NumMaxTry = 1000;  % Maximum number of attempts for finding optimal starting points

% Set up parallel computing
core = 24;  % Number of cores for parallel processing
p = parpool(core);  % Start parallel pool

% Loop through each model in the results
for num_model = 1:length(results)
    
    % Get the current generated model name
    generated_model = resmodellist(num_model).name(1:end-2);  % Remove '.m' from model name
    
    % Perform model recovery multiple times
    for num_time = 1:time
        
        % Generate synthetic datasets based on the current model
        for s = 1:length(Data)
            x = results(num_model).x(s,:);  % Extract parameters for the subject
            Data(s).sub_res = eval([generated_model, '(x, Data(s))']);  % Generate synthetic responses
        end
        
        % Fit all models to the generated data
        for k = 1:length(results)
            param = results(k).param;
            model = results(k).likfun;
            fitmodel(k) = optimizeAllsubs(model, param, Data, NumMaxTry, NumMoltiiStart);  % Optimize model
        end
        
        % Perform model comparison
        fitmodel = ForModelComparison(fitmodel);
        modelFitResults(num_time).fitmodel = fitmodel;  % Store model comparison results
    end
    
    % Calculate the relative model performance (based on AICc)
    detaAICc = zeros(1, length(results));  % Initialize difference in AICc
    
    for num_time = 1:time
        detaAICc = detaAICc + double([modelFitResults(num_time).fitmodel.mean_detaAICc] == min([modelFitResults(num_time).fitmodel.mean_detaAICc]));
    end
    
    % Calculate percentage of times each model was the best
    detaAICc = detaAICc / time;
    
    % Store model recovery results for the current model
    ModelRecoveryResult(:, num_model) = detaAICc;
    
    clear modelFitResults;  % Clear modelFitResults variable for next iteration
end

% Close parallel pool after completing computations
delete(p);

% Save model recovery results to file
save('ModelRecoveryResult.mat', 'ModelRecoveryResult');

%% Plot Model Recovery Results
% Define model names for display
names = {'M1: Baseline', 'M2: Win Stay & Lose Switch', 'M3: Reward Learning', 'M4: Inequality Aversion', ...
    'M5: Social Reward', 'M6: Social Reward & RL', 'M7: Social Reward & Influence', 'M8: Social Reward & Asym. RL'};

% Create a heatmap to visualize model recovery results
figure;
imagesc(ModelRecoveryResult);  % Display model recovery matrix
colormap('summer');  % Set color map for better visualization
colorbar;  % Add color bar for reference

% Customize the x-axis and y-axis labels
xticks(1:8);  % Set x-axis ticks to match model names
xticklabels(names);  % Set x-axis labels as model names
xlabel('Generative model');  % Label for x-axis
xtickangle(45);  % Rotate x-axis labels for better readability

yticklabels(names);  % Set y-axis labels as model names
ylabel('Fitting model');  % Label for y-axis
