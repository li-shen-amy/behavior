clc;clear;close all;
if strcmp(computer,'MACI64')
%         fatherfolder='/Users/Emily/Documents/PVT/behavior/';
    fatherfolder='/Users/Emily/Documents/LS/';
elseif  strcmp(computer,'PCWIN64')
        fatherfolder='G:\PVT\behavior\';
%     fatherfolder='G:\LS\';
end

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
% movname='1_pencil';
% % movname='2_single';
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

% prepath=fullfile('apvt-zi','2step_zi');
% movname='20180507_2chamber';
% stim_box='right';

% prepath=fullfile('apvt-zi','2step_zi','20180513_social_male');
% % movname='context_cond_d1';
% % movname='context_cond_d2';
% movname='new_context_d2';
% stim_box='right';

% movname='vglut2_chr2_apvt_zi_female_none_1#_2chamber';
% movname='vglut2_chr2_apvt_zi_male_L2R1_1#_2chamber';
% stim_box='right';


% prepath=fullfile('apvt-zi','20180517');
% movname='l1_2chamber';
% stim_box='left';

% prepath='20180508_2chamber';
% movname='L1_female';
% movname='R1_female';
% stim_box='left';
% movname='none_female';
% movname='none_male_rightbroken';
% movname='red_male';
% stim_box='right';

% prepath='20180425_female_2chamber';
% % movname='20180425_l1_2chamber';
% % movname='20180425_none_2chamber';
% movname='20180425_none_2chamber_continuesled';
% stim_box='right';
% % movname='20180425_rcut_2chamber';
% % stim_box='left';

prepath='20180321_2chamber';
movname='2_single';
stim_box='right';

plot_bound=0;
do_tracking=1;
do_test=0;
do_extract_background=0;%0;%1;
do_correction=0;
correct_high_speed=0;
check_area=1;

sample_int=0.5;
% maxspeed=20;
speed_a=40;%10;
speed_b=5;
maxspeed=sample_int*speed_a+speed_b;
pre_weight=0.2:0.2:1;
background_pre=5;
center_bound_factor=0.2;
bound_act=29.6;
h = ones(5,5) / 25;
% h = ones(10,10) / 100;
sel_ch=1;%[];

