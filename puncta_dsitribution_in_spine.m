function [synaptic_puncta_head,synaptic_puncta_neck, compartment_puncta_head,compartment_puncta_neck] = puncta_dsitribution_in_spine(synaptic,compartment)

[n_syn,~]=size(synaptic);
[n_compart,~]=size(compartment);

puncta_head=0;
puncta_neck=0;


for i=1:n_syn
    
    if synaptic(i,4)==0
        puncta_neck=puncta_neck+1;
        for j=1:4
        synaptic_neck(puncta_neck,j)=synaptic(i,j);
        end
    else 
        puncta_head=puncta_head+1;
        for j=1:4
        synaptic_head(puncta_head,j)=synaptic(i,j);
        end
    end
    
end

puncta_head=0;
puncta_neck=0;

for i=1:n_compart
    if compartment(i,4)==0
        puncta_neck=puncta_neck+1;
        for j=1:4
        compartment_neck(puncta_neck,j)=compartment(i,j);
        end
    else 
        puncta_head=puncta_head+1;
        for j=1:4
        compartment_head(puncta_head,j)=compartment(i,j);
        end
    end
    
end


 [n,~]=size(synaptic_neck);
 i=1;
 count=1;
while (i<n)
    
    
    if synaptic_neck(i,1)==synaptic_neck(i+1,1)
      synaptic_neck(i,2)=synaptic_neck(i,2)+synaptic_neck(i+1,2);
      synaptic_neck(i,3)=synaptic_neck(i,3)+synaptic_neck(i+1,3);
      synaptic_neck(i+1,:)=[];
      i=i-1;
      count=count+1;
      
    else
        
        synaptic_neck(i,4)=count;
        count=1;
    end
    
    [n,~]=size(synaptic_neck);
    i=i+1;
    
end

synaptic_neck(n,4)=count;



[n,~]=size(synaptic_head);
 i=1;
  count=1;
while (i<n)
    
    if synaptic_head(i,1)==synaptic_head(i+1,1)
      synaptic_head(i,2)=synaptic_head(i,2)+synaptic_head(i+1,2);
      synaptic_head(i,3)=synaptic_head(i,3)+synaptic_head(i+1,3);
      synaptic_head(i+1,:)=[];
      i=i-1;
      count=count+1;
    else
        synaptic_head(i,4)=count;
        count=1;
        
    end
    
    [n,~]=size(synaptic_head);
    i=i+1;
    
end

synaptic_head(n,4)=count;





[n,~]=size(compartment_neck);
 i=1;
 count=1;
while (i<n)
    
    
    
    if compartment_neck(i,1)==compartment_neck(i+1,1)
     compartment_neck(i,2)=compartment_neck(i,2)+compartment_neck(i+1,2);
      compartment_neck(i,3)=compartment_neck(i,3)+compartment_neck(i+1,3);
      compartment_neck(i+1,:)=[];
      i=i-1; 
      count=count+1;
    else
        
        compartment_neck(i,4)=count;
        count=1;
    end
    
    [n,~]=size(compartment_neck);
    i=i+1;
    
end

compartment_neck(n,4)=count;



[n,~]=size(compartment_head);
 i=1;
 count=count+1;
while (i<n)
    
    
    if compartment_head(i,1)==compartment_head(i+1,1)
     compartment_head(i,2)=compartment_head(i,2)+compartment_head(i+1,2);
      compartment_head(i,3)=compartment_head(i,3)+compartment_head(i+1,3);
      compartment_head(i+1,:)=[];
      i=i-1;
      count=count+1;
    else
         compartment_head(i,4)=count;
        count=1;
    end
    
    [n,~]=size(compartment_head);
    i=i+1;
    
end


compartment_head(n,4)=count;


synaptic_puncta_head=synaptic_head;
synaptic_puncta_neck=synaptic_neck;
compartment_puncta_head=compartment_head;
compartment_puncta_neck=compartment_neck;

end