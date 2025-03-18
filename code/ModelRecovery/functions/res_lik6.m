%--------------------------------------------------------------------------
% Function Name: res_lik6
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 6: Social Value Model
%   with learning rule for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik6(x,data)

% setup parameter values
alpha = x(1); % learning rate
w = x(2); % decision temperature for uc
beta = x(3); % decision temperature

% setup initial values
infp = 0.5;

% likelihood function
for t = 1:length(data.sub_res)
    pc = data.partner_res(t);
    
    % action utility
    uc = infp*(4+w);
    ud = infp*4+2;
    
    p =  1/(1+exp(beta*(ud-uc)));
    res(t,1) = binornd(1,p);
    
    %update
    pe = pc - infp;
    infp = infp + alpha * pe;
    
    infp = min(max(infp, 0), 1);
end
