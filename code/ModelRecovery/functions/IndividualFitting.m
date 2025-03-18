%--------------------------------------------------------------------------
% Function Name: IndividualFitting
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This script is used for ModelRecovery for each participant
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------

function [loglik,logp,p,x,bic,aic,bicc,aicc] = IndividualFitting(likfun,param,subdata,NumMoltiiStart,NumMaxTry,K)

options = optimset('Display','off');
lb = [param.lb];
ub = [param.ub];

f = @(x) -likfun(x,subdata);
gs = GlobalSearch;
numTry = 1;
while numTry < NumMaxTry
    
    for i = 1:length(ub)
        x0(i) = lb(i)+ub(i)*rand();
    end
    
    try
        problem = createOptimProblem('fmincon','objective',...
            f,'x0',x0,'lb',lb,'ub',ub','options',options);
        gs = GlobalSearch(gs,'StartPointsToRun','bounds','Display','off','NumTrialPoints',NumMoltiiStart);
        [x,nlogp] = run(gs,problem);
        break;
    catch
        numTry = numTry+1;
    end
end

n = length(subdata.sub_res);
loglik = likfun(x,subdata);
logp = -nlogp;
p = exp(logp);
bic = -2*logp + K*log(n);
aic = -2*logp+ 2*K;
bicc = (-2*logp + K*log(n))+((log(n)*(K+1)*K)/(n-K-1));
aicc = (-2*logp+ 2*K)+((2*K*(K+1))/(n-K-1));
