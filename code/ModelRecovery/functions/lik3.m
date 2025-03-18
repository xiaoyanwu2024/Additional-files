%--------------------------------------------------------------------------
% Function Name: lik3
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This is the script of the loglikelihood function for Model 3:
% reward learning model
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

function lik = lik3(x,data)

% setup parameter values
alpha = x(1); %learning rate
beta = x(2);
% setup initial values
lik = 0;
Vc = 0;
Vd = 0;

% likelihood function
for t = 1:length(data.sub_res)
    action = data.sub_res(t);
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
    
    if isnan(action)
        lik = lik + 0;
    elseif action == 1
        lik = lik + log(1/(1+exp(beta*(Vd-Vc))));
    elseif action == 0
        lik = lik + log(1/(1+exp(beta*(Vc-Vd))));
    end
    
    % update
    if isnan(action)
        Vc = Vc;
        Vd = Vd;
    elseif action == 1
        Vc = Vc + alpha*(r-Vc);
        Vd = Vd;
    elseif action == 0
        Vc = Vc;
        Vd = Vd + alpha*(r-Vd);
    end
    
end
