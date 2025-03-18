%--------------------------------------------------------------------------
% Function Name: lik2
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This is the script of the loglikelihood function for Model 2: tit for tat
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

function lik = lik2(x,data)

% setup parameter values
eps = x(1); %learning rate
data.sub_res = data.sub_res + 1; % 1 = defection, 2 = cooperation
data.partner_res = data.partner_res + 1; % 1 = defection, 2 = cooperation

% setup initial values
p = [0.5 0.5];
lik = 0;

% likelihood function
for t = 1:length(data.sub_res)
    action = data.sub_res(t);
    pc = data.partner_res(t);
    
    % choice probability
    if isnan(action)
        lik = lik + 0;
    elseif action == 2
        lik = lik + log(p(2));
    elseif action == 1
        lik = lik + log(p(1));
    end
    
    % calculate reward
    if action  == 1 && pc == 1 % both players defecte
        r = 2;
    elseif action  == 1 && pc == 2 % participants defects, partner cooperates
        r = 6;
    elseif action  == 2 && pc == 1 % partner cooperates, participants defects
        r = 0;
    elseif action  == 2 && pc == 2 % both players cooperate
        r = 4;
    end
    
    if  isnan(action)
        p = p;
    else
        if  r >= 4 % win stay (with probability 1-epsilon)
            p = eps/2*[1 1];
            p(action) = 1-eps/2;
            
        elseif r < 4 % lose shift (with probability 1-epsilon)
            p = (1-eps/2)*[1 1];
            p(action) = eps/2;
            
        end
    end
end