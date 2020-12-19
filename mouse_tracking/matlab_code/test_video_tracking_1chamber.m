clc;clear;close all;
dbstop if error
selet_ui=0;%1;
if_roi=0;
roi=[180,430,80,330];
ext='.mov';
% prepath='/Users/Emily/Documents/PVT/behavior/20171129_2chamber';
% prepath='/Users/Emily/Documents/PVT/behavior/20171130_1chamber';
% prepath='/Users/Emily/Documents/PVT/behavior/20171201_1chamber';

% prepath='/Users/Emily/Documents/PVT/behavior/20171205_1chamber';
% prepath='/Users/Emily/Documents/PVT/behavior/20171206_1chamber';
% prepath='/Users/Emily/Documents/PVT/behavior/20171207_1chamber';

% prepath='/Users/Emily/Documents/PVT/behavior/20171205_1chamber_control';

% prepath='/Users/Emily/Documents/PVT/behavior/20171215_CHR2xVGLUT2';
prepath='/Users/Emily/Documents/PVT/behavior/20171216_CHR2xVGLUT2';

find_spon=0;%1;
if selet_ui==1
    %     prepath='/Users/Emily/Documents/behavior/TWp';
    [movname,xpn,~]=uigetfile(ext,'Select a video file',prepath);
    tmp=fileparts(xpn);
    [~,movname]=fileparts(movname);
    %     date=tmp(strfind(tmp,prepath)+length(prepath):end);
else
    %     date='20171010';
    %     movname='group1_1_TWx5';
    
%         movname='PVT_A_#1';
%         movname='PVT_P_#1';
%         movname='PVT_AP_#2';
    
%       movname='PVT_#1_Male_WT_20171130_1chamber';     
%       movname='PVT_#2_Male_WT_20171130_1_1chamber';
%       movname='PVT_#2_Male_WT_20171130_2_1chamber';
    
    %         movname='pvt_#1_spon_20171201';
    %         movname='pvt_#1_newcontext_20171201';
    %         movname='pvt_#2_20171201';
    
    %         movname='pvt_#1_spon_20171205';
    %         movname='pvt_#2_spon_20171205';
    
    %         movname='pvt_#1_spon_20171206';
    %         movname='pvt_#2_spon_20171206';
    
    % movname='pvt_#1_spon_20171207';
    % movname='pvt_#2_spon_20171207';
    
    
%     movname='Control_POA_GAD2_Female_#1_NoStim';
%     movname='Control_POA_GAD2_Female_#2_NoStim';
%     movname='Control_POA_GAD2_Female_#3_NoStim';
%     movname='Control_POA_GAD2_Female_#4_NoStim';
%     movname='Control_POA_GAD2_Female_#5_NoStim';
    
% movname='20171215_non_1chamber';
% movname='20171215_non_2chamber';
% movname='20171215_non_2chamber_trimmed';

movname='20171216_Red_2chamber_top';
    xpn=prepath;%fullfile(prepath,date);
end
background_time=3;
start_time=0;
led_box='right';

if strcmp(movname,'20171215_non_1chamber');
background_time=4;
start_time=13;
elseif strfind(movname,'20171215_non_2chamber');
background_time=31;
start_time=182;
led_box='right';
elseif strfind(movname,'20171216_Red_2chamber_top');
    background_time=3;
start_time=3;
led_box='right';
end

movfullname=fullfile(xpn,[movname,ext]);
V=VideoReader(movfullname);

while V.CurrentTime<background_time
    video=readFrame(V);%,'native');
end
if strfind(movname,'20171215_non_2chamber')
    video=video(98:239,203:419,:);
end
FPS=V.FrameRate;
dur=V.Duration;
%%
if if_roi==1
    track_post='_roi_track.csv';
else
    track_post='_track.csv';
end
M=csvread(strrep(movfullname,'.mov',track_post));
t=M(:,1);
x=M(:,2);
y=M(:,3);
idx_valid=find(t>start_time*FPS);
t=t(idx_valid)-start_time*FPS;
x=x(idx_valid);
y=y(idx_valid);

while length(unique(t))<length(t)
    %     idx_rep=find(t(2:end)-t(1:end-1)==0);
    [uni_t,ix,~]=unique(t);
    idx_rep=setdiff(1:length(t),ix);
    t=t(setdiff(1:length(t),idx_rep));
    x=x(setdiff(1:length(x),idx_rep));
    y=y(setdiff(1:length(y),idx_rep));
