function [volume_spine_ratio,volume_den_ratio]=Colocalized_volume_ratio(index, image_name, synaptic_log, compartment_log, dendritic_synaptic_log, dendritic_compartment_log, dendritic_puncta_syn,dendritic_puncta_com)

[~,n_synaptic_den]=size(dendritic_synaptic_log);
[~,n_compartment_den]=size(dendritic_compartment_log);
[~,n_synaptic]=size(synaptic_log);
[~,n_compartment]=size(compartment_log);




comlist=["Volume_to_Surfaces_Surfaces=Dendritic_LAMP1_surfaces.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1.csv","Volume_to_Surfaces_Surfaces=Total_Denritic_LAMP1.csv","Volume_to_Surfaces_Surfaces=Total_Denritic_LAMP1_.csv","Volume_to_Surfaces_Surfaces=Total_Denritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_dendritic_Rab11a.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a.csv","Volume_to_Surfaces_Surfaces=Total_dendritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a__.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP!.csv"];


synlist=["Volume_Ratio_to_Surfaces_Surfaces=Dendritic_GluR1_surfaces.csv","Volume_to_Surfaces_Surfaces=Total_dendritic_GluR1.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_GluR1.csv", "Volume_to_Surfaces_Surfaces=Total_dendritic_GluR1__.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_GluR1__.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_PSD95_.csv", "Volume_to_Surfaces_Surfaces=Total_Dendritic_PSD95.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_GluR1_.csv"];


f = waitbar(0, 'Starting');
max_total=n_synaptic_den+n_compartment_den+n_synaptic+n_compartment;


for i=1:n_synaptic_den
    file_delim=strsplit(dendritic_synaptic_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_synaptic_log(i).name);
       if contains(temp_str,comlist)
           
          [num_den_syn,~,~]=xlsread(fullfile(dendritic_synaptic_log(i).folder,dendritic_synaptic_log(i).name));
          [size_den_syn,tot_col_den_syn]=size(num_den_syn); 
       end
       
       if contains(temp_str,'_Position.csv')
          [temp,~,~]=xlsread(fullfile(dendritic_synaptic_log(i).folder,dendritic_synaptic_log(i).name));
          
       end
       
       if contains(temp_str,'_Volume.csv')
          [temp1,~,~]=xlsread(fullfile(dendritic_synaptic_log(i).folder,dendritic_synaptic_log(i).name));
          
       end
       
    end

waitbar(i/max_total, f, sprintf('Calculating volume ratios: %d %%', floor(100*i/max_total))); 
end
den_syn(:,1)=num_den_syn(:,1);
den_syn(:,6)=num_den_syn(:,tot_col_den_syn);
den_syn(:,2)=temp1(:,1);
den_syn(:,3)=temp(:,1);
den_syn(:,4)=temp(:,2);
den_syn(:,5)=temp(:,3);

counter=1;
for j=1:size_den_syn
    if ismember(den_syn(j,6),dendritic_puncta_syn(:,1))
       ds(counter,:)=den_syn(j,:); 
       counter=counter+1;
    end
end
den_syn=ds;
[size_den_syn,~]=size(den_syn);



for i=1:n_compartment_den
    file_delim=strsplit(dendritic_compartment_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_compartment_log(i).name);
       if contains(temp_str,synlist,'IgnoreCase',true)
          [num_den_com,~,~]=xlsread(fullfile(dendritic_compartment_log(i).folder,dendritic_compartment_log(i).name));
          [size_den_com,tot_col_den_com]=size(num_den_com); 
       end
       
       if contains(temp_str,'_Position.csv')
          [temp,~,~]=xlsread(fullfile(dendritic_compartment_log(i).folder,dendritic_compartment_log(i).name));
          
       end
       
       if contains(temp_str,'_Volume.csv')
          [temp1,~,~]=xlsread(fullfile(dendritic_compartment_log(i).folder,dendritic_compartment_log(i).name));
          
       end
       
    end
    
    waitbar((i+n_synaptic_den)/max_total, f, sprintf('Calculating volume ratios: %d %%', floor(100*(i+n_synaptic_den)/max_total)));  

end
den_com(:,1)=num_den_com(:,1);
den_com(:,6)=num_den_com(:,tot_col_den_com);
den_com(:,2)=temp1(:,1);
den_com(:,3)=temp(:,1);
den_com(:,4)=temp(:,2);
den_com(:,5)=temp(:,3);


counter=1;
for j=1:size_den_com
    if ismember(den_com(j,6),dendritic_puncta_com(:,1))
       ds(counter,:)=den_com(j,:); 
       counter=counter+1;
    end
end
den_com=ds;
[size_den_com,~]=size(den_com);



