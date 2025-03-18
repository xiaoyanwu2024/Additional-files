%--------------------------------------------------------------------------
% Function Name: lik4
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This is the script of the loglikelihood function for Model 4:
% inequality aversion no learning
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

function lik = lik4(x,data)
% setup parameter values
envy = x(1); %decision temperature for uc
guilt = x(2);
beta = x(3); % decision temperature

% setup initial values
lik = 0;
infp = 0.5;

% likelihood function
for t = 1:length(data.sub_res)
    action = data.sub_res(t);
    
    % action utility
    c_self = infp*4;
    d_self = infp*4+2;
    
    c_other = 6-2*infp;
    d_other = 2-2*infp;
    
    uc = c_self - envy*max(c_other - c_self,0) - guilt*max(c_self - c_other,0);
    ud = d_self - envy*max(d_other - d_self,0) - guilt*max(d_self - d_other,0);
    
    % choice probability
    if isnan(action)
        lik = lik + 0;
    elseif action == 1
        lik = lik + log(1/(1+exp(beta*(ud-uc))));
    elseif action == 0
        lik = lik + log(1/(1+exp(beta*(uc-ud))));
    end
    
end