end
if if_roi==1
    x=x+roi(3);
    y=y+roi(1);
end
%% box parameters
ymin=185;
ymax=300;
ymin_xmin=175;
ymin_xmax=439;
ymax_xmin=76;
ymax_xmax=550;

if strfind(movname,'20171130');
    ymin=185;
    ymax=300;
    ymin_xmin=175;
    ymin_xmax=439;
    ymax_xmin=76;
    ymax_xmax=550;
elseif strfind(movname,'pvt_#1_spon_20171201') %| strfind(movname,'pvt_#2_20171201')
    ymin=138.1471;
    ymax=270.1886;
    ymin_xmin=189.8333;
    ymin_xmax= 449.3889;
    ymax_xmin= 79.6111;
    ymax_xmax=563.1667;
elseif strfind(movname,'pvt_#2_20171201')
    %     ymin=160;
    %     ymax=350;
    %     ymin_xmin=200;
    %     ymin_xmax=439;
    %     ymax_xmin=0;
    %     ymax_xmax=620;
    
    ymin= 143.1298;
    ymax= 275.1713;
    ymin_xmin=204.0556;
    ymin_xmax=  438.7222;
    ymax_xmin=  72.5000;
    ymax_xmax=563.1667;
elseif  strfind(movname,'newcontext')
    ymin=235;
    ymax=320;
    ymin_xmin=140;
    ymin_xmax=510;
    ymax_xmin=0;
    ymax_xmax=640;
elseif strfind(movname,'Control')
    %     ymin=230;
    %     ymax=330;
    %     ymin_xmin=197;
    %     ymin_xmax=464;
    %     ymax_xmin=54;
    %     ymax_xmax=620;
    
    ymin=207.9048;
    ymax=  276;
    ymin_xmin=172.5334;
    ymin_xmax=468.46669;
    ymax_xmin=111.9206;
    ymax_xmax=550.4721;
elseif strfind(movname,'PVT_A_#1')
    ymin=50;
    ymax=297.7457;
    ymin_xmin=150;
    ymin_xmax=524;
    ymax_xmin=150;
    ymax_xmax=524;
elseif strcmp(movname,'PVT_P_#1') || strcmp(movname,'PVT_AP_#2')
    ymin=55;
    ymax=323.27;
    ymin_xmin=134;
    ymin_xmax=547;
    ymax_xmin=139;
    ymax_xmax=540;
elseif strfind(xpn,'20171205_1chamber')
    ymin= 237.8010;
    ymax=312.5415;
    ymin_xmin=131.1667;
    ymin_xmax= 476.0556;
    ymax_xmin=76.2660;
    ymax_xmax=578.9958;
elseif strfind(movname,'pvt_#1_spon_20171206')
    ymin=3.6142;
    ymax=262.7145;
    ymin_xmin= 200.5000;
    ymin_xmax=  463.6111;
    ymax_xmin= 200.5000;
    ymax_xmax=463.6111;
elseif strfind(movname,'pvt_#2_spon_20171206')
    ymin=28.5277;
    ymax=282.6453;
    ymin_xmin= 200.5000;
    ymin_xmax= 452.9444;
    ymax_xmin= 200.5000;
    ymax_xmax=452.9444;
elseif strfind(movname,'pvt_#1_spon_20171207')
    ymin=11.0882;
    ymax=265.2059;
    ymin_xmin=  182.7222;
    ymin_xmax=460.0556;
    ymax_xmin= 204.0556;
    ymax_xmax= 435.1667;
    
elseif strfind(movname,'pvt_#2_spon_20171207')
    ymin= 48.4585;
    ymax=292.6107;
    ymin_xmin= 193.3889;
    ymin_xmax=456.5000;
    ymax_xmin= 204.0556;
    ymax_xmax= 431.6111;
    
    invalid_idx=find(x>ymin_xmax);
    nt=length(t);
    t=t(setdiff(1:nt,invalid_idx));
    x=x(setdiff(1:nt,invalid_idx));
    y=y(setdiff(1:nt,invalid_idx));
elseif  strfind(movname,'20171215_non_1chamber')
     ymin=  56.4708;
    ymax=269.8431;
    ymin_xmin= 203.6336;
    ymin_xmax=418.9332;
    ymax_xmin=203.6336;
    ymax_xmax= 418.9332;
