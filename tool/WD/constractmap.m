
function [result] = constractmap(data)
	[m,n] = size(data);
	savedata = zeros(m,m);
	for i = 1:m
        savedata(i,data(i,:)) = 1;
	end
	result = savedata;