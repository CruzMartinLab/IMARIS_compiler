function [overlap_volume_spines,overlap_volume_dendrites]=overlap_volume(index, image_name, synaptic_log, compartment_log, dendritic_synaptic_log, dendritic_compartment_log, dendritic_puncta_syn,dendritic_puncta_com)

comlist=["Volume_to_Surfaces_Surfaces=Dendritic_LAMP1_surfaces.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1.csv","Volume_to_Surfaces_Surfaces=Total_Denritic_LAMP1.csv","Volume_to_Surfaces_Surfaces=Total_Denritic_LAMP1_.csv","Volume_to_Surfaces_Surfaces=Total_Denritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_dendritic_Rab11a.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a.csv","Volume_to_Surfaces_Surfaces=Total_dendritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a__.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_Rab11a_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1_.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP1.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_LAMP!.csv"];


synlist=["Volume_Ratio_to_Surfaces_Surfaces=Dendritic_GluR1_surfaces.csv","Volume_to_Surfaces_Surfaces=Total_dendritic_GluR1.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_GluR1.csv", "Volume_to_Surfaces_Surfaces=Total_dendritic_GluR1__.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_GluR1__.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_PSD95_.csv", "Volume_to_Surfaces_Surfaces=Total_Dendritic_PSD95.csv","Volume_to_Surfaces_Surfaces=Total_Dendritic_GluR1_.csv"];



[~,n_synaptic_den]=size(dendritic_synaptic_log);
[~,n_compartment_den]=size(dendritic_compartment_log);
[~,n_synaptic]=size(synaptic_log);
[~,n_compartment]=size(compartment_log);

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
    end

waitbar(i/max_total, f, sprintf('Do you even overlap: %d %%', floor(100*i/max_total))); 
end
den_syn(:,1)=num_den_syn(:,1);
den_syn(:,2)=num_den_syn(:,tot_col_den_syn);

counter=1;
for j=1:size_den_syn
    if ismember(den_syn(j,2),dendritic_puncta_syn(:,1))
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
    end
    
    waitbar((i+n_synaptic_den)/max_total, f, sprintf('Do you even overlap: %d %%', floor(100*(i+n_synaptic_den)/max_total)));  

end
den_com(:,1)=num_den_com(:,1);
den_com(:,2)=num_den_com(:,tot_col_den_com);

counter=1;
for j=1:size_den_com
    if ismember(den_com(j,2),dendritic_puncta_com(:,1))
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
           syn(puncta_count:puncta_count+size_syn-1,2)=num_syn(:,tot_col_syn);
          puncta_count=puncta_count+size_syn;
       end  
     end
 waitbar((i+n_synaptic_den+n_compartment_den)/max_total, f, sprintf('Do you even overlap: %d %%', floor(100*(i+n_synaptic_den+n_compartment_den)/max_total))); 
     
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
          com(puncta_count:puncta_count+size_com-1,2)=num_com(:,tot_col_com);
          puncta_count=puncta_count+size_com;
       end  
     end
waitbar((i+n_synaptic_den+n_compartment_den+n_synaptic)/max_total, f, sprintf('Do you even overlap: %d %%', floor(100*(i+n_synaptic_den+n_compartment_den+n_synaptic)/max_total)));
     
end


counter=1;
for i=1:size_den_syn
    d=den_syn(i,1);
    if d~=0
    overlap_volume_dendrites(counter,1)=d;
    counter=counter+1;
    end
waitbar((i)/(size_den_syn+size_syn), f, sprintf('Do you even overlap: %d %%', floor(100*(i)/(size_den_syn+size_syn))));
end
if counter==1
   overlap_volume_dendrites(counter,1)=0; 
end
counter=1;
for i=1:size_syn
     d=syn(i,1);
    if d~=0
    overlap_volume_spines(counter,1)=d;
    counter=counter+1;
    end
    
waitbar((i+size_den_syn)/(size_den_syn+size_syn), f, sprintf('Do you even overlap: %d %%', floor(100*(i+size_den_syn)/(size_den_syn+size_syn))));
end
if counter==1
   overlap_volume_spines(counter,1)=0; 
end
close(f);
end