% speed analysis
clc;clear;close all;

fatherfolder='/Users/Emily/Documents/PVT/behavior/';
 prepath='apvt-zi/2step_zi';
% % prepath='apvt-zi/20180209';
% prepath='jump_mouse/20180110_apvt_vglut2_chr2_2chamber';
% prepath='20171219_CHR2xVGLUT2';
% prepath='20171216_CHR2xVGLUT2';
% prepath='20171215_CHR2xVGLUT2';

% fatherfolder='/Users/Emily/Documents/LS/';
% prepath='20180321_2chamber';

combine=0;
if combine==1
    seg=[1,2];
    % ia=[];
    % ib=[];
    distance=[];
    in_led=[];
    out_led=[];
    start_t=0;
    for iseg=1:length(seg)
        movname=['vglut2_chr2_apvt_zi_female_L1R1_2#_2chamber',num2str(seg(iseg))];
        track_filename=fullfile(fatherfolder,prepath,[movname,'_track']);
        tmp=load(track_filename);
        % ia=[ia,tmp.ia];
        % ib=[ib,tmp.ib];
        distance=[distance,tmp.distance];
        
        stim_box='left';
        if strcmp(stim_box,'right')
            in_led_tmp=find(tmp.ia(2:end)>tmp.x_stimbound);
        else
            in_led_tmp=find(tmp.ia(2:end)<tmp.x_stimbound);
        end
        out_led_tmp=setdiff(1:length(tmp.ia)-1,in_led_tmp);
        in_led=[in_led,in_led_tmp+start_t];
        out_led=[out_led,out_led_tmp+start_t];
        start_t=length(distance);
    end
else
    %         movname='vglut2_chr2_apvt_zi_female_none_1#_2chamber';
    %           stim_box='right';
    
    %         movname='vglut2_chr2_apvt_zi_female_R1_3#_2chamber';
    %            stim_box='left';
    
    %         movname='vglut2_chr2_apvt_zi_male_L2R1_1#_2chamber';
    
    %     movname='vglut2_chr2_apvt_zi_male_R1_2#_2chamber';% speed up
    
%     movname='20180110_1#_None_1';%slower ns
%     movname='20180110_1#_None_2';%slower ns
%     movname='20180110_3#_L1';%slower ns
%     movname='20180110_apvt_vglut2xchr2_2#_red';%speed up ns
%     stim_box='left';
%     
%     %     movname='20180110_2#_R1';%speed up ns
%    
%     % movname='20180110_apvt_vglut2xchr2_1#_none';%slower ns
%     movname='20171219_Non_2chamber';%slower ns
%     movname='20171219_Red_2chamber';% significant slower
%     movname='20171216_Non_2chamber_top';% significant slower
%     movname='20171216_Red_2chamber_top';%slower ns
%     % movname='20171215_Non_2chamber_trimmed';% 100%
%     movname='20171215_Red_2chamber';% significant slower
%     stim_box='right';
    
%     movname='1_pencil';
%      stim_box='right';
     
%      movname='20180409_1_2chamber_leftled';
%      movname='20180409_1_2chamber_rightled';
% stim_box='left';

% movname='20180409_2_2chamber-leftled';
movname='20180409_2_2chamber-rightled';
stim_box='right';

     
    track_filename=fullfile(fatherfolder,prepath,[movname,'_track']);
    load(track_filename);
    
    if strcmp(stim_box,'right')
        in_led=find(ia(2:end)>x_stimbound);
    else
        in_led=find(ia(2:end)<x_stimbound);
    end
    out_led=setdiff(1:length(ia)-1,in_led);
end
%%
ave_bin=1;
tmp=reshape(distance(1:ave_bin*fix(length(distance)/ave_bin)),ave_bin,fix(length(distance)/ave_bin));
distance_ave=mean(tmp,1);
stim_label(in_led)=1;
stim_label(out_led)=0;
tmp=reshape(stim_label(1:ave_bin*fix(length(distance)/ave_bin)),ave_bin,fix(length(distance)/ave_bin));
stim_label_ave=mean(tmp,1);
in_led_ave=find(stim_label_ave>=0.5);
out_led_ave=find(stim_label_ave<0.5);

speed_stim=distance_ave(in_led_ave);
speed_nostim=distance_ave(out_led_ave);
mean_speed_stim=mean(speed_stim)
mean_speed_nostim=mean(speed_nostim)
median_speed_stim=median(speed_stim)
median_speed_nostim=median(speed_nostim)
se_speed_stim=std(speed_stim)./sqrt(length(speed_stim))
se_speed_nostim=std(speed_nostim)./sqrt(length(speed_nostim))
[p,h]=ranksum(speed_stim,speed_nostim)

speed_bin=0:2:30;
count_speed_stim=histc(speed_stim,speed_bin)/sum(speed_stim);
count_speed_nostim=histc(speed_nostim,speed_bin)/sum(speed_nostim);
pdf_speed_stim=cumsum(count_speed_stim)/sum(count_speed_stim);
pdf_speed_nostim=cumsum(count_speed_nostim)/sum(count_speed_nostim);
%%
blue_light=[0.9,0.9,1];
shade_color=0.9*ones(1,3);

figure,set(gcf,'position',[70   245   983   453]);
subplot(131),
b=bar([1,2],[mean_speed_stim,mean_speed_nostim],'facecolor','w');
% set(b(1),'facecolor',blue_light,'edgecolor','none');
% set(b(2),'facecolor',shade_color,'edgecolor','none');
hold on
errorbar([1,2],[mean_speed_stim,mean_speed_nostim],...
    [se_speed_stim,se_speed_nostim],'k','linestyle','none');
set(gca,'xticklabel',{'LED ON','LED OFF'});
box off;

subplot(132),b=bar(speed_bin,[count_speed_stim',count_speed_nostim']);
set(b(1),'facecolor','b','edgecolor','none');
set(b(2),'facecolor',shade_color);%,'edgecolor','none');

subplot(133),plot(speed_bin,pdf_speed_stim,'color','b','linewidth',2);
hold on
plot(speed_bin,pdf_speed_nostim,'color',shade_color,'linewidth',2);
legend('LED ON','LED OFF');