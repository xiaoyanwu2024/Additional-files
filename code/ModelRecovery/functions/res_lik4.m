%--------------------------------------------------------------------------
% Function Name: res_lik4
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 4: inequality
%   aversion no learning model for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------


function res = res_lik4(x,data)

% setup parameter values
envy = x(1); % decision temperature for uc
guilt = x(2);
beta = x(3); % decision temperature

% setup initial values
infp = 0.5;

% likelihood function
for t = 1:length(data.sub_res)
    
    % action utility
    c_self = infp*4;
    d_self = infp*4+2;
    
    c_other = 6-2*infp;
    d_other = 2-2*infp;
    
    % action utility
    uc = c_self - envy*max(c_other - c_self,0) - guilt*max(c_self - c_other,0);
    ud = d_self - envy*max(d_other - d_self,0) - guilt*max(d_self - d_other,0);
    
    p =  1/(1+exp(beta*(ud-uc)));
    res(t,1) = binornd(1,p);
end