elseif  strfind(movname,'20171215_non_2chamber')
%      ymin= 98.5146;
%     ymax=238.3102;
%     ymin_xmin=  203.6336;
%     ymin_xmax=418.9332;
%     ymax_xmin= 203.6336;
%     ymax_xmax= 418.9332;
       ymin= 0;
    ymax=size(video,1);
    ymin_xmin= 0;
    ymin_xmax=size(video,2);
    ymax_xmin= 0;
    ymax_xmax=size(video,2);
elseif strfind(movname,'20171216_Red_2chamber_top');
     ymin= 57.2299;
    ymax=277.3246;
    ymin_xmin= 140.6527;
    ymin_xmax=498.5153;
    ymax_xmin= 162.6374;
    ymax_xmax= 478.9733;
end
%%
% seg_default=fix(V.Duration/3);
seg_default=180;

win=[0,seg_default;seg_default,2*seg_default;2*seg_default,3*seg_default]*FPS;
% win=[0,V.Duration]*FPS;
title_list={['1st ',num2str(seg_default),'s'],...
    ['2nd ',num2str(seg_default),'s'],...
    ['Last ',num2str(seg_default),'s']};

% title_list={'Before LED (off,180s)','During LED (on,180s)','After LED (off,180s)'};
if  strcmp(movname,'PVT_#1_Male_WT_20171130_1chamber')
    win=[0,180;350,530;540,720]*FPS;
    
    % win2=[312,492]*FPS;%309-
    if find_spon==1
        seg_default=103;% for spon
        win=[0,seg_default;seg_default,2*seg_default;2*seg_default,3*seg_default]*FPS;
        title_list={['1st ',num2str(seg_default),'s'],...
            ['2nd ',num2str(seg_default),'s'],...
            ['Last ',num2str(seg_default),'s']};
    end
elseif  strcmp(movname,'PVT_#2_Male_WT_20171130_1_1chamber')
    win=[0,180;420,600;720,900]*FPS;
    if find_spon==1
        seg_default=109;% for spon
        win=[0,seg_default;seg_default,2*seg_default;2*seg_default,3*seg_default]*FPS;
        title_list={['1st ',num2str(seg_default),'s'],...
            ['2nd ',num2str(seg_default),'s'],...
            ['Last ',num2str(seg_default),'s']};
    end
elseif strcmp(movname,'pvt_#2_20171201')
    win=[0,180;600,780;790,970]*FPS;
    % win=[400,580;600,780;790,970]*FPS;
    %     win=[0,180;300,480;600,780;900,1080]*FPS;%790,970;1000,1180]*FPS;
    %     title_list={'Before LED (off,180s)','Before 2','During LED (on,180s)','After LED (off,180s)'};%,'After 2'};
    title_list={'Before LED (off,180s)','During LED (on,180s)','After LED (off,180s)'};%,'After 2'};
    
    if find_spon==1
        seg_default=180;% for spon
        win=[0,seg_default;seg_default,2*seg_default;2*seg_default,3*seg_default]*FPS;
        title_list={['1st ',num2str(seg_default),'s'],...
            ['2nd ',num2str(seg_default),'s'],...
            ['Last ',num2str(seg_default),'s']};
    end
elseif strcmp(movname,'pvt_#1_newcontext_20171201')
    t_last=[313:V.Duration]*FPS;
    t=[t;reshape(t_last,length(t_last),1)];
    jitterx=5;
    jittery=1;
    x=[x;173.3056*ones(length(t_last),1)+jitterx*(randn(length(t_last),1)-0.5)];
    y=[y;237.0015*ones(length(t_last),1)+jittery*(randn(length(t_last),1)-0.5)];
    win=[0,60;180,240;241,301;313,V.Duration]*FPS; %65~240;241~738, detect max=312
    title_list={'Before LED (off,60s)','During LED (on,60s)','After LED (off,60s)',['After LED 2(off,',num2str(length(t_last)),'s)']};
    
    %   win=[0,60;119,179;180,240;241,301]*FPS; %65~240;241~738, detect max=312
    %   title_list={'Before LED (off,60s)','During LED (on,60s)','During LED 2(on,60s)','After LED (off,60s)'};%,'After LED 2(off,60s)'};
    
    % elseif strcmp(movname,'pvt_#1_spon_20171201')
    %     win=[0,150;150,300;300,450]*FPS;
    %     title_list={'First 150s','Second 150s','Third 150s'};
    
    % elseif ~isempty(strfind(movname,'Control'))
    %     win=[0,250;250,500;500,750]*FPS;
    %     title_list={'First 250s','Second 250s','Third 250s'};
