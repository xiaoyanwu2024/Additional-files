% social reward model with positive and negative alpha
function lik = lik8(x,data)

%setup parameter values
alpha_p = x(1); % positive learning rate
alpha_n = x(2); % positive learning rate
w = x(3); %decision temperature for uc
beta = x(4); % decision temperature

%setup initial values
infp = 0.5;
lik = 0;

%likelihood function
for t = 1:length(data.sub_res)
    action = data.sub_res(t);
    pc = data.partner_res(t);
    
    %action utility
    uc = infp*(4+w);
    ud = infp*4+2;
    
    %choice probability
    if isnan(action)
        lik = lik + 0;
    elseif action == 1
        lik = lik + log(1/(1+exp(beta*(ud-uc))));
    elseif action == 0
        lik = lik + log(1/(1+exp(beta*(uc-ud))));
    end
    
    %update
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
    
    if infp < 0
        infp = 0;
    elseif infp > 1
        infp = 1;
    end
end
