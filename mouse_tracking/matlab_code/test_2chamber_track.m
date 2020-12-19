clc;clear;close all;
fatherfolder='/Users/Emily/Documents/PVT/behavior/';
% fatherfolder='/Users/Emily/Documents/LS/';
% fatherfolder='/Users/Emily/Documents/conditioning/';

% prepath='20171216_CHR2xVGLUT2';
% movname='20171216_Non_2chamber_top';
% movname='20171216_Red_2chamber_top';

% prepath='20171215_CHR2xVGLUT2';
% movname='20171215_Non_2chamber_trimmed';
% movname='20171215_Red_2chamber';

% prepath='20171219_CHR2xVGLUT2';
% movname='20171219_Non_2chamber';
% movname='20171219_Red_2chamber';
% stim_box='right';

% prepath='20180110_apvt_vglut2_chr2_2chamber';
% movname='20180110_1#_None_1';
% movname='20180110_1#_None_2';
% movname='20180110_3#_L1';
% movname='20180110_apvt_vglut2xchr2_2#_red';
% stim_box='left';

% movname='20180110_2#_R1';
% movname='20180110_apvt_vglut2xchr2_1#_none';
% stim_box='right';

% prepath='apvt-zi/20180209';
% % movname='vglut2_chr2_apvt_zi_female_L1R1_2#_2chamber1';
% % movname='vglut2_chr2_apvt_zi_female_R1_3#_2chamber';
% movname='vglut2_chr2_apvt_zi_male_R1_2#_2chamber';
% stim_box='left';

% prepath='20180321_2chamber';
% movname='2_single';
% stim_box='right';

% prepath='apvt-zi/2step_zi';
% % movname='20180409_1_2chamber_rightled';
% % stim_box='left';
%
% % movname='20180409_2_2chamber-leftled';
% movname='20180409_2_2chamber-rightled';
% stim_box='right';


% prepath='safezone';
% movname='WT_20180418_5ktone_2chamber_d2';
% stim_box='left';

% prepath='apvt-zi/2step_zi/20180502_2chamber';
% % movname='1right';
% % movname='1left';
% % stim_box='right';
% movname='2left';
% stim_box='left';

prepath='apvt-zi/2step_zi/';
movname='20180507_2chamber';
stim_box='right';


% movname='vglut2_chr2_apvt_zi_female_none_1#_2chamber';
% movname='vglut2_chr2_apvt_zi_male_L2R1_1#_2chamber';
% stim_box='right';

plot_bound=0;
do_tracking=1;
do_test=0;
do_correction=0;

movfullname=fullfile(fatherfolder,prepath,[movname,'.mov']);
V=VideoReader(movfullname);

if plot_bound==1
    video= readFrame(V);
    figure,image(video);
    [x0,y0]=ginput(5)
