%--------------------------------------------------------------------------
% Function Name: res_lik2
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 2: tit for tat
%   model for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik2(x,data)
% setup parameter values
eps = x(1); % learning rate
data.sub_res = data.sub_res + 1; % 1 = defection, 2 = cooperation
data.partner_res = data.partner_res + 1; % 1=defection, 2 = cooperation

% setup initial values
p = [0.5 0.5];

% likelihood function
for t = 1:length(data.sub_res)
    res(t,1) = binornd(1,p(2));
    action = res(t,1);
    pc = data.partner_res(t);
    
    % calculate reward
    if action  == 1 && pc == 1 % 两者都背叛
        r = 2;
    elseif action  == 1 && pc == 2 % 被试背叛 对方合作
        r = 6;
    elseif action  == 2 && pc == 1 % 被试合作 对方背叛
        r = 0;
    elseif action  == 2 && pc == 2 % 两者都合作
        r = 4;
    end
    
    if  r >= 4 % win stay (with probability 1-epsilon)
        p = eps/2*[1 1];
        p(action) = 1-eps/2;
        
    elseif r < 4 % lose shift (with probability 1-epsilon)
        p = (1-eps/2)*[1 1];
        p(action) = eps/2;
        
    end
    
end