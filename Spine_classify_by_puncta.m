
function [classification]=Spine_classify_by_puncta(spine_length_num,puncta_array)


[~,n]=size(spine_length_num);
spine_length_num=sortrows(spine_length_num,n);

[m,~]=size(spine_length_num);
X=zeros(m,2);

[n_syn,~]=size(puncta_array);


S=unique(puncta_array(:,1));
[syn_count,~]=size(S);
S(1:syn_count,2)=0;
for counter=1:n_syn
   for counter2=1:syn_count
      if puncta_array(counter,1)==S(counter2,1) 
         S(counter2,2)=  S(counter2,2)+1; 
      end
   end
end
[syn_count,~]=size(S);
for counter=1:m
   x=spine_length_num(counter,n);
   s=num2str(x);
   y=sscanf(s(end-4:end), '%d');
   X(counter,1)=y;
end

for counter=1:m
   classification(counter,1)=X(counter,1);
   classification(counter,2)=0;  
end


for counter=1:m
    for counter2=1:syn_count
      if classification(counter,1)==S(counter2,1) 
         classification(counter,2)= S(counter2,2);
         if classification(counter,2)>3
            classification(counter,2)=3; 
         end
      end
   end
end

end