else
    if do_tracking==1
        %          tmax=1200;
        dur=V.Duration;
        sample_int=0.1;
        tmax=fix(dur)/sample_int;
        shift=0;
        if strfind(movname,'20171216_Non_2chamber_top');
            ybound=[95,288];
            xbound=[160,455];
            x_stimbound=143.6060;
            shift=0;
        elseif  strfind(movname,'20171216_Red_2chamber_top');
            ybound=[59,280];
            xbound=[140,499];
            x_stimbound=318.6567-xbound(1);
            shift=3;
        elseif ~isempty(strfind(movname,'20171215_Non_2chamber'))
            ybound=[101,242];
            xbound=[202,418];
            x_stimbound= 311.2834-xbound(1);
            shift=0;
        elseif  ~isempty(strfind(movname,'20171215_Red_2chamber'))
            ybound=[101,243];
            xbound=[202,418];
            x_stimbound= 311.2834-xbound(1);
            shift=14;
        elseif strfind(movname,'20171219')
            ybound=[75,293];
            xbound=[172,514];
            x_stimbound= 348.1498-xbound(1);
            shift=0;
            tmax=1200;
        elseif strfind(movname,'20180110_1#_None_1')
            ybound=[22,328];
            xbound=[85,545];
            x_stimbound=308.3341-xbound(1);
            shift=180;
            tmax=462;
        elseif strfind(movname,'20180110_1#_None_2')
            ybound=[20,328];
            xbound=[84,546];
            x_stimbound= 311.2834-xbound(1);
            shift=0;%89
            tmax=1201;
        elseif strfind(movname,'20180110_2#_R1')
            ybound=[17,328];
            xbound=[75,545];
            x_stimbound= 311.2834-xbound(1);
            shift=0;%44
            tmax=1222;
        elseif strfind(movname,'20180110_3#_L1')
            ybound=[39,343];
            xbound=[76,545];
            x_stimbound=  300.9608-xbound(1);
            shift=5;%139;
            tmax=1395;
        elseif strfind(movname,'20180110_apvt_vglut2xchr2_1#_none')
            ybound=[40,344];
            xbound=[76,540];
            x_stimbound=  303.9101-xbound(1);
            shift=0;%139;
            tmax=tmax-shift;
        elseif strfind(movname,'20180110_apvt_vglut2xchr2_2#_red')
            ybound=[35,339];
            xbound=[81,542];
            x_stimbound= 308.3341-xbound(1);
            shift=0;%139;
            %             tmax=1200;%tmax-shift;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_female_L1R1_2#_2chamber');
            ybound=[76,323];
            xbound=[141,514];
            x_stimbound= 327.5046-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_female_none_1#_2chamber');
            ybound=[51,283];
            xbound=[128,508];
            x_stimbound= 330.4539-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_female_R1_3#_2chamber');
            ybound=[74,298];
            xbound=[135,492];
            x_stimbound=  312.7581-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_male_L2R1_1#_2chamber');
            ybound=[35,267];
            xbound=[182,549];
            x_stimbound=  367.3203-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_male_R1_2#_2chamber');
            ybound=[72,299];
            xbound=[134,487];
            x_stimbound=314.2327-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'1_pencil');
            ybound=[15,312];
            xbound=[82,564];
            x_stimbound=315.7074-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'2_single');
            ybound=[31,329];
            xbound=[73,551];
            x_stimbound= 292.1129-xbound(1);
            shift=0;%139;  2_single
        elseif strfind(movname,'20180409_1_2chamber_leftled')
            ybound=[14,327];
            xbound=[90,573];
            x_stimbound= 334.8779-xbound(1);
            shift=0;%139;  2_single
        elseif strfind(movname,'20180409_1_2chamber_rightled')
            ybound=[29,339];
            xbound=[81,568];
            x_stimbound= 330.4539-xbound(1);
            shift=0;%139;  2_single
        elseif strfind(movname,'20180409_2_2chamber-leftled')
            ybound=[12,327];
            xbound=[87,567];
            x_stimbound= 328.9793-xbound(1);
            shift=0;%139;  2_single
        elseif strfind(movname,'20180409_2_2chamber-rightled')
            ybound=[25,340];
            xbound=[85,568];
            x_stimbound= 330.4539-xbound(1);
            shift=0;%139;  2_single
        elseif strfind(movname,'WT_20180418_5ktone_2chamber_d2')
            ybound=[17,320];
            xbound=[90,565];
            x_stimbound=317.1820-xbound(1);
            shift=0;%139;  2_single
        elseif strcmp(movname,'1right') || strcmp(movname,'1left') || strcmp(movname,'2left')
            ybound=[37,226];
            xbound=[205,489];
            x_stimbound=349.6244-xbound(1);
            shift=0;%139;  2_single
        elseif strcmp(movname,'20180507_2chamber') 
            ybound=[82,304];
            xbound=[165,517];
            x_stimbound=334.8779-xbound(1);
            shift=0;%139;  2_single
        end
        
        h = ones(5,5) / 25;
        %           h = ones(10,10) / 25;
        clear ia ib
        if shift>0
            while V.CurrentTime<=shift
                readFrame(V);
            end
        end
%         count=1;
        
        % FPS=V.FrameRate;
        for count=1:tmax
         V=VideoReader(movfullname,'CurrentTime',shift+count*sample_int);
    
%         while V.CurrentTime<dur %&& count<=41
%             while V.CurrentTime<sample_int*count+shift && V.CurrentTime<dur
                video=readFrame(V);
