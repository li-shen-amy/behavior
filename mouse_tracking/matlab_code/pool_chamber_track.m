clc;clear;close all;
prepath='/Users/Emily/Documents/PVT/behavior/';
behavior_test_list=dir(prepath);
count=0;
seg_default=60;
for fi=1:length(behavior_test_list)
    if behavior_test_list(fi).isdir & strfind(behavior_test_list(fi).name,'chamber')
        xpn=fullfile(prepath,behavior_test_list(fi).name);
        movlist=dir(xpn);
        date_str=behavior_test_list(fi).name(1:8);
        for fj=1:length(movlist)
            if strfind(movlist(fj).name,'.mat')
                movdata=load(fullfile(xpn,movlist(fj).name));
                count=count+1;
                distance_all{count}=movdata.distance;
                date_all{count}=date_str;
                if strfind(behavior_test_list(fi).name,'2chamber')
                    chamber_no(count)=2;
                else
                    chamber_no(count)=1;
                end
                no_idx=strfind(movlist(fj).name,'#');
                animal_no(count)=str2num(movlist(fj).name(no_idx(1)+1));
                if strfind(movlist(fj).name,'Control');
                    animal_no(count)= animal_no(count)+2;
                end
                time_end=length(movdata.distance);
                seg_bin=0:seg_default:time_end;
                for si=1:length(seg_bin)-1
                    tmp=movdata.distance(seg_bin(si)+1:seg_bin(si+1));
                    mean_speed_min{count}(si)=mean(tmp(~isnan(tmp)));
                end
            end
        end
    end
end
%%
figure,hold on
for fi=1:length(mean_speed_min)
    if strcmp(date_all{fi},'20171129')
        day_no(fi)=1;
    elseif  strcmp(date_all{fi},'20171130')
         day_no(fi)=2;
    else
         day_no(fi)=str2num(date_all{fi})-20171200+2;
    end
    if animal_no(fi)>2
        color_code=0.5*ones(1,3);
    elseif animal_no(fi)==1
        color_code=[1,0,0];
    elseif animal_no(fi)==2
        color_code=[0,1,0];
    end
    plot(1:length(mean_speed_min{fi}),mean_speed_min{fi}./mean_speed_min{fi}(1),...
        'color',color_code);
    speed_decay(fi)=mean_speed_min{fi}(2)./mean_speed_min{fi}(1);
end
animal1_idx=find(animal_no==1);
animal2_idx=find(animal_no==2);
control_idx=find(animal_no>2);
figure,hold on
plot(day_no(animal1_idx),speed_decay(animal1_idx),'r^');
plot(day_no(animal2_idx),speed_decay(animal2_idx),'b^');
plot(day_no(control_idx),speed_decay(control_idx),'^','color',0.5*ones(1,3));