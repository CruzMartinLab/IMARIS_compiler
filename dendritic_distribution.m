function [den_synaptic,den_compartment]=dendritic_distribution(image_name,index,only_dendritic_syn,only_dendritic_com,dendritic_synaptic_log, dendritic_compartment_log)

[~,n_synaptic_den]=size(dendritic_synaptic_log);
[~,n_compartment_den]=size(dendritic_compartment_log);

puncta_counter=1;
for i=1:n_synaptic_den
    file_delim=strsplit(dendritic_synaptic_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
   
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_synaptic_log(i).name);
       if contains(temp_str,'_Area.csv')
          [num_den_syn,~,~]=xlsread(fullfile(dendritic_synaptic_log(i).folder,dendritic_synaptic_log(i).name));
          [temp_size,sort_col]=size(num_den_syn);
          
          for j=1:temp_size
             if ismember(num_den_syn(j,sort_col),only_dendritic_syn(:,1))
                den_synaptic(puncta_counter,1)= num_den_syn(j,sort_col);
                den_synaptic(puncta_counter,2)= num_den_syn(j,1);
                puncta_counter=puncta_counter+1;
             end
          end
       end
       
    end
    
end


puncta_counter=1;
for i=1:n_synaptic_den
    file_delim=strsplit(dendritic_synaptic_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
   
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_synaptic_log(i).name);
       if contains(temp_str,'_Volume.csv')
          [num_den_syn,~,~]=xlsread(fullfile(dendritic_synaptic_log(i).folder,dendritic_synaptic_log(i).name));
          [temp_size,sort_col]=size(num_den_syn);
          
          for j=1:temp_size
             if ismember(num_den_syn(j,sort_col),only_dendritic_syn(:,1))
                den_synaptic(puncta_counter,3)= num_den_syn(j,1);
                puncta_counter=puncta_counter+1;
             end
          end
       end
       
    end
    
end

puncta_counter=1;
for i=1:n_compartment_den
    file_delim=strsplit(dendritic_compartment_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
   
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_compartment_log(i).name);
       if contains(temp_str,'_Area.csv')
          [num_den_com,~,~]=xlsread(fullfile(dendritic_compartment_log(i).folder,dendritic_compartment_log(i).name));
          [temp_size,sort_col]=size(num_den_com);
          
          for j=1:temp_size
             if ismember(num_den_com(j,sort_col),only_dendritic_com(:,1))
                den_compartment(puncta_counter,1)= num_den_com(j,sort_col);
                den_compartment(puncta_counter,2)= num_den_com(j,1);
                puncta_counter=puncta_counter+1;
             end
          end
       end
       
    end
    
end

puncta_counter=1;
for i=1:n_compartment_den
    file_delim=strsplit(dendritic_compartment_log(i).folder,'\');
    file_delim=string(file_delim);
    [~,n]=size(file_delim); 
   
    if file_delim(n-3)==image_name(1,index)
       temp_str=string(dendritic_compartment_log(i).name);
       if contains(temp_str,'_Volume.csv')
          [num_den_com,~,~]=xlsread(fullfile(dendritic_compartment_log(i).folder,dendritic_compartment_log(i).name));
          [temp_size,sort_col]=size(num_den_com);
          
          for j=1:temp_size
             if ismember(num_den_com(j,sort_col),only_dendritic_com(:,1))
                den_compartment(puncta_counter,3)= num_den_com(j,1);
                puncta_counter=puncta_counter+1;
             end
          end
       end
       
    end
    
end

end