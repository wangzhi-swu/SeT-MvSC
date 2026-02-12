
function result = sendPos(data,time,kn)
[m,~] = size(data);
if nargin<3
    kn = 1;
end
if nargin<2   
    time = 1; 
end
datanew = data;
dataold = data;
for j = 1:m
    data(data == 1) = kn; 
end

for i = 1:time 
    for j = 1:m
        listn = find(datanew(j,:)>0);
        newsum = sum(data(listn,:)); 
        listsum = find(newsum>0); 
        listk = setdiff(listsum,listn);
        if(isempty(listk))
            continue;
        end
        datanew(j,listk) = (1/kn)^(i+1); 
    end
    if dataold == datanew 
        break;
    end
    dataold = datanew;
end
for i = 1:m
    dataold(i,i) = 1;  
end
result = dataold;