elseif  strcmp(movname,'20171215_non_1chamber')
     win=([13,119;121,192;197,256]-13)*FPS;
      title_list={['LED off(',num2str((win(1,2)-win(1,1))/FPS),'s)'],...
          ['ON(',num2str((win(2,2)-win(2,1))/FPS),'s)'],...
          ['Off(',num2str((win(3,2)-win(3,1))/FPS),'s)']};   
elseif ~isempty(strfind(xpn,'2chamber')) || ~isempty(strfind(movname,'2chamber'))
    win=[start_time,V.Duration]*FPS;
    title_list={'Real-time preference'};
end

% axis_bound=[0,600,100,300];
axis_bound_norm=[-0.2,1.2,0,1.4];

% end

bottom_left=[ymin_xmin,ymin];%[215,146];
bottom_right=[ymin_xmax,ymin];%[396,146];
top_left=[ymax_xmin,ymax];
top_right=[ymax_xmax,ymax];%[545,300];
boundary=[bottom_left;bottom_right;top_right;top_left;bottom_left];
boundary_norm=[0,0;1,0;1,1;0,1;0,0];

y_trans=(y-ymin)./(ymax-ymin);
xmin_trans=ymin_xmin+y_trans*(ymax_xmin-ymin_xmin);
xmax_trans=ymin_xmax+y_trans*(ymax_xmax-ymin_xmax);
x_trans=(x-xmin_trans)./(xmax_trans-xmin_trans);

nwin=size(win,1);
clear seg
for i=1:nwin
    seg{i}=find(t>win(i,1) & t<win(i,2));
end

shade_color=0.9*ones(1,3);
blue_light=[0.9,0.9,1];


if ~isempty(strfind(xpn,'2chamber')) || ~isempty(strfind(movname,'2chamber'))
     ygap= 191;
        xgap=[318,338];
        if strcmp(movname,'PVT_A_#1')
        ygap=160;
        xgap=[317,338];
    elseif strcmp(movname,'PVT_P_#1') ||  strcmp(movname,'PVT_AP_#2')
        ygap= 191;
        xgap=[318,338];
    end
    box_point=[ymin_xmin,ymin;xgap(1),ymin;xgap(1),ygap;
        xgap(2),ygap;xgap(2),ymin;ymin_xmax,ymin;
        ymax_xmax,ymax;ymax_xmin,ymax;ymin_xmin,ymin];
    if strcmp(led_box,'left')
        stimbox_point=[ymin_xmin,ymin;xgap(1),ymin;xgap(1),ymax;...
            ymax_xmin,ymax;ymin_xmin,ymin];
    else
        stimbox_point=[mean(xgap),ymin;mean(xgap),ymax;...
            ymax_xmax,ymax;ymin_xmax,ymin];
    end
    box_point_trans=box_point;
    box_point_trans(:,2)= (box_point(:,2)-ymin)./(ymax-ymin);
box_point_xmin_trans=ymin_xmin+box_point_trans(:,2)*(ymax_xmin-ymin_xmin);
box_point_xmax_trans=ymin_xmax+box_point_trans(:,2)*(ymax_xmax-ymin_xmax);
 box_point_trans(:,1)=( box_point(:,1)-box_point_xmin_trans)./(box_point_xmax_trans-box_point_xmin_trans);
stimbox_point_trans=stimbox_point;
 stimbox_point_trans(:,2)= (stimbox_point(:,2)-ymin)./(ymax-ymin); 
 stimbox_point_xmin_trans=ymin_xmin+ stimbox_point_trans(:,2)*(ymax_xmin-ymin_xmin);
 stimbox_point_xmax_trans=ymin_xmax+ stimbox_point_trans(:,2)*(ymax_xmax-ymin_xmax);
 stimbox_point_trans(:,1)=(  stimbox_point(:,1)- stimbox_point_xmin_trans)./( stimbox_point_xmax_trans- stimbox_point_xmin_trans);

    
    figure,
    set(gcf,'position',[   360   456   384   242]);
