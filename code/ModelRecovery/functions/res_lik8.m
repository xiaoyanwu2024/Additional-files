%--------------------------------------------------------------------------
% Function Name: res_lik8
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 8:
%   social reward model with positive and negative learning rule for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik8(x,data)
% setup parameter values
alpha_p = x(1); % positive learning rate
alpha_n = x(2); % positive learning rate
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
    
    % update
    if isnan(action)
        infp = infp + 0;
    else
        pe = pc - infp;
        
        if pe > 0
            infp = infp + alpha_p * pe;
        elseif pe < 0
            infp = infp + alpha_n * pe;
        end
        
    end
    
    infp = min(max(infp, 0), 1);
end
