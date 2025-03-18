function results = optimizeAllsubs(likfun,param,data,NumMoltiiStart,NumMaxTry)
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
results.subid(:,1) = [data.subid];

parfor s = 1:length(data)
    [loglik(s,1),logp(s,1),p(s,1),x(s,:),bic(s,1),aic(s,1),bicc(s,1),aicc(s,1)] = IndividualFitting(likfun,param,data(s),NumMoltiiStart,NumMaxTry,K);
end

results.loglik = loglik;
results.logp = logp;
results.p = p;
results.x = x;
results.bic = bic;
results.aic = aic;
results.bicc = bicc;
results.aicc = aicc;




    