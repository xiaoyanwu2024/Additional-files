%--------------------------------------------------------------------------
% Function Name: lik1
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This is the script of the loglikelihood function for model 1: Baseline Model
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

function lik = lik1(x,data)

% setup parameter values
b = x(1);

% setup initial values
lik = 0;
% likelihood function
for t = 1:length(data.sub_res)
    action = data.sub_res(t);
    
    % choice probability
    if isnan(action)
        lik = lik + 0;
    elseif action == 0
        lik = lik + log(1-b);
    elseif action == 1
        lik = lik + log(b);
    end
    
end