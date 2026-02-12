function [Knn_mat] = Con_knn(S,k) 

if nargin < 2
    k = 5;  
end

[n,~] = size(S);
Knn_mat = zeros(n,n);
for i = 1:n
    [sim,labels] = sort(S(i,:),'descend'); 
    Knn_mat(i,labels(2:k+1)) = 1; 
end
Knn_mat = max(Knn_mat,Knn_mat');


