%--------------------------------------------------------------------------
% Function Name: lik6
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This is the script of the loglikelihood function for Model 6:
% Social Value Model with RW learning rule
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

function lik = lik6(x,data)

% setup parameter values
alpha = x(1); % learning rate
w = x(2); % decision temperature for uc
beta = x(3); % decision temperature

% setup initial values
infp = 0.5;
lik = 0;

% likelihood function
for t = 1:length(data.sub_res)
    action = data.sub_res(t);
    pc = data.partner_res(t);
    
    % action utility
    uc = infp*(4+w);
    ud = infp*4+2;
    
    % choice probability
    if isnan(action)
        lik = lik + 0;
    elseif action == 1
        lik = lik + log(1/(1+exp(beta*(ud-uc))));
    elseif action == 0
        lik = lik + log(1/(1+exp(beta*(uc-ud))));
    end
    
    % update
    if isnan(action)
        infp = infp + 0;
    else
        pe = pc - infp;
        infp = infp + alpha * pe;
    end
    
    infp = min(max(infp, 0), 1);
end
