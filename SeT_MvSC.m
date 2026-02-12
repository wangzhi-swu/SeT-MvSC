function [affi] = SeT_MvSC( X,P,nV,lambda,beta)

n = size(X{1},2);  

for v = 1:nV
    Z{v} = zeros(n,n);
    G{v} = zeros(n,n); 
    Q{v} = zeros(n,n); 
    W{v} = zeros(n,n); 
    E{v} = zeros(size(X{v},1),n);
    Y{v} = zeros(size(X{v},1),n); 
    L{v} = zeros(n,n); 
end

isconverg = 0;
epsilon = 1e-7;
iter = 0;
mu = 1e-5;
mu_max = 1e10; 
eta = 2;
dim_Z = [n,n,nV];


while(isconverg == 0)
    iter = iter + 1;
    for v = 1:nV
        d = size(X{v},1);
        tempZ = X{v}'*(Y{v}+mu.*X{v}-mu.*E{v})+mu.*G{v}+mu.*Q{v}-W{v}-L{v};
        Z{v} = (1/(2*mu))*(eye(n,n)-(1/2).*X{v}'*inv(eye(d,d)+(1/2).*X{v}*X{v}')*X{v})*tempZ; 
        tempQ = Z{v}+(1/mu).*L{v};
        Q{v} = L23_norm_matrix(tempQ,((2*beta)/mu).*(P.^(2/3)));
        tempE = X{v}-X{v}*Z{v}+(1/mu).*Y{v};
        E{v} = solve_l1l2(tempE,lambda/mu);
        Y{v} = Y{v}+mu.*(X{v}-X{v}*Z{v}-E{v}); 
        L{v} = L{v}+mu.*(Z{v}-Q{v});
    end
    
    Z_tensor = cat(3, Z{:,:});
    W_tensor = cat(3, W{:,:});
    vec_z = Z_tensor(:);
    vec_w = W_tensor(:);
    
    [vec_g, obj] = solve_l23(vec_z+vec_w./mu,2/mu,dim_Z); 
    G_tensor = reshape(vec_g,dim_Z);
    
    vec_w = vec_w + mu.*(vec_z-vec_g); 
    W_tensor = reshape(vec_w,dim_Z);
    
    
    for v=1:nV 
        G{v} = G_tensor(:,:,v);
        W{v} = W_tensor(:,:,v);
    end

    isconverg = 1;
    for v=1:nV
        if (norm(X{v}-X{v}*Z{v}-E{v},inf)>epsilon) || (norm(Z{v}-G{v},inf)>epsilon) || (norm(Z{v}-Q{v},inf)>epsilon) 
            isconverg = 0;
            break; 
        end
    end

    if (iter>200)
        isconverg = 1;
    end
    
    mu = min(mu*eta, mu_max);
end

affi = 0;
for v = 1:nV
    affi = affi + abs(Z{v})+abs(Z{v}'); 
end
affi = (1/nV).*affi;


end

