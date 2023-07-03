function [den_length,spine_density, avg_spine_length, avg_spine_vol,avg_spine_head_volume, avg_spine_neck_volume]=filament_parameters(den_length_num,spine_length_num,spine_volume_num,spine_head_volume_num,spine_neck_volume_num,len_thresh)

dendrite_length=0;
no_of_spines=0;
avg_spine_length=0;
avg_spine_vol=0;
avg_spine_head_volume=0;
avg_spine_neck_volume=0;

dendrite_length=max(den_length_num(:,1));
f = waitbar(0, 'Starting');

for counter=1:length(spine_length_num)
   if spine_length_num(counter,1)>len_thresh
     no_of_spines=no_of_spines+1;
      avg_spine_length=avg_spine_length+spine_length_num(counter,1);
      avg_spine_vol=avg_spine_vol+spine_volume_num(counter,1);
      avg_spine_head_volume= avg_spine_head_volume+spine_head_volume_num(counter,1);
      avg_spine_neck_volume= avg_spine_neck_volume+spine_neck_volume_num(counter,1);
   end
   
 waitbar(counter/length(spine_length_num), f, sprintf('Calculating average dendritic parameters: %d %%', floor(100*counter/length(spine_length_num))));  
end

avg_spine_length=avg_spine_length/no_of_spines;
avg_spine_vol=avg_spine_vol/no_of_spines;
avg_spine_head_volume= avg_spine_head_volume/no_of_spines;
avg_spine_neck_volume= avg_spine_neck_volume/no_of_spines;
spine_density=no_of_spines/dendrite_length;
den_length=dendrite_length;
close(f);
end