%--------------------------------------------------------------------------
% Function Name: res_lik1
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 1: Baseline Model
%   for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik1(x,data)

% Setup parameter values
b = x(1);

% Likelihood function
for t = 1:length(data.sub_res)
    % choice probability
    res(t,1) = binornd(1,b);
end