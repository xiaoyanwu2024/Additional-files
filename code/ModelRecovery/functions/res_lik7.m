%--------------------------------------------------------------------------
% Function Name: res_lik7
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 7:
%   social reward miodel with influence model for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik7(x,data)

% setup parameter values
alpha = x(1); % learning rate
kapa = x(2);
w = x(3); % decision temperature for uc
beta = x(4); % decision temperature

% setup initial values
infp = 0.5;

% likelihood function
for t = 1:length(data.sub_res)
    pc = data.partner_res(t);
    
    % action utility
    uc = infp*(4+w);
    ud = infp*4+2;
    
    % choice probability
    p =  1/(1+exp(beta*(ud-uc)));
    res(t,1) = binornd(1,p);
    action = res(t,1);
    
    %update
    pe1 = pc - infp;
    pe2 = action - ((1/(2*(w-1)))-(1/(4*beta*(w-1)))*log((1-infp)/infp));
    infp = infp + alpha * pe1 + kapa*pe2;
    
    infp = min(max(infp, 0), 1);
end
