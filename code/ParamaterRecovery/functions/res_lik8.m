function res = res_lik8(x,data)

%setup parameter values
alpha_p = x(1); % positive learning rate
alpha_n = x(2); % positive learning rate
w = x(3); %decision temperature for uc
beta = x(4); % decision temperature

%setup initial values
infp = 0.5;

%likelihood function
for t = 1:length(data.sub_res)
    pc = data.partner_res(t);
    
    %action utility
    uc = infp*(4+w);
    ud = infp*4+2;
    
    %choice probability
    p =  1/(1+exp(beta*(ud-uc)));
    res(t,1) = binornd(1,p);
    action = []; action = res(t,1);
    
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
