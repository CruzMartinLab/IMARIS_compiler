function [dendritic_puncta_syn,dendritic_puncta_com]=isolate_dendritic(index, image_name, synaptic_log, compartment_log, dendritic_synaptic_log, dendritic_compartment_log)

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
       if contains(temp_str,'_Position.csv')
          [num_den_syn,~,~]=xlsread(fullfile(dendritic_synaptic_log(i).folder,dendritic_synaptic_log(i).name));
          [size_den_syn,tot_col_den_syn]=size(num_den_syn); 
       end
    end
waitbar(i/max_total, f, sprintf('Isolating dendrites due to COVID: %d %%', floor(100*i/max_total)));  

end
den_syn(:,1:3)=num_den_syn(:,1:3);
den_syn(:,4)=num_den_syn(:,tot_col_den_syn);

for i=1:n_compartment_den
    file_delim=strsplit(dendritic_compartment_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_compartment_log(i).name);
       if contains(temp_str,'_Position.csv')
          [num_den_com,~,~]=xlsread(fullfile(dendritic_compartment_log(i).folder,dendritic_compartment_log(i).name));
          [size_den_com,tot_col_den_com]=size(num_den_com);
          
       end
    end
waitbar((i+n_synaptic_den)/max_total, f, sprintf('Isolating dendrites due to COVID: %d %%', floor(100*(i+n_synaptic_den)/max_total)));  
end
den_com(:,1:3)=num_den_com(:,1:3);
den_com(:,4)=num_den_com(:,tot_col_den_com);

puncta_count=1;
for i=1:n_synaptic
    file_delim=strsplit(synaptic_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
     if file_delim(n-2)==image_name(1,index)
        temp_str=string(synaptic_log(i).name);
       if contains(temp_str,'_Position.csv')
          [num_syn,~,~]=xlsread(fullfile(synaptic_log(i).folder,synaptic_log(i).name));
          [size_syn,tot_col_syn]=size(num_syn);
           
          syn(puncta_count:puncta_count+size_syn-1,1)=num_syn(:,1);
           syn(puncta_count:puncta_count+size_syn-1,2)=num_syn(:,2);
           syn(puncta_count:puncta_count+size_syn-1,3)=num_syn(:,3);
          syn(puncta_count:puncta_count+size_syn-1,4)=num_syn(:,tot_col_syn);
          puncta_count=puncta_count+size_syn;
       end  
     end
 waitbar((i+n_synaptic_den+n_compartment_den)/max_total, f, sprintf('Isolating dendrites due to COVID: %d %%', floor(100*(i+n_synaptic_den+n_compartment_den)/max_total))); 
end




puncta_count=1;
for i=1:n_compartment
    file_delim=strsplit(compartment_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
    
     if file_delim(n-2)==image_name(1,index)
        temp_str=string(compartment_log(i).name);
       if contains(temp_str,'_Position.csv')
           
          [num_com,~,~]=xlsread(fullfile(compartment_log(i).folder,compartment_log(i).name));
          [size_com,tot_col_com]=size(num_com);
          
          com(puncta_count:puncta_count+size_com-1,1)=num_com(:,1);
          com(puncta_count:puncta_count+size_com-1,2)=num_com(:,2);
          com(puncta_count:puncta_count+size_com-1,3)=num_com(:,3);
          com(puncta_count:puncta_count+size_com-1,4)=num_com(:,tot_col_com);
          puncta_count=puncta_count+size_com;
       end  
     end
waitbar((i+n_synaptic_den+n_compartment_den+n_synaptic)/max_total, f, sprintf('Isolating dendrites due to COVID: %d %%', floor(100*(i+n_synaptic_den+n_compartment_den+n_synaptic)/max_total)));
end

syn_counter=1;
for i=1:size_den_syn
    x1=den_syn(i,1:3);
    x2=syn(:,1:3);
    d=pdist2(x1,x2);
    if ~ismember(0,d)
       dendritic_puncta_syn(syn_counter,1)=den_syn(i,4);
       syn_counter=syn_counter+1;
    end
waitbar(i/(size_den_syn+size_den_com), f, sprintf('Isolating dendrites due to COVID: %d %%', floor(100*(i/(size_den_syn+size_den_com)))));
end

if syn_counter==1
    dendritic_puncta_syn(syn_counter,1)=999;
end

com_counter=1;
for i=1:size_den_com
    x1=den_com(i,1:3);
    x2=com(:,1:3);
    d=pdist2(x1,x2);
    if ~ismember(0,d)
       dendritic_puncta_com(com_counter,1)=den_com(i,4);
       com_counter=com_counter+1;
    end
    waitbar((i+size_den_syn)/(size_den_syn+size_den_com), f, sprintf('Isolating dendrites due to COVID: %d %%', floor(100*((i+size_den_syn)/(size_den_syn+size_den_com)))));
end
close(f);

if com_counter==1
    dendritic_puncta_com(com_counter,1)=999;
end
end
