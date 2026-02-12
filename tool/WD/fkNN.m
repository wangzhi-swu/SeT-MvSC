function [R,D,distanceX] = fkNN(X,k,distanc,target)
if nargin < 4
    target = 0;
end
if nargin < 3
    distanc = 0;
end
if nargin < 2
    k = 3;
end
saveX = X;
[m,n] = size(saveX);
distanceX = zeros(n,n);
result = zeros(n,k);
dis = zeros(n,k);
if distanc == 0
    for i = 1:n
        for j = 1:n
			distanceX(i,j) = norm(saveX(:,i)-saveX(:,j));
        end
    end
    if target == 0
        for i = 1:n
            [a,b] = sort(distanceX(i,:));
            result(i,:) = b(2:k+1);
            dis(i,:) = a(2:k+1);
        end 
    else
        result = zeros(n,k);
        for i = 1:n
            [a,b] = sort(distanceX(i,:),'descend');
            result(i,:)=b(1:k);
            dis(i,:) = a(1:k);
        end
    end
else
    for i = 1:n
		for j = 1:n
          distanceX(i,j) = dot(X(:,i),X(:,j));
		end
    end
    if target == 0
        for i = 1:n
            [a,b] = sort(distanceX(i,:));
            result(i,:) = b(1:k);
            dis(i,:) = a(1:k);
        end 
    else
        result = zeros(n,k);
        for i = 1:n
            [a,b] = sort(distanceX(i,:),'descend');
            result(i,:)=b(2:k+1);
            dis(i,:) = a(2:k+1);
        end
    end
end
R = result;
D = dis;