%     subplot(211),
    patch(stimbox_point(:,1),stimbox_point(:,2),blue_light,'edgecolor','none');
    % image(video);
    hold on,
    plot(x,y);
    plot(box_point(:,1),box_point(:,2),'k','linewidth',2);
    axis([ymin_xmin,ymin_xmax,ymin,ymax]);
    axis off
    
     figure,
    set(gcf,'position',[   360   456   384   242]);
%      subplot(212),
    patch(stimbox_point_trans(:,1),stimbox_point_trans(:,2),blue_light,'edgecolor','none');
    % image(video);
    hold on,
    plot(x_trans,y_trans);
    plot(box_point_trans(:,1),box_point_trans(:,2),'k','linewidth',2);
    axis([0,1,0,1]);
    axis off
    
end

figure,
if ~isempty(strfind(movname,'2chamber')) || ~isempty(strfind(prepath,'2chamber'))
set(gcf,'position',[ 63   130   421   575]);
else
set(gcf,'position',[ 5   282   843   423]);
end
for i=1:nwin
    subplot(2,nwin,i),
    image(video);%axis xy;
    hold on,
    plot(x(seg{i}),y(seg{i}),'k');%.','markersize',6);
    % axis(axis_bound);
    plot(boundary(:,1),boundary(:,2),'r');
    axis off
    title(title_list{i});
    
    subplot(2,nwin,i+nwin),
      hold on,
    % image(video);axis xy;
    patch(boundary_norm(:,1),boundary_norm(:,2),shade_color,'edgecolor','none');
    patch(stimbox_point_trans(:,1),stimbox_point_trans(:,2),blue_light,'edgecolor','none');
  
    plot(x_trans(seg{i}),1-y_trans(seg{i}),'k');
    axis(axis_bound_norm);
    box on
    set(gca,'xtick',[0,1],'ytick',[0,1]);
    axis off
end
%%
tq=1:max(t);
nFPS=round(FPS);

% x_transq = interp1(t,x_trans,tq);
% y_transq=interp1(t,y_trans,tq);
% x_trans_s=downsample(x_transq,nFPS);
% y_trans_s=downsample(y_transq,nFPS);

xq = interp1(t,x,tq);
yq=interp1(t,y,tq);
x_s=downsample(xq,nFPS);
y_s=downsample(yq,nFPS);

time_sample=t/FPS;
% in_left=find(x_trans_s<0.5);
% in_right=find(x_trans_s>0.5);
if ~isempty(strfind(xpn,'2chamber'))  || ~isempty(strfind(movname,'2chamber'))
    in_left=find(x_s<min(xgap));
    in_right=find(x_s>max(xgap));
    time_left=length(in_left);  % 331, 398
    time_right=length(in_right);  %271, 251
    if strcmp(led_box,'left')
        in_led=in_left;
        time_led=time_left;
        time_nostim=time_right;
    else
        in_led=in_right;
        time_led=time_right;
        time_nostim=time_left;
    end
    time_led
    time_nostim
    percetage_stimbox=time_led/(time_led+time_nostim)
end
% distance=sqrt((y_trans(2:end)-y_trans(1:end-1)).^2+...
%     (x_trans(2:end)-x_trans(1:end-1)).^2);

% distance=sqrt((yq(1+nFPS:nFPS:end)-yq(1:nFPS:end-nFPS)).^2+...
%     (xq(1+nFPS:nFPS:end)-xq(1:nFPS:end-nFPS)).^2);


distance=sqrt((y_s(2:end)-y_s(1:end-1)).^2+...
    (x_s(2:end)-x_s(1:end-1)).^2);
%%
% y_s_trans=(y_s-ymin)./(ymax-ymin);
% xmin_s_trans=ymin_xmin+y_s_trans*(ymax_xmin-ymin_xmin);
% xmax_s_trans=ymin_xmax+y_s_trans*(ymax_xmax-ymin_xmax);
% x_s_trans=(x_s-xmin_s_trans)./(xmax_s_trans-xmin_s_trans);

% distance=sqrt((y_s_trans(2:end)-y_s_trans(1:end-1)).^2+...
%     (x_s_trans(2:end)-x_s_trans(1:end-1)).^2);% error when rearing

%%
led_box=[];
max_speed=max(distance);
mean_speed=mean(distance);
figure,set(gcf,'position',[ 227   478   910   220]);
hold on
if ~isempty(strfind(xpn,'2chamber')) || ~isempty(strfind(movname,'2chamber'))
    for i=1:length(in_led)
        led_box=[in_led(i)-0.5,max_speed;in_led(i)+0.5,max_speed;
            in_led(i)+0.5,0;in_led(i)-0.5,0];
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
    end