puncta_count=1;
for i=1:n_synaptic
    file_delim=strsplit(synaptic_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
     if file_delim(n-2)==image_name(1,index)
        temp_str=string(synaptic_log(i).name);
       if contains(temp_str,comlist,'IgnoreCase',true)
          [num_syn,~,~]=xlsread(fullfile(synaptic_log(i).folder,synaptic_log(i).name));
          
          [size_syn,tot_col_syn]=size(num_syn);
           syn(puncta_count:puncta_count+size_syn-1,1)=num_syn(:,1);
           syn(puncta_count:puncta_count+size_syn-1,6)=num_syn(:,tot_col_syn);
        
       end  
       
        if contains(temp_str,'_Position.csv')
          [temp,~,~]=xlsread(fullfile(synaptic_log(i).folder,synaptic_log(i).name));
          
          syn(puncta_count:puncta_count+size_syn-1,3)=temp(:,1);
          syn(puncta_count:puncta_count+size_syn-1,4)=temp(:,2);
          syn(puncta_count:puncta_count+size_syn-1,5)=temp(:,3);
          
       end
       
       if contains(temp_str,'_Volume.csv')
          [temp1,~,~]=xlsread(fullfile(synaptic_log(i).folder,synaptic_log(i).name));
          syn(puncta_count:puncta_count+size_syn-1,2)=temp1(:,1);
          puncta_count=puncta_count+size_syn;
       end
       
       
       
     end
 waitbar((i+n_synaptic_den+n_compartment_den)/max_total, f, sprintf('Calculating volume ratios: %d %%', floor(100*(i+n_synaptic_den+n_compartment_den)/max_total))); 
     
end
[size_syn,~]=size(syn);



puncta_count=1;
for i=1:n_compartment
    file_delim=strsplit(compartment_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
     if file_delim(n-2)==image_name(1,index)
        temp_str=string(compartment_log(i).name);
       if contains(temp_str,synlist,'IgnoreCase',true)
          [num_com,~,~]=xlsread(fullfile(compartment_log(i).folder,compartment_log(i).name));
          [size_com,tot_col_com]=size(num_com);
          com(puncta_count:puncta_count+size_com-1,1)=num_com(:,1);
          com(puncta_count:puncta_count+size_com-1,6)=num_com(:,tot_col_com);
          
       end  
       
       
        if contains(temp_str,'_Position.csv')
          [temp,~,~]=xlsread(fullfile(compartment_log(i).folder,compartment_log(i).name));
         com(puncta_count:puncta_count+size_com-1,3)=temp(:,1);
          com(puncta_count:puncta_count+size_com-1,4)=temp(:,2);
          com(puncta_count:puncta_count+size_com-1,5)=temp(:,3);
          
       end
       
       if contains(temp_str,'_Volume.csv')
          [temp1,~,~]=xlsread(fullfile(compartment_log(i).folder,compartment_log(i).name));
          com(puncta_count:puncta_count+size_com-1,2)=temp1(:,1);
          puncta_count=puncta_count+size_com;
       end
       
       
       
     end
waitbar((i+n_synaptic_den+n_compartment_den+n_synaptic)/max_total, f, sprintf('Calculating volume ratios: %d %%', floor(100*(i+n_synaptic_den+n_compartment_den+n_synaptic)/max_total)));
     
end
[size_com,~]=size(com);

count=1;
for ii=1:size_syn
   if syn(ii,1)>0
       t_syn(count,:)=syn(ii,:);
       count=count+1;
   end
end
if count==1
   [~,size_assign]=size(syn);
   array_assign=zeros(1,size_assign);
   t_syn(count,:)=array_assign; 
end
syn=t_syn;
[size_syn,~]=size(syn);
count=1;
for ii=1:size_com
   if com(ii,1)>0
       t_com(count,:)=com(ii,:);
       count=count+1;
   end
end
if count==1
   [~,size_assign]=size(com);
   array_assign=zeros(1,size_assign);
   t_com(count,:)=array_assign; 
end
com=t_com;
[size_com,~]=size(com);


count=1;
for ii=1:size_den_syn
   if den_syn(ii,1)>0
       t_den_syn(count,:)=den_syn(ii,:);
       count=count+1;
   end
end
if count==1
   [~,size_assign]=size(den_syn);
   array_assign=zeros(1,size_assign);
   t_den_syn(count,:)=array_assign; 
end
den_syn=t_den_syn;
[size_den_syn,~]=size(den_syn);
count=1;
for ii=1:size_den_com
   if den_com(ii,1)>0
       t_den_com(count,:)=den_com(ii,:);
       count=count+1;
   end
end
if count==1
   [~,size_assign]=size(den_com);
   array_assign=zeros(1,size_assign);
   t_den_com(count,:)=array_assign; 
end
den_com=t_den_com;
[size_den_com,~]=size(den_com);


for ii=1:size_syn
    spine_dist(ii,:)=pdist2(syn(ii,3:5),com(:,3:5));
   
end

idx_spine=zeros(size_syn,size_com);
for ii=1:size_syn
    for iii=1:size_com
       if spine_dist(ii,iii)<0.35
           idx_spine(ii,iii)=1;
       end
    end
end


for ii=1:size_den_syn
    den_dist(ii,:)=pdist2(den_syn(ii,3:5),den_com(:,3:5));
   
end

idx_den=zeros(size_den_syn,size_den_com);
for ii=1:size_den_syn
    for iii=1:size_den_com
       if den_dist(ii,iii)<0.35
           idx_den(ii,iii)=1;
       end
    end
end

spine_vol_count=nnz(idx_spine);
den_vol_count=nnz(idx_den);



volume_spine_ratio=zeros(spine_vol_count,1);
volume_den_ratio=zeros(den_vol_count,1);

count=1;
for ii=1:size_syn
    for iii=1:size_com   
       if idx_spine(ii,iii)==1
           volume_spine_ratio(count,1)=syn(ii,2)/com(iii,2);
           count=count+1;
       end
    end
end
if count==1
   volume_spine_ratio(count,1)=0; 
end
count=1;
for ii=1:size_den_syn
    for iii=1:size_den_com   
       if idx_den(ii,iii)==1
           volume_den_ratio(count,1)=den_syn(ii,2)/den_com(iii,2);
           count=count+1;
       end
    end
end
if count==1
   volume_den_ratio(count,1)=0; 
end
    
close(f);
end