blue_light=[0.9,0.9,1];
shade_color=0.9*ones(1,3);

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
        tmax=fix(dur);
        shift=0;
        if strfind(movname,'20171216_Non_2chamber_top')
            ybound=[95,288];
            xbound=[160,455];
            x_stimbound=143.6060;
            shift=0;
        elseif  strfind(movname,'20171216_Red_2chamber_top')
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
        elseif strfind(movname,'vglut2_chr2_apvt_zi_female_L1R1_2#_2chamber')
            ybound=[76,323];
            xbound=[141,514];
            x_stimbound= 327.5046-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_female_none_1#_2chamber')
            ybound=[51,283];
            xbound=[128,508];
            x_stimbound= 330.4539-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_female_R1_3#_2chamber')
            ybound=[74,298];
            xbound=[135,492];
            x_stimbound=  312.7581-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_male_L2R1_1#_2chamber')
            ybound=[35,267];
            xbound=[182,549];
            x_stimbound=  367.3203-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'vglut2_chr2_apvt_zi_male_R1_2#_2chamber')
            ybound=[72,299];
            xbound=[134,487];
            x_stimbound=314.2327-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'1_pencil')
            ybound=[15,312];
            xbound=[82,564];
            x_stimbound=315.7074-xbound(1);
            shift=0;%139;
        elseif strfind(movname,'2_single')
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
        elseif strcmp(movname,'context_cond_d1')
            ybound=[38,252];
            xbound=[175,453];
            x_stimbound=324.1866-xbound(1);
            shift=6;
        elseif strcmp(movname,'context_cond_d2')
            ybound=[38,252];
            xbound=[175,453];
            x_stimbound=324.1866-xbound(1);
            shift=9;
        elseif strcmp(movname,'new_context_d2')
            ybound=[34,245];
            xbound=[139,418];
            x_stimbound=290.2696-xbound(1);
            shift=0;
        elseif strcmp(movname,'l1_2chamber')
             ybound=[80,305];
            xbound=[169,520];
            x_stimbound=343.7258-xbound(1);
            shift=0;
              elseif strcmp(movname,'L1_female')
                    ybound=[43,273];
            xbound=[161,513];
            x_stimbound=323.0806-xbound(1);
            shift=0;
             elseif strcmp(movname,'none_female')
             ybound=[39,274];
            xbound=[176,538];
            x_stimbound=348.1498-xbound(1);
            shift=0;%2
             elseif strcmp(movname,'none_male_rightbroken')
              ybound=[39,274];
            xbound=[176,538];
            x_stimbound=348.1498-xbound(1);
            shift=9;  
             elseif strcmp(movname,'R1_female')
              ybound=[47,276];
            xbound=[169,522];
            x_stimbound=340.7765-xbound(1);
            shift=0; 
            elseif strcmp(movname,'red_male')
              ybound=[38,272];
            xbound=[168,531];
            x_stimbound=345.2005-xbound(1);
            shift=14; 
             elseif strcmp(movname,'20180425_l1_2chamber')
              ybound=[78,354];
            xbound=[125,585];
            x_stimbound=358.4724-xbound(1);
            shift=0; % was 14s
             elseif strcmp(movname,'20180425_none_2chamber')
              ybound=[72,347];
            xbound=[168,542];
            x_stimbound=358.4724-xbound(1);
            shift=0;  % was 14s
             elseif strcmp(movname,'20180425_rcut_2chamber')
              ybound=[88,344];
            xbound=[165,547];
            x_stimbound=359.9470-xbound(1);
            shift=0; 
            elseif strcmp(movname,'20180425_none_2chamber_continuesled')
              ybound=[79,341];
            xbound=[160,543];
            x_stimbound=358.4724-xbound(1);
            shift=10; 
             elseif strcmp(movname,'2_single')
              ybound=[34,325];
            xbound=[93,542];
            x_stimbound=289.1636-xbound(1);
            shift=0; 
        end
        tcount=tmax/sample_int;
        width=xbound(2)-xbound(1);
        height=ybound(2)-ybound(1);
        distance_factor=bound_act/min([width,height]);
        
        %        if  do_extract_background==1
        %            V=VideoReader(movfullname);
        %             background=readFrame(V);
        %             background=background( ybound(1):ybound(2),xbound(1):xbound(2),:);
        %        end
        
        start_point=[];
        
        clear ia ib
        %         if shift>0
        %             while V.CurrentTime<=shift
        %                 readFrame(V);
        %             end
        %         end
        %         count=1;
        
        % FPS=V.FrameRate;
        V=VideoReader(movfullname);
        for count=1:tcount
            if shift+count*sample_int<dur
                %             V=VideoReader(movfullname,'CurrentTime',shift+count*sample_int);
                while V.CurrentTime<shift+count*sample_int
                    readFrame(V);
                end
                %         while V.CurrentTime<dur %&& count<=41
                %             while V.CurrentTime<sample_int*count+shift && V.CurrentTime<dur
                %            if  V.CurrentTime<dur
                video=readFrame(V);
                %             end
                
                if ~isempty(sel_ch)
                    video=video( ybound(1):ybound(2),xbound(1):xbound(2),sel_ch);
                else
                    video=video( ybound(1):ybound(2),xbound(1):xbound(2),:);
                end
                
                if do_extract_background==1
                    if shift+count*sample_int-background_pre>0%shift+count*sample_int-5/V.FrameRate>0
                        %             background=extract_background(movfullname);
                        
                        V_pre=VideoReader(movfullname,'CurrentTime',shift+count*sample_int-background_pre);
                        video_pre=pre_weight(1)*double(readFrame(V_pre));
                        for i=2:5
                            while(V_pre.CurrentTime<shift+count*sample_int-background_pre+i-1)
                                readFrame(V_pre);
                            end
                            %                    V_pre=VideoReader(movfullname,'CurrentTime',shift+count*sample_int-background_pre+i-1);
                            video_pre=video_pre+pre_weight(i)*double(readFrame(V_pre));
                        end
                    else
                        V_pre=VideoReader(movfullname,'CurrentTime',shift+count*sample_int+1);
                        video_pre=pre_weight(1)*double(readFrame(V_pre));
                        for i=2:background_pre
                            while(V_pre.CurrentTime<shift+count*sample_int+i)
                                readFrame(V_pre);
                            end
                            %                    V_pre=VideoReader(movfullname,'CurrentTime',shift+count*sample_int-background_pre+i-1);
                            video_pre=video_pre+pre_weight(i)*double(readFrame(V_pre));
                        end
                    end
                    
                    video_pre=video_pre/sum(pre_weight);
                    if ~isempty(sel_ch)
                        video=255-(uint8(video_pre(ybound(1):ybound(2),xbound(1):xbound(2),sel_ch))-video);
                    else
                        video=255-(uint8(video_pre(ybound(1):ybound(2),xbound(1):xbound(2),:))-video);
                    end
                    %                 background=readFrame(V_pre);
                    %                 background=background(ybound(1):ybound(2),xbound(1):xbound(2),:);
                    %                 video=255-(background-video);
                end
                
                %             bw=im2bw(video,0.5);
                video = imfilter(video,h);
                
                aa=reshape(video,1,size(video,1)*size(video,2)*size(video,3));
                aa=double(aa);
                aa_sort=sort(aa);
                thre=aa_sort(round(0.04*length(aa)));
                bw=mean(double(video),3);
                bw(bw>thre)=255;
                %                 bw=im2bw(video,thre);
                bw = imfilter(bw,h);
                bw =bw(5:end-4,5:end-4);
                a=sum(bw,1);
                b=sum(bw,2);
                a=reshape(a,1,length(a));
                b=reshape(b,1,length(b));
                
                %             a=a(5:end-4);
                %             b=b(5:end-4);
                %             a=min(bw');
                %             b=min(bw);
                
                %             min_a=min(a(3:end-2));
                %             min_b=min(b(3:end-2));
                %             max_a=max(a(3:end-2));
                %             max_b=max(b(3:end-2));
                
                min_a=min(a);
                min_b=min(b);
                max_a=max(a);
                max_b=max(b);
                ia_low=find(a<(max_a-0.3*(max_a-min_a)));
                ib_low=find(b<(max_b-0.3*(max_b-min_b)));
                
                start=thre;
                while start<255-25 && (isempty(ia_low) || isempty(ib_low))
                    %                     start=start+0.1;
                    %                     bw=im2bw(video,start);
                    start=start+25;
                    bw=mean(double(video),3);
                    bw(bw>start)=255;
                    
                    bw = imfilter(bw,h);
                    a=sum(bw,1);
                    b=sum(bw,2);
                    a=reshape(a,1,length(a));
                    b=reshape(b,1,length(b));
                    
                    a=a(5:end-4);
                    b=b(5:end-4);
                    %             a=min(bw');
                    %             b=min(bw);
                    
                    %             min_a=min(a(3:end-2));
                    %             min_b=min(b(3:end-2));
                    %             max_a=max(a(3:end-2));
                    %             max_b=max(b(3:end-2));
                    
                    min_a=min(a);
                    min_b=min(b);
                    max_a=max(a);
                    max_b=max(b);
                    ia_low=find(a<(max_a-0.3*(max_a-min_a)));
                    ib_low=find(b<(max_b-0.3*(max_b-min_b)));
                end
                
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
                if check_area==1
                    area=mean(mean(bw(max([1,ib(count)-10]):min([size(bw,1),ib(count)+10]),max([1,ia(count)-10]):min([size(bw,2),ia(count)+10]))));
                    if area>=start && count>1
                        if do_test
                            imshow(video);%axis xy;
                            hold on,
                            plot(ia(count),ib(count),'r^');
                            title('pre');
                            %                  plot(ib(count),ia(count),'r^');
                            hold off
                            pause
                        end
                        
                        
                        
                        ia_start1=find(a(start_point(1):-1:1)>max_a-0.3*(max_a-min_a),1);
                        ia_end1=find(a(start_point(1):end)>max_a-0.3*(max_a-min_a),1);
                        if isempty(ia_start1)
                            ia_start1=1;
                        end
                        if isempty(ia_end1)
                            ia_end1=length(a);
                        else
                            ia_end1=start_point(1)+ia_end1-1;
                        end
                        ia_start1=start_point(1)-ia_start1+1;
                        %       bw_a1=ia_end1-ia_start1;
                        ia(count)=round((ia_start1+ia_end1)/2);
                        
                        ib_start1=find(b(start_point(2):-1:1)>max_b-0.3*(max_b-min_b),1);
                        ib_end1=find(b(start_point(2):end)>max_b-0.3*(max_b-min_b),1);
                        if isempty(ib_start1)
                            ib_start1=1;
                        end
                        if isempty(ib_end1)
                            ib_end1=length(b);
                        else
                            ib_end1=start_point(2)+ib_end1-1;
                        end
                        ib_start1=start_point(2)-ib_start1+1;
                        
                        ib(count)=round((ib_start1+ib_end1)/2);
                        
                        
                    end
                    start_point=[ia(count),ib(count)];
                    
                    if do_test
                        %                 imagesc(video(ybound(1):ybound(2),xbound(1):xbound(2),:));
                        imshow(video);%axis xy;
                        hold on,
                        plot(ia(count),ib(count),'r^');
                        title('Post');
                        %                  plot(ib(count),ia(count),'r^');
                        hold off
                        pause
                    end
                end
                
                if correct_high_speed==1 && count>1 && sqrt((ia(count)-ia(count-1))^2+(ib(count)-ib(count-1))^2)>maxspeed/distance_factor
                    
                    ia_start1=find(a(start_point(1):-1:1)>max_a-0.3*(max_a-min_a),1);
                    ia_end1=find(a(start_point(1):end)>max_a-0.3*(max_a-min_a),1);
                    if isempty(ia_start1)
                        ia_start1=1;
                    end
                    if isempty(ia_end1)
                        ia_end1=length(a);
                    else
                        ia_end1=start_point(1)+ia_end1-1;
                    end
                    ia_start1=start_point(1)-ia_start1+1;
                    %       bw_a1=ia_end1-ia_start1;
                    ia(count)=round((ia_start1+ia_end1)/2);
                    
                    ib_start1=find(b(start_point(2):-1:1)>max_b-0.3*(max_b-min_b),1);
                    ib_end1=find(b(start_point(2):end)>max_b-0.3*(max_b-min_b),1);
                    if isempty(ib_start1)
                        ib_start1=1;
                    end
                    if isempty(ib_end1)
                        ib_end1=length(b);
                    else
                        ib_end1=start_point(2)+ib_end1-1;
                    end
                    ib_start1=start_point(2)-ib_start1+1;
                    
                    ib(count)=round((ib_start1+ib_end1)/2);
                    
                    
                end
                start_point=[ia(count),ib(count)];
                
                if do_test
                    %                 imagesc(video(ybound(1):ybound(2),xbound(1):xbound(2),:));
                    imshow(video);%axis xy;
                    hold on,
                    plot(ia(count),ib(count),'r^');
                    %                  plot(ib(count),ia(count),'r^');
                    hold off
                    pause
                end
                %             count=count+1;
            else
                tcount=tcount-1;
            end
        end
        ia=ia+4;
        ib=ib+4;
        if strcmp(stim_box,'right')
            on_led=find(ia>x_stimbound);
            off_led=find(ia<x_stimbound);
        else
            on_led=find(ia<x_stimbound);
            off_led=find(ia>x_stimbound);
        end
        dur_nostim=length(off_led);
        dur_stim=length(on_led);
        stim_percent=dur_stim/(dur_nostim+dur_stim)%68.32
        
        distance=sqrt((ib(2:end)-ib(1:end-1)).^2+...
            (ia(2:end)-ia(1:end-1)).^2)*distance_factor;
        
    else
        load(strrep(movfullname,'.mov',''));
        video=readFrame(V);
    end
    %% speed ana
    distance_on=distance(setdiff(on_led,tcount));
    distance_off=distance(setdiff(off_led,tcount));
    max_speed_on=max(distance_on);
    mean_speed_on=mean(distance_on);
    max_speed_off=max(distance_off);
    mean_speed_off=mean(distance_off);
    max_speed_global=max(distance);
    mean_speed_global=mean(distance);
    %% speed sec
    
    clear distance_sec
    ia_sec(1)=ia(1);
    ib_sec(1)=ib(1);
    for i=1:round(tmax-shift)-1
        %         t_sec=i+shift-1;
        t_sec=i-1;
        %         distance_sec(i)=sum(distance(t>t_sec & t<=t_sec+1));
        ia_sec(i+1)=ia(fix((t_sec+1)/sample_int));% downsample
        ib_sec(i+1)=ib(fix((t_sec+1)/sample_int));% downsample
    end
    distance_sec=sqrt((ib_sec(2:end)-ib_sec(1:end-1)).^2+...
        (ia_sec(2:end)-ia_sec(1:end-1)).^2)*distance_factor;
    
    
    if strcmp(stim_box,'right')
        on_led_sec=find(ia_sec>x_stimbound);
        off_led_sec=find(ia_sec<x_stimbound);
    else
        on_led_sec=find(ia_sec<x_stimbound);
        off_led_sec=find(ia_sec>x_stimbound);
    end
    distance_on_sec=distance_sec(setdiff(on_led_sec,length(ia_sec)));
    distance_off_sec=distance_sec(setdiff(off_led_sec,length(ia_sec)));
    max_speed_on_sec=max(distance_on_sec);
    mean_speed_on_sec=mean(distance_on_sec);
    max_speed_off_sec=max(distance_off_sec);
    mean_speed_off_sec=mean(distance_off_sec);
    
    max_speed_sec_global=max(distance_sec);
    mean_speed_sec_global=mean(distance_sec);
    %% central area 20%-80%
    if strcmp(stim_box,'right')
        width_on=xbound(2)-x_stimbound;
        center_boundx_on=[x_stimbound+center_bound_factor*width_on,x_stimbound+(1-center_bound_factor)*width_on];
        width_off=x_stimbound;
        center_boundx_off=[center_bound_factor*width_off,(1-center_bound_factor)*width_off];
    else
        width_on=x_stimbound;
        center_boundx_on=[center_bound_factor*width_on,(1-center_bound_factor)*width_on];
        width_off=xbound(2)-x_stimbound;
        center_boundx_off=[x_stimbound+center_bound_factor*width_off,x_stimbound+(1-center_bound_factor)*width_off];
    end
    
    center_boundy=[center_bound_factor*height,height*(1-center_bound_factor)];
    
    in_center_on=find(ia> center_boundx_on(1) & ia <center_boundx_on(2)...
        & ib>center_boundy(1) & ib<center_boundy(2));
    out_center_on=setdiff(1:length(ia),in_center_on);
    
    in_center_off=find(ia> center_boundx_off(1) & ia <center_boundx_off(2)...
        & ib>center_boundy(1) & ib<center_boundy(2));
    out_center_off=setdiff(1:length(ia),in_center_off);
    
    
    percent_incenter_on=length( in_center_on)/(length(in_center_on)+length(out_center_on));
    percent_incenter_off=length( in_center_off)/(length(in_center_off)+length(out_center_off));
    
    %%
    %     t=shift+sample_int:sample_int:tmax;
    t_sec0=shift+1:tmax-1;
    
    close all;
    figure(1),
    set(gcf,'position',[ 5   282   843   423]);
    subplot(211)
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
    subplot(212)
    hold on
    for i=1:length(on_led_sec)
        led_box=[on_led_sec(i)-0.5,max_speed_sec_global;on_led_sec(i)+0.5,max_speed_sec_global;
            on_led_sec(i)+0.5,0;on_led_sec(i)-0.5,0];
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
    end
    plot(t_sec0,distance_sec,'k','linewidth',1);box off;
    %     if length(t)>length(distance_sec)
    %         plot(t(1:length(distance_sec)),distance_sec,'k','linewidth',1);box off;
    %     else
    %         plot(t,distance_sec(1:length(t)),'k','linewidth',1);box off;
    %
    %     end
    ylabel('Speed (cm/s)');xlabel('Time(s)');
    xlim([shift,tmax]);
    ylim([0,max_speed_sec_global]);
    %%
    if do_tracking==1
        saveas(1,strrep(movfullname,'.mov',['_trace_',num2str(sample_int),'.fig']));
        %         saveas(2,strrep(movfullname,'.mov','_speed.fig'));
        save(strrep(movfullname,'.mov',['_trace_',num2str(sample_int),'.mat']),...
            'xbound','ybound','x_stimbound','shift','tmax','sample_int','stim_box',...
            'ia','ib','on_led','off_led','dur_stim','dur_nostim','stim_percent',...
            'distance','distance_on','distance_off','max_speed_on','mean_speed_on',...
            'max_speed_off','mean_speed_off','ia_sec','ib_sec','on_led_sec','off_led_sec',...
            'distance_sec','distance_on_sec','distance_off_sec','max_speed_on_sec',...
            'mean_speed_on_sec','max_speed_off_sec','mean_speed_off_sec',...
            'in_center_on','out_center_on','in_center_off','out_center_off',...
            'percent_incenter_on','percent_incenter_off');
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