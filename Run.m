clc;
close all;
clear;

addpath('tool');
addpath('tool/WD');

load('MSRC-v1-6v.mat');

if exist('Y','var')
    gt = Y;  
end
if exist('y','var')
    gt = y;  
end
if exist('truelabel','var')
    gt = truelabel{1};
end
if exist('data','var')
    X = data;  
end
class_num = length(unique(gt)); 

nV = length(X); 

nS = size(X{1},2);

[data,vecX] = Con_Diagdata(X,nV);
vecX = NormalizeData(vecX);
Cos_sim= abs(vecX'*vecX);
Cos_dis = 1-Cos_sim;
sigma = mean(mean(Cos_dis));
Umat = ones(size(Cos_dis));
CauS = Umat./((Cos_dis./(sigma^2))+Umat);
CauP = Umat - CauS; 

for v=1:nV
    X{v} = NormalizeData(X{v});
end


for k = 3 
for inter_p = 1.1 
for intra_p = 0.0 
for hry = [8] 
h = hry; 
knn_mat = Con_knn(CauS,k);
knn_mat = sendknn(knn_mat,h); 
k_num = length(find(knn_mat==1));
theta1 = intra_p;
theta2 = inter_p;  
knn_mat(knn_mat == 0)=theta2; 
knn_mat(knn_mat == 1)=theta1; 
knn_mat = knn_mat - diag(diag(knn_mat)); 
WCauP = CauP.*knn_mat;


lambda = 1e-2;
beta = 1e-5;
rng(5,'twister');
tic;
affi = SeT_MvSC(X,WCauP,nV,lambda,beta);
time = toc;

Predicted = SpectralClustering(affi, class_num);
result =  ClusteringMeasure(gt, Predicted);


fid=fopen('log_MSRC-v1.txt','a');

fprintf(fid,'lambda: %.1e\n', lambda);
fprintf(fid,'beta: %.1e\n', beta);
fprintf(fid,'k: %d\n', k);
fprintf(fid,'theta1: %.1f\n', theta1);
fprintf(fid,'theta2: %.1f\n', theta2);
fprintf(fid,'h: %d\n', h);
fprintf(fid,'result: %.4g %.4g %.4g %.4g %.4g %.4g %.4g \n', result);
fprintf(fid,'time: %.2f\n', time);
fprintf(fid,'\n');
end
end
end
end
fid=fclose('all');



