    
clc
clear all
addpath(genpath('Z:\Lab Software and Code\Rhush Stuff'));
addpath(genpath('Z:\Lab Software and Code\Rhush Stuff\Imaris functions'));

%choose folder for analysis
p_folder=uigetdir('Y:\Data 2020-2021\Complement 4-SNX Project\Imaging\STED Real\');

%import all csvs
logs = dir(fullfile(p_folder,'**','*.csv'));

%sort all the csvs into either filament, compartment or synaptic associated
%files
[numFiles,~]=size(logs);

count=1;
f=waitbar(0, 'Starting');
for i=1:numFiles
if contains(logs(i).folder,'All IMARIS Stats') && ~contains(logs(i).folder,'Stats old') && ~contains(logs(i).folder,'GFP + C4') && ~contains(logs(i).folder,'Colocalized')  && ~contains(logs(i).folder,'Colocalization')  
logs1(count,:)=logs(i,:);
count=count+1;
end
waitbar(i/numFiles,f,sprintf('Progress Logs Sorting: %d %%', floor(100*i/numFiles)));
end
close(f);
logs=logs1;
[numFiles,~]=size(logs);
clearvars logs1;
%CloseFigure()
%next this portion is needed to find out then number of images we have, as
%well as their names
images=0;
prev_str='check_name';
f = waitbar(0, 'Starting');
for i=1:numFiles
    file_delim=strsplit(logs(i).folder,'\');
    [~,n]=size(file_delim);
    temp_str=string(file_delim(9));
    if temp_str~=prev_str
        images=images+1;
        image_name(1,images)=temp_str;
        prev_str=temp_str;
    end
  waitbar(i/numFiles, f, sprintf('Identifying dendrite names: %d %%', floor(100*i/numFiles)));  
end

close(f)
% images=8;
% image_name(:,3)=[];
% image_name(:,1)=[];

%now we look through all files, and only keep those in filament_log that
%are associated with total filament datasets
filament_count=0;
f = waitbar(0, 'Starting');
 for i=1:numFiles
    file_delim=strsplit(logs(i).folder,'\');
    [~,n]=size(file_delim);
    if string(file_delim(n-1))=='Filament'
        filament_log(filament_count+1)=logs(i);
        filament_count=filament_count+1;
    end
 waitbar(i/numFiles, f, sprintf('Progress Logs Filament: %d %%', floor(100*i/numFiles)));   
 end

 %this portion looks at file paths, and determines what imaging antibodies
 %were used for synaptic and compartmental data
  file_delim=strsplit(logs(1).folder,'\'); 
  [~,n]=size(file_delim);
  regexp=strsplit(string(file_delim(6)),' ');
  syn_string=regexp(1,1);
  compart_string=regexp(1,3);
  
  
 %now we look through all files, and only keep those in synaptic_log that
%are associated with synaptic parameters. Note that synaptic refers to
%either PSD95 or GluR1
 synaptic_count=0;
 for i=1:numFiles
    file_delim=strsplit(logs(i).folder,'\');
    [~,n]=size(file_delim);
    if string(file_delim(n-1))==syn_string  &&   ~contains(logs(i).folder,'Dendritic') && ~contains(logs(i).folder,'Colocalized')  && ~contains(logs(i).folder,'Colocalization')
        synaptic_log(synaptic_count+1)=logs(i);
        synaptic_count=synaptic_count+1;
    end
  waitbar(i/numFiles, f, sprintf('Progress Logs Synaptic: %d %%', floor(100*i/numFiles)));   
    
 end
 
 %now we look through all files, and only keep those in compartment_log that
%are associated with compartment parameters. Note that compartment refers to
%either Rab11a or Rab5 or Lamp1
 compartment_count=0;
 for i=1:numFiles
    file_delim=strsplit(logs(i).folder,'\');
    [~,n]=size(file_delim);
    if string(file_delim(n-1))==compart_string  &&   ~contains(logs(i).folder,'Dendritic') && ~contains(logs(i).folder,'Colocalized')  && ~contains(logs(i).folder,'Colocalization')
        compartment_log(compartment_count+1)=logs(i);
        compartment_count=compartment_count+1;
    end
  waitbar(i/numFiles, f, sprintf('Progress Logs Compartment: %d %%', floor(100*i/numFiles)));  
 end
 
 synaptic_den_count=0;
 for i=1:numFiles
    file_delim=strsplit(logs(i).folder,'\');
    [~,n]=size(file_delim);
    if string(file_delim(n-1))==syn_string  &&   contains(logs(i).folder,'Dendritic') && ~contains(logs(i).folder,'Colocalized')  && ~contains(logs(i).folder,'Colocalization')
        synaptic_den_log(synaptic_den_count+1)=logs(i);
        synaptic_den_count=synaptic_den_count+1;
    end
  waitbar(i/numFiles, f, sprintf('Progress Logs Dendritic Synaptic: %d %%', floor(100*i/numFiles)));  
 end
 
  compartment_den_count=0;
 for i=1:numFiles
    file_delim=strsplit(logs(i).folder,'\');
    [~,n]=size(file_delim);
    if string(file_delim(n-1))==compart_string  &&   contains(logs(i).folder,'Dendritic') && ~contains(logs(i).folder,'Colocalized')  && ~contains(logs(i).folder,'Colocalization')
        compartment_den_log(compartment_den_count+1)=logs(i);
        compartment_den_count=compartment_den_count+1;
    end
  waitbar(i/numFiles, f, sprintf('Progress Logs Dendritic Compartment: %d %%', floor(100*i/numFiles)));  
 end
 
 close(f)
 
 

%%
clearvars -except syn_string compart_string image_name images logs p_folder filament_log filament_count compartment_log compartment_den_log compartment_count compartment_den_count synaptic_log synaptic_den_log synaptic_count synaptci_den_count;
 

to_open={'_Dendrite_Length.csv','_Spine_Part_Volume_Head.csv','_Spine_Part_Volume_Neck.csv','_Spine_Length.csv','_Spine_Volume.csv','_Spine_Part_Mean_Diameter_Head.csv','_Spine_Part_Max_Diameter_Head.csv','_Spine_Part_Mean_Diameter_Neck.csv'};
to_open=string(to_open);    
parameter_names={'den_length_num','spine_head_volume_num','spine_neck_volume_num','spine_length_num','spine_volume_num', 'spine_mean_width_head_num', 'spine_max_width_head_num', 'spine_mean_width_neck_num'};

 
average_names={'Image Name','Dendrite Length','Spine Density','Average spine length','Average spine volume','Average spine head volume','Average spine neck volume','Average min puncta distance','Average overlap volume','Average Colocalized Volume Ratio'};
average_names=string(average_names);
Average_parameters=cell(images+1,length(average_names));
 for k=1:length(average_names)
     Average_parameters(1,k)=cellstr(average_names(1,k));
 end

classification_names={'Image Name','0 clusters','1 clusters','2 clusters','3+ clusters'};
classification_names=string(classification_names); 
Spine_classification_synaptic=cell(images+1,length(classification_names)); 
Spine_classification_compartment=cell(images+1,length(classification_names));
 for k=1:length(classification_names)
    Spine_classification_synaptic(1,k)=cellstr(classification_names(1,k));
    Spine_classification_compartment(1,k)=cellstr(classification_names(1,k));
 end

all_names_synaptic={'Image Name','Number of head puncta','Average Head puncta volume','Average Head puncta area','Number of neck puncta','Average Neck puncta volume','Average Neck puncta area'};
all_names_synaptic=string(all_names_synaptic);
 All_synaptic_parameters=cell(images+1,length(all_names_synaptic));
 for k=1:length(all_names_synaptic)
    All_synaptic_parameters(1,k)=cellstr(all_names_synaptic(1,k));
 end
 
all_names_compartment={'Image Name','Number of head puncta','Average Head puncta volume','Average Head puncta area','Number of neck puncta','Average Neck puncta volume','Average Neck puncta area'};
all_names_compartment=string(all_names_compartment);
All_compartment_parameters=cell(images+1,length(all_names_compartment));
 for k=1:length(all_names_compartment)
    All_compartment_parameters(1,k)=cellstr(all_names_compartment(1,k));
 end
 
 
histo_len_syn_vol=zeros(200,images);
histo_len_com_vol=zeros(200,images);
histo_len_syn_area=zeros(200,images);
histo_len_com_area=zeros(200,images);
histo_len_syn_den_vol=zeros(200,images);
histo_len_com_den_vol=zeros(200,images);
histo_len_syn_den_area=zeros(200,images);
histo_len_com_den_area=zeros(200,images);
histo_len_spine_len=zeros(200,images);
histo_len_spine_vol=zeros(200,images); 
histo_len_spine_head_vol=zeros(200,images); 
histo_len_spatial=zeros(200,images);
histo_len_overlap=zeros(200,images);

i=1;
f1 = waitbar(0, sprintf('Processing Dendrite: %d / %d', i,images));
pos1=[585.0000  250.0000  270.0000   56.2500];
set(f1,'position',pos1,'doublebuffer','on'); 
 
for i=1:images
   
    Average_parameters(i+1,1)=cellstr(image_name(1,i));
    Spine_classification_synaptic(i+1,1)=cellstr(image_name(1,i));
    Spine_classification_compartment(i+1,1)=cellstr(image_name(1,i));
    All_synaptic_parameters(i+1,1)=cellstr(image_name(1,i));
    All_compartment_parameters(i+1,1)=cellstr(image_name(1,i));
    
    for j=1:filament_count 
    file_delim=strsplit(filament_log(j).folder,'\');
    [~,n]=size(file_delim);
    temp_str=string(file_delim(n-2));
     
     if(strcmp(temp_str,image_name(1,i)))
         for k=1:length(to_open)
            if contains(filament_log(j).name,to_open(1,k))
                [parameter_field.(parameter_names{k}),~,~]=xlsread(fullfile(filament_log(j).folder,filament_log(j).name));
            end
         end    
     end
    end
    
    [den_length,spine_density, avg_spine_length, avg_spine_vol,avg_spine_head_volume, avg_spine_neck_volume]=filament_parameters(parameter_field.den_length_num,parameter_field.spine_length_num, parameter_field.spine_volume_num,parameter_field.spine_head_volume_num,parameter_field.spine_neck_volume_num,0.36);
    Average_parameters(i+1,2)=num2cell(den_length);
    Average_parameters(i+1,3)=num2cell(spine_density);
    Average_parameters(i+1,4)=num2cell(avg_spine_length);
    Average_parameters(i+1,5)=num2cell(avg_spine_vol);
    Average_parameters(i+1,6)=num2cell(avg_spine_head_volume);
    Average_parameters(i+1,7)=num2cell(avg_spine_neck_volume);
    
    [synaptic,compartment]=puncta_compile(image_name,i, synaptic_log,compartment_log);
    [synaptic_puncta_head,synaptic_puncta_neck, compartment_puncta_head,compartment_puncta_neck] =  puncta_dsitribution_in_spine(synaptic,compartment);
    
    All_synaptic_parameters(i+1,2)=num2cell(sum(synaptic_puncta_head(:,4)));
    All_synaptic_parameters(i+1,3)=num2cell(sum(synaptic_puncta_head(:,3))/sum(synaptic_puncta_head(:,4)));
    All_synaptic_parameters(i+1,4)=num2cell(sum(synaptic_puncta_head(:,2))/sum(synaptic_puncta_head(:,4)));
    All_synaptic_parameters(i+1,5)=num2cell(sum(synaptic_puncta_neck(:,4)));
    All_synaptic_parameters(i+1,6)=num2cell(sum(synaptic_puncta_neck(:,3))/sum(synaptic_puncta_neck(:,4)));
    All_synaptic_parameters(i+1,7)=num2cell(sum(synaptic_puncta_neck(:,2))/sum(synaptic_puncta_neck(:,4)));
    
    
    All_compartment_parameters(i+1,2)=num2cell(sum(compartment_puncta_head(:,4)));
    All_compartment_parameters(i+1,3)=num2cell(sum(compartment_puncta_head(:,3))/sum(compartment_puncta_head(:,4)));
    All_compartment_parameters(i+1,4)=num2cell(sum(compartment_puncta_head(:,2))/sum(compartment_puncta_head(:,4)));
    All_compartment_parameters(i+1,5)=num2cell(sum(compartment_puncta_neck(:,4)));
    All_compartment_parameters(i+1,6)=num2cell(sum(compartment_puncta_neck(:,3))/sum(compartment_puncta_neck(:,4)));
    All_compartment_parameters(i+1,7)=num2cell(sum(compartment_puncta_neck(:,2))/sum(compartment_puncta_neck(:,4)));

    [histo_len_spine_len]=para_hist(parameter_field.spine_length_num(:,1),i,histo_len_spine_len,1);
    [histo_len_spine_vol]=para_hist(parameter_field.spine_volume_num(:,1),i,histo_len_spine_vol,1);
    [histo_len_spine_head_vol]=para_hist(parameter_field.spine_head_volume_num(:,1),i,histo_len_spine_head_vol,1);
    [histo_len_syn_vol]=para_hist(synaptic(:,3),i,histo_len_syn_vol,1);
    [histo_len_syn_area]=para_hist(synaptic(:,2),i,histo_len_syn_area,1);
    [histo_len_com_vol]=para_hist(compartment(:,3),i,histo_len_com_vol,1);
    [histo_len_com_area]=para_hist(compartment(:,2),i,histo_len_com_area,1);
    
    [only_dendritic_syn,only_dendritic_com]=isolate_dendritic(i,image_name,synaptic_log,compartment_log, synaptic_den_log, compartment_den_log);
    
    [den_synaptic,den_compartment]=dendritic_distribution(image_name,i,only_dendritic_syn,only_dendritic_com,synaptic_den_log, compartment_den_log);
    
    [histo_len_syn_den_vol]=para_hist(den_synaptic(:,3),i,histo_len_syn_den_vol,1);
    [histo_len_syn_den_area]=para_hist(den_synaptic(:,2),i,histo_len_syn_den_area,1);
    [histo_len_com_den_vol]=para_hist(den_compartment(:,3),i,histo_len_com_den_vol,1);
    [histo_len_com_den_area]=para_hist(den_compartment(:,2),i,histo_len_com_den_area,1);
    
    
    [spatial_distribution]=spatial_puncta_distribution(i, image_name, synaptic_log, compartment_log, synaptic_den_log, compartment_den_log, only_dendritic_syn,only_dendritic_com);
    [histo_len_spatial]=para_hist(spatial_distribution(:,1),i,histo_len_spatial,1);
    
    sp=mean(spatial_distribution);
    Average_parameters(i+1,8)=num2cell(sp);
    
    [overlap_sp,overlap_den]=overlap_volume(i, image_name, synaptic_log, compartment_log, synaptic_den_log, compartment_den_log, only_dendritic_syn,only_dendritic_com);
    
     [s,~]=size(overlap_den);
    overlap=overlap_sp;
    overlap(end+1:end+s,1)=overlap_den;
    
    o=mean(overlap);
    Average_parameters(i+1,9)=num2cell(o);
    
    [histo_len_overlap]=para_hist(overlap_sp(:,1),i,histo_len_overlap,1);
    
    
    [volume_spine_ratio,volume_den_ratio]=Colocalized_volume_ratio(i, image_name, synaptic_log, compartment_log, synaptic_den_log, compartment_den_log,den_synaptic,den_compartment);
    
    [s,~]=size(volume_den_ratio);
    volume_ratio=volume_spine_ratio;
    %volume_ratio(end+1:end+s,1)=volume_den_ratio;
    
    v=mean(volume_ratio);
    Average_parameters(i+1,10)=num2cell(v);
    
    [histo_len_vol_ratio_colocalized]=para_hist(volume_spine_ratio(:,1),i,histo_len_overlap,1);
    
    [classification_by_synaptic]=Spine_classify_by_puncta(parameter_field.spine_length_num, synaptic(:,[1,4]));
    [classify1,classify2]=groupcounts(classification_by_synaptic(:,2));
    
    max_class=max(classify2);
    for count=1:max_class+1
        Spine_classification_synaptic(i+1,count+1)=num2cell(classify1(count));
    end
    if max_class<3
       for count=max_class+2:4
          Spine_classification_synaptic(i+1,count+1)=num2cell(0); 
       end
    end
    [classification_by_compartment]=Spine_classify_by_puncta(parameter_field.spine_length_num, compartment(:,[1,4]));
    [classify1,classify2]=groupcounts(classification_by_compartment(:,2));
    %sum_class=sum(classify1);
    %classify1=classify1*100/sum_class;
    max_class=max(classify2);
    for count=1:max_class+1
        Spine_classification_compartment(i+1,count+1)=num2cell(classify1(count));
    end
    if max_class<3
       for count=max_class+2:4
          Spine_classification_compartment(i+1,count+1)=num2cell(0); 
       end
    end
    
    
    
    
 waitbar(i/images, f1, sprintf('Processing Dendrite: %d / %d', i+1,images));
  
   
end
close(f1)


histo_len_com_area(histo_len_com_area==0)=NaN;
histo_len_com_den_area(histo_len_com_den_area==0)=NaN;
histo_len_com_den_vol(histo_len_com_den_vol==0)=NaN;
histo_len_com_vol(histo_len_com_vol==0)=NaN;
histo_len_overlap(histo_len_overlap==0)=NaN;
histo_len_spatial(histo_len_spatial==0)=NaN;
histo_len_spine_head_vol(histo_len_spine_head_vol==0)=NaN;  
histo_len_spine_len(histo_len_spine_len==0)=NaN;
histo_len_spine_vol(histo_len_spine_vol==0)=NaN;
histo_len_syn_area(histo_len_syn_area==0)=NaN;
histo_len_syn_den_area(histo_len_syn_den_area==0)=NaN;
histo_len_syn_den_vol(histo_len_syn_den_vol==0)=NaN;
histo_len_syn_vol(histo_len_syn_vol==0)=NaN;;
histo_len_vol_ratio_colocalized(histo_len_vol_ratio_colocalized==0)=NaN;
