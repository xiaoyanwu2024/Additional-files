function fitmodel = recovery(data, results, num_model, generated_model, NumMoltiiStart, NumMaxTry)

%--------------------------------------------------------------------------
% Function Name: recovery
% Author: Xiaoyan Wu
% Date: February 12, 2024
% Usage: This function performs model recovery analysis.
%
% Input:
%   data - All subjects’data.
%   results - A structure containing the fitting results of all models.
%   resmodellist - A list containing the prediction functions for all models.
%   m - The current testing model (the generated model).
%   t - The number of repetitions for model recovery.
% NumMoltiiStart - Number of multiple iStart for global searching.
% NumMaxTry - Number of attempts for the starting point of x0.
%
% Output:
%   fitmodel - results of all fitting models
%
% Note: Model recovery analysis assesses the ability of a fitting procedure
%       to recover the generating model based on simulated data. This function
%       compares the performance of the generated model against competitive
%       models using AICc as metrics.
%------------------------------------------------------------------------

% Due to experiment 2's extensive data involving 1258 participants, we enhanced 
% efficiency by randomly selecting one participant's data each time for model recovery
num = randi([1, length(data)]);
subdata = data(num);
% x = results(num_model).x(num,:);

% generate one simulated subject based on the upper and lower of the range of the free parameters
for pp = 1:length(results(num_model).param)
    x(pp) = results(num_model).param(pp).lb + rand()*results(num_model).param(pp).ub;
end

% Generate synthetic data
subdata.sub_res = [];
subdata.sub_res = eval([generated_model,'(x,subdata)']);

% estimate&fit
for k = 1:length(results)
    param = results(k).param;
    model = results(k).likfun;
    fitmodel(k) = optimize(model, param, subdata, NumMoltiiStart, NumMaxTry);
end

fitmodel = ForModelComparison(fitmodel);

