function results = optimizeAllsubs(likfun,param,data, NumMaxTry, NumMoltiiStart)

%--------------------------------------------------------------------------
% Function Name: optimizeAllsubs
% Author: Xiaoyan Wu
% Date: February 12, 2024
% Usage: This function performs model fitting
%
% Input:
%   likfun - the loglikelihood function
%   param - the free parameter structure
%   data - the dataset of all subjects, with 300 trials for each subject
%   NumMoltiiStart - the number of multiple start for global searching
%   NumMaxTry - the number of attempts for the starting point of x0.

% Output:
% results - A structure containing fitting results for all models, which includes:
%       .K - Number of free parameters in the model.
%       .param - Parameter structure of the model.
%       .subid - Subject IDs of all subjects
%       .loglik - Log likelihood of all subjects,double check of the log likelihood calculated by a different method
%       .logp - Log likelihood of all subjects
%       .p - Exponential of the log likelihood (exp(loglik)).
%       .x - Values of the free parameters of all subjects.
%       .aic - Akaike Information Criterion (AIC) values of all subjects.
%       .aicc - Corrected AIC for sample size of all subjects.
%--------------------------------------------------------------------------

K = length(param);
results.K = K;
results.param = param;
results.likfun = likfun;
options = optimset('Display','off');

lb = [param.lb];
ub = [param.ub];

parfor s = 1:length(data)
    disp(['Subject ',num2str(s)]);
    [loglik(s,1),logp(s,1),p(s,1),x(s,:),bic(s,1),aic(s,1),bicc(s,1),aicc(s,1)] = IndividualFitting(likfun,param,data(s),NumMoltiiStart,NumMaxTry,K);
end

results.subid(:,1) = [data.subid];
results.loglik(:,1) = loglik;
results.logp(:,1) = logp;
results.p(:,1) = p;
results.x = x;
results.bic(:,1) = bic;
results.aic(:,1) = aic;
results.bicc(:,1) = bicc;
results.aicc(:,1) = aicc;
