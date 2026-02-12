function [ x,obj ] = solve_l23(y,beta,dim_Z)

Y = reshape(y,dim_Z);

Y = shiftdim(Y,1); 
n3 = dim_Z(1); 

Yhat = fft(Y,[],3); 

obj = 0;
%% t-SVD
% first frontal slice
[U,Sigma,V] = Two_thirds_norm(Yhat(:,:,1),beta);
obj = obj + sum(Sigma);
Xhat(:,:,1) = U*diag(Sigma)*V';

% i =2...halfn3
halfn3 = round(n3/2); 
for i = 2:halfn3
    [U,Sigma,V] = Two_thirds_norm(Yhat(:,:,i),beta);
    obj = obj + sum(Sigma);
    Xhat(:,:,i) = U*diag(Sigma)*V';
    Xhat(:,:,n3+2-i) = conj(Xhat(:,:,i));
end

% if n3 is even
if mod(n3,2) == 0
    i = halfn3+1;
    [U,Sigma,V] = Two_thirds_norm(Yhat(:,:,i),beta);
    obj = obj + sum(Sigma);
    Xhat(:,:,i) = U*diag(Sigma)*V';
end

obj = obj/3;
X = ifft(Xhat,[],3);

X = shiftdim(X,2);
x = X(:);

end