else
    if  strfind(movname,'PVT_#1_Male_WT_20171130_1chamber')
        led_box=[310,max_speed;510,max_speed;
            510,0;310,0];
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
        
    end
    
    if  strfind(movname,'PVT_#2_Male_WT_20171130_1_1chamber')
        led_box=[330,max_speed;526,max_speed;
            526,0;330,0];
      
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
    end
    
     if  strfind(movname,'20171215_non_1chamber')
        led_box=[win(2,1)/FPS,max_speed;win(2,2)/FPS,max_speed;
            win(2,2)/FPS,0;win(2,1)/FPS,0];
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
    end
    
    clear mean_speed
    for i=1:nwin
        l1= plot( win(i,1)/FPS*ones(1,2),[0,max_speed],'color',[ 0.4660    0.6740    0.1880]);
        l2= plot( win(i,2)/FPS*ones(1,2),[0,max_speed],'color',[ 0.4660    0.6740    0.1880]);
        tmp=distance(max([1,fix(win(i,1)/FPS)]): min([length(distance),fix(win(i,2)/FPS)]));
        mean_speed(i)=mean(tmp(~isnan(tmp)));
        text(win(i,1)/FPS+(win(i,2)-win(i,1))/2/FPS,max_speed,num2str( mean_speed(i),2));
    end
end
plot(distance,'k','linewidth',2);box off;
ylabel('Speed');xlabel('Time');
xlim([0,time_sample(end)]);
if strcmp(movname,'pvt_#2_20171201')
    xlim([0,win(3,2)]/FPS);
end
if strcmp(movname,'PVT_#1_Male_WT_20171130_1chamber')
    xlim([0,755]);
    distance=distance(1:755);
end
if strcmp(movname,'PVT_#2_Male_WT_20171130_2_1chamber')
      xlim([0,691]);
    distance=distance(1:691);
end
%%
if isempty(strfind(xpn,'2chamber'))
save(fullfile(xpn,movname),'distance','t','x','y','win','mean_speed',...
    'xq','yq','x_s','y_s','x_trans','y_trans','boundary','title_list','led_box',...
    'FPS','dur');
else
    save(fullfile(xpn,movname),'distance','t','x','y','win',...
    'xq','yq','x_s','y_s','x_trans','y_trans','boundary','title_list','led_box',...
    'time_led','time_nostim','percetage_stimbox','in_left','in_right',...
    'xgap','ygap','box_point','stimbox_point');
end
%%
% colors=[ 0.4660    0.6740    0.1880;
%     0.3010    0.7450    0.9330];
% [x0,y0]=ginput(4)
%%
% if if_roi==1
% plot([roi(1),roi(2)],roi(3)*ones(1,2),'r','linewidth',2);
% plot([roi(1),roi(2)],roi(4)*ones(1,2),'r','linewidth',2);
% plot(roi(1)*ones(1,2),[roi(3),roi(4)],'r','linewidth',2);
% plot(roi(2)*ones(1,2),[roi(3),roi(4)],'r','linewidth',2);
% end
% ix_rep=find(t(2:end)-t(1:end-1)==0);
% t(ix_rep)=t(ix_rep)-0.3;
% t(ix_rep+1)=t(ix_rep+1)+0.3;
% tq=1:max(t);
% xq = interp1(t,x,tq);
% yq=interp1(t,y,tq);
% subplot(132),plot(xq,yq,'k.');
% speed=sqrt((xq(2:end)-xq(1:end-1)).^2+(yq(2:end)-yq(1:end-1)).^2);
% subplot(133),plot(tq(1:end-1)/FPS,speed,'k');title('Speed');
%%
% [yaudio,Fs] = audioread('/Users/Emily/Documents/behavior/20170929/audio/20170929_mice4_1_80db20ktone20s_1trial.m4a');
% taudio=1/Fs:1/Fs:size(yaudio,1)/Fs;
% figure,plot(taudio,yaudio(:,1));
% yaudio_single=yaudio(:,1)';
% locutoff=0;
% hicutoff=10;
% [smoothdata,filtwts] = eegfilt(yaudio_single,Fs,locutoff,hicutoff);
% figure,plot(taudio,smoothdata)