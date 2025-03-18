%--------------------------------------------------------------------------
% Function Name: res_lik5
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 5: Social Value Model
%   with No Learning for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik5(x,data)

% setup parameter values
w = x(1);
beta = x(2);

% setup initial values
infp = 0.5;

% likelihood function
for t = 1:length(data.sub_res)
    
    % action utility
    uc = infp*(4+w);
    ud = infp*4+2;
    
    p =  1/(1+exp(beta*(ud-uc)));
    res(t,1) = binornd(1,p);
end
