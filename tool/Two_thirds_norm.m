function [U,new_sigma,V] = Two_thirds_norm(W,lambda)
[U,S,V] = svd(W,'econ');
sigma = diag(S);
len = length(sigma);
new_sigma = [];
for i = 1:len
    if abs(sigma(i)) - 48^(1/4)/3*lambda^(3/4)>0
       new_sigma(i) = func(sigma(i),lambda);
        
    else 
        new_sigma(i) = 0;   
    end
end

function [R] = func(sigma, lambda)   
    if lambda == 0
        lambda = lambda + 1e-16;
    end
x = 27*sigma*sigma/(16*lambda^(3/2));
fai = acosh(x);
Fai=(2/3^(1/2))*lambda^(1/4)*(cosh(fai/3))^(1/2);
h = abs(Fai)+(2*abs(sigma)/abs(Fai)-abs(Fai)*abs(Fai))^(1/2);
ht = h^3/8;
R=sign(sigma)*ht;
end

end
