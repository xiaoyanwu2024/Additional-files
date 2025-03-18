%--------------------------------------------------------------------------
% Function Name: res_lik3
% Author: Xiaoyan Wu
% Date: May 20, 2024
%
% Usage:
%   This function performs model prediction of the model 3: reward learning
%   model
%   model for one subject.
%
% Inputs:
%   - x: The value of the free parameter of the subject.
%   - data: The dataset of one subject, containing 120 trials in total.
%
% Output:
%   - The predicted decision by the model, 1 = cooperate and 0 = defect.
%--------------------------------------------------------------------------

function res = res_lik3(x,data)

% setup parameter values
alpha = x(1); % learning rate
beta = x(2);
% setup initial values
Vc = 0;
Vd = 0;

% likelihood function
for t = 1:length(data.sub_res)
    
    % choice probability
    p =  1/(1+exp(beta*(Vd-Vc)));
    res(t,1) = binornd(1,p);
    
    action = []; action = res(t,1);
    pc = data.partner_res(t);
    
    if action == 1 && pc == 1
        r = 4;
    elseif action  == 1 && pc == 0
        r = 0;
    elseif action == 0 && pc == 1
        r = 6;
    elseif action == 0 && pc == 0
        r = 2;
    else
        r = 0;
    end
    
    % update
    if action == 1
        Vc = Vc + alpha*(r-Vc);
        Vd = Vd;
    elseif action == 0
        Vc = Vc;
        Vd = Vd + alpha*(r-Vd);
    end
    
end