%             end
           
            video=video( ybound(1):ybound(2),xbound(1):xbound(2),:);
            %     video=readFrame(V);
            %             bw=im2bw(video,0.1);
            bw=im2bw(video,0.2);
            
            %             bw=bw(ybound(1):ybound(2),xbound(1):xbound(2));
            bw = imfilter(bw,h);
            
            a=sum(bw,1);
            b=sum(bw,2);
            a=reshape(a,1,length(a));
            b=reshape(b,1,length(b));
            
            %             a=min(bw');
            %             b=min(bw);
            
              min_a=min(a(3:end-2));
               min_b=min(b(3:end-2));
            max_a=max(a(3:end-2));
            max_b=max(b(3:end-2));
            
            ia_low=find(a<(max_a-0.3*(max_a-min_a)));
            ib_low=find(b<(max_b-0.3*(max_b-min_b)));
            
            int_ia=ia_low(2:end)-ia_low(1:end-1);
            int_ib=ib_low(2:end)-ib_low(1:end-1);
            
            ia_start=find(int_ia>2);
            ib_start=find(int_ib>2);
            if ~isempty(ia_start)
                ia_start=ia_start+1;
                ia_end=[ia_start-1,length(int_ia)+1];
                ia_start=[1,ia_start];                
            else                
                ia_end=length(ia_low);
                ia_start=1;                
%                 [min_a,ia(count)]=min(a(3:end-2));                
%                 ia(count)=ia(count)+2;    
            end
             clear bw_a
                for i=1:length(ia_start)
                    bw_a(i)=ia_end(i)-ia_start(i);
                end
                [~,bwsel_a]=max(bw_a);
                ia(count)=round([ia_low(ia_start(bwsel_a))+ia_low(ia_end(bwsel_a))]/2);
                
         
            if ~isempty(ib_start)
                ib_start=ib_start+1;
                ib_end=[ib_start-1,length(ib_low)];
                ib_start=[1,ib_start];
            else
                       ib_start=1;
                ib_end=length(ib_low);
%                 [min_b,ib(count)]=min(b(3:end-2));
%                 ib(count)=ib(count)+2;
            end
             clear bw_b
                for i=1:length(ib_start)
                    bw_b(i)=ib_end(i)-ib_start(i);
                end
                [~,bwsel_b]=max(bw_b);
                ib(count)=round([ib_low(ib_start(bwsel_b))+ib_low(ib_end(bwsel_b))]/2);
                
         
            if do_test
                imagesc(video);
                hold on,plot(ia(count),ib(count),'r^');
                hold off
                pause
            end
%             count=count+1;
        end
        if strcmp(stim_box,'right')
            in_led=find(ia(1:tmax)>x_stimbound);
            dur_nostim=length(find(ia(1:tmax)<x_stimbound));
        else
            in_led=find(ia(1:tmax)<x_stimbound);
            dur_nostim=length(find(ia(1:tmax)>x_stimbound));
        end
        dur_stim=length(in_led);
        
        stim_percent=dur_stim/(dur_nostim+dur_stim)%68.32
        distance=sqrt((ib(2:end)-ib(1:end-1)).^2+...
            (ia(2:end)-ia(1:end-1)).^2);
    else
        load(strrep(movfullname,'.mov',''));
        video=readFrame(V);
    end
    %%
    
    width=xbound(2)-xbound(1);
    height=ybound(2)-ybound(1);
    shade_color=0.9*ones(1,3);
    blue_light=[0.9,0.9,1];
    t=shift:tmax;
    
    close all;
    figure(1),
    subplot(211),
    hold on
    imagesc(video);
    plot(ia,ib,'k');
    axis off;
    
    subplot(212),
    hold on
    patch([0,width,width,0],[0,0,height,height],shade_color);
    if strcmp(stim_box,'right')
        patch([x_stimbound,width,width,x_stimbound],[0,0,height,height],blue_light,'edgecolor','none');
    else
        patch([0,x_stimbound,x_stimbound,0],[0,0,height,height],blue_light,'edgecolor','none');
        
    end
    plot(ia,ib,'k');
    title(['LED ON: ',num2str(stim_percent*100,4),'%']);
    box off
    axis off
    
    led_box=[];
    max_speed=max(distance);
    mean_speed=mean(distance);
    figure(2),set(gcf,'position',[ 227   478   910   220]);
    hold on
    for i=1:length(in_led)
        led_box=[in_led(i)-0.5,max_speed;in_led(i)+0.5,max_speed;
            in_led(i)+0.5,0;in_led(i)-0.5,0];
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
    end
    %     plot(t(1:end-2),distance,'k','linewidth',1);box off;
    if length(t)>length(distance)
        plot(t(1:length(distance)),distance,'k','linewidth',1);box off;
    else
        plot(t,distance(1:length(t)),'k','linewidth',1);box off;
        
    end
    ylabel('Speed');xlabel('Time');
    xlim([shift,tmax]);
    ylim([0,max_speed]);
    %%
    if do_tracking==1
        saveas(1,strrep(movfullname,'.mov','_track.fig'));
        saveas(2,strrep(movfullname,'.mov','_speed.fig'));
        save(strrep(movfullname,'.mov','_track'),...
            'xbound','ybound','shift','ia','ib','distance',...
            'x_stimbound','dur_stim','dur_nostim','stim_percent','t',...
            'in_led','stim_box');
    end

%% correction
if do_correction==1
outlier=find(distance>50);
for i=1:length(outlier)
    for j=[-1,1]
    V=VideoReader(movfullname,'CurrentTime',(outlier(i)+j)/10);
    video= readFrame(V);
    video=video(ybound(1):ybound(2),xbound(1):xbound(2),:);
    figure(10),subplot(221),image(video);
    title([num2str(i),'-',num2str(outlier(i)+j)]);
    
    bw=im2bw(video,0.2);
      bw = imfilter(bw,h);
      
    a=sum(bw,1);
    b=sum(bw,2);
     a=reshape(a,1,length(a));
            b=reshape(b,1,length(b));
            
            %             a=min(bw');
            %             b=min(bw);
            
              min_a=min(a(3:end-2));
               min_b=min(b(3:end-2));
            max_a=max(a(3:end-2));
            max_b=max(b(3:end-2));
            
            ia_low=find(a<(max_a-0.3*(max_a-min_a)));
            ib_low=find(b<(max_b-0.3*(max_b-min_b)));
            
            int_ia=ia_low(2:end)-ia_low(1:end-1);
            int_ib=ib_low(2:end)-ib_low(1:end-1);
            
            ia_start=find(int_ia>5);
            ib_start=find(int_ib>5);
            if ~isempty(ia_start)
                ia_start=ia_start+1;
                ia_end=[ia_start-1,length(int_ia)+1];
                ia_start=[1,ia_start];                
            else                
                ia_end=length(ia_low);
                ia_start=1;                
%                 [min_a,ia(count)]=min(a(3:end-2));                
%                 ia(count)=ia(count)+2;    
            end
             clear bw_a
                for i=1:length(ia_start)
                    bw_a(i)=ia_end(i)-ia_start(i);
                end
                [~,bwsel_a]=max(bw_a);
                ia_tmp=round([ia_low(ia_start(bwsel_a))+ia_low(ia_end(bwsel_a))]/2);
                
         
            if ~isempty(ib_start)
                ib_start=ib_start+1;
                ib_end=[ib_start-1,length(ib_low)];
                ib_start=[1,ib_start];
            else
                       ib_start=1;
                ib_end=length(ib_low);
%                 [min_b,ib(count)]=min(b(3:end-2));
%                 ib(count)=ib(count)+2;
            end
             clear bw_b
                for i=1:length(ib_start)
                    bw_b(i)=ib_end(i)-ib_start(i);
                end
                [~,bwsel_b]=max(bw_b);
                ib_tmp=round([ib_low(ib_start(bwsel_b))+ib_low(ib_end(bwsel_b))]/2);

    ia_old=ia(outlier(i))
    ib_old=ib(outlier(i))
    
    subplot(222),imshow(bw);  hold on
    plot(ia(outlier(i)),ib(outlier(i)),'ro');
     plot(ia_tmp,ib_tmp,'bo');
    %   [x,y] = ginput(n)
    subplot(223),plot(a);
    subplot(224),plot(b);
    pause
    end
end
end
end
%%
% ib(outlier(2))=168;%41
% ib(outlier(4))=152;%196
% ib(outlier(5))=244;%121
% ib(outlier(7))=141;%246
% ib(outlier(9))=;%249
% ib(outlier(11))=153;%255
% ib(outlier(13))=171;%587
% ib(outlier(15))=;%785
% ib(outlier(17))=31;%787
% ib(outlier(19))=39;%793
% ib(outlier(21))=157;%1027
% ib(outlier(23))=166;%1042
% ib(outlier(25))=163;%1044
% ib(outlier(27))=177;%1093
% ib(outlier(29))=121;%1166
% ib(outlier(31))=150;%1430
% ib(outlier(34))=32;%1507
% ib(outlier(36))=117;%1532
% ib(outlier(37))=109;%1920
% ib(outlier(38))=135;%1923
% ib(outlier(40))=144;%1940