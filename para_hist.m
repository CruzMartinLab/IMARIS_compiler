function [histo]=para_hist(parameter,im,histeric,controller)

[m,~]=size(parameter);
parameter=sortrows(parameter,1);

if controller==0
for k=1:m
    histeric(k,im)=(parameter(k,1)*3/(4*3.14))^(1/3);
end
else
   for k=1:m
    histeric(k,im)=parameter(k,1);
end 
end
histo=histeric;    

end