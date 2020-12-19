clc;clear;close all;
if strcmp(computer,'MACI64')
    fatherfolder='/Users/Emily/Documents/PVT/behavior/';
elseif  strcmp(computer,'PCWIN64')
    fatherfolder='G:\PVT\behavior\';
end
% prepath='20181012_apvt_vglut2_chr2_1chamber';

% % movname='2#_top';
% % movname='2#_R1_2';
% % movname='POA_Male_WT_R2_jump_test';
% movname='apvt_zi_20180205_male1';

% fatherfolder='/Users/Emily/Documents/conditioning/';
% % prepath='safezone';
% % movname='WT_20180412_5ktonex7_d2';
% prepath='safezone/nphr_ms';
% movname='20180425-d2-rightnoise-ledon';

% prepath=fullfile('apvt-zi','2step_zi');
% % movname='20180504_1_1chamber-leftled';
% movname='20180508_1chamber';
% % prepath='apvt-zi/2step_zi/20180502_2chamber';
% % movname='2left';

% prepath=fullfile('apvt-zi','2step_zi','20180513_social_male');
% % movname='20180504_1_1chamber-leftled';
% movname='exploration2';

prepath=fullfile('apvt-zi','20180517');
movname='l1_1chamber';

plot_bound=0;
do_tracking=1;
do_test=0;
do_extract_background=0;%1;
do_correction=0;
ana_jump=0;

sample_int=0.5;
% maxspeed=20;
speed_a=10;
speed_b=5;
maxspeed=sample_int*speed_a+speed_b;
pre_weight=0.2:0.2:1;
background_pre=5;
center_bound_factor=0.2;
bound_act=19;
% bound_act=29.6;
h = ones(5,5) / 25;
sel_ch=1;

blue_light=[0.9,0.9,1];
shade_color=0.9*ones(1,3);

movfullname=fullfile(fatherfolder,prepath,[movname,'.mov']);
V=VideoReader(movfullname);
debug_count=[];

if plot_bound==1
    video= readFrame(V);
    figure,image(video);
    [x0,y0]=ginput(4)
else
    if do_tracking==1
        %          tmax=1200;
        dur=V.Duration;
        tmax=fix(dur);
        tcount=tmax/sample_int;
        seg_default=180;
        shift=0;
        global_shift=0;
        win=[0,seg_default;seg_default,2*seg_default;2*seg_default,3*seg_default];
        % win=[0,V.Duration]*FPS;
        title_list={['Baseline(',num2str(seg_default),'s)'],...
            ['LED ON(',num2str(seg_default),'s)'],...
            ['After Stim(',num2str(seg_default),'s)']};
        
        if strfind(movname,'2#_top')
            ybound=[49,313];
            xbound=[184,452];
            shift=0;
            tmax=975;
            win=[0,314;316,659;661,975];
            % win=[0,V.Duration]*FPS;
            title_list={['Baseline(',num2str(win(1,2)-win(1,1)),'s)'],...
                ['LED ON(',num2str(win(2,2)-win(2,1)),'s)'],...
                ['After Stim(',num2str(win(3,2)-win(3,1)),'s)']};
        elseif strfind(movname,'2#_R1_2')
            xbound=[34,555];
            ybound=[2,354];
            shift=126;%0;
            tmax=4108;
            global_shift=242;
            win=[0,66;68,411;413,4108];
            % win=[0,V.Duration]*FPS;
            title_list={['Baseline(',num2str(win(1,2)-win(1,1)),'s)'],...
                ['LED ON(',num2str(win(2,2)-win(2,1)),'s)'],...
                ['After Stim(',num2str(win(3,2)-win(3,1)),'s)']};
        elseif strfind(movname,'apvt_zi_20180205_male1')
            xbound=[184,446];
            ybound=[1,261];
        elseif strfind(movname,'POA_Male_WT_R2_jump_test')
            xbound=[29,608];
            ybound=[1,355];
            %             shift=0;
            %             tmax=fix(dur);
            %             global_shift=0;
            win=[0,304;306,605;606,fix(dur)];
            %             win=[0,dur]*FPS;
            title_list={['Baseline(',num2str(win(1,2)-win(1,1)),'s)'],...
                ['LED ON(',num2str(win(2,2)-win(2,1)),'s)'],...
                ['After Stim(',num2str(win(3,2)-win(3,1)),'s)']};
            
        elseif strfind(movname,'WT_20180412_5ktonex7_d2')
            xbound=[62,468];
            ybound=[19,358];
            %             shift=0;
            %             tmax=fix(dur);
            %             global_shift=0;
            win=[0,fix(dur)];
            %             win=[0,dur]*FPS;
            title_list={'Training(5k Tone)'};
        elseif strfind(movname,'20180425-d2-rightnoise-ledon')
            ybound=[25,348];
            xbound=[153,527];
            %             shift=0;
            %             tmax=fix(dur);
            %             global_shift=0;
            win=[0,fix(dur)];
            %             win=[0,dur]*FPS;
            title_list={'Test(Noise)'};
        elseif strfind(movname,'20180504_1_1chamber-leftled')
            ybound=[54,285];
            xbound=[205,436];
            win=[0,336;337,398;
                399,458;459,520;
                521,585;586,647;
                648,707;708,773;
                774,833;834,895;
                896,fix(dur)];
            title_list={'Off','On','Off','On','Off','On',...
                'Off','On','Off','On','Off'};
            %         elseif strcmp(movname,'2left')
            %             ybound=[36,222];
            %             xbound=[203,485];
        elseif strfind(movname,'20180508_1chamber')
            ybound=[60,287];
            xbound=[192,412];
            win=[0,301;302,702;
                703,fix(dur)];
            title_list={'Off','On','Off'};
        elseif strcmp(movname,'exploration')
            ybound=[72,236];
            xbound=[223,397];
            win=[0,59;60,181;182,313;314,388;
                401,451;452,fix(dur)];
            title_list={'Off','On','Off','On','On','Off'};
        elseif strcmp(movname,'exploration2')
            ybound=[72,236];
            xbound=[223,397];
            win=[0,59;60,180;181,fix(dur)];
            title_list={'Off','On','Off'};
        elseif strcmp(movname,'l1_1chamber')
            ybound=[100,325];
            xbound=[197,438];
            win=[0,60;61,180;181,326;327,331;334,450;
                451,569;570,690;691,810;811,931;
                932,1057;1058,1181;1182,fix(dur)];
            title_list={'Off','On','Off','On','On','Off',...
                'On','Off','On','Off','On','Off'};
        end
        width=xbound(2)-xbound(1);
        height=ybound(2)-ybound(1);
        distance_factor=bound_act/mean([width,height]);
        
        start_point=[];
        clear ia ib
        %         if shift>0
        %             while V.CurrentTime<=shift
        %                 readFrame(V);
        %             end
        %         end
        %         count=1;
        
        
        for count=1:tcount
            if shift+count*sample_int<dur
                %             V=VideoReader(movfullname,'CurrentTime',shift+count*sample_int);
                while V.CurrentTime<shift+count*sample_int
                    readFrame(V);
                end
                video=readFrame(V);
                %
                %         while V.CurrentTime<tmax%dur
                %             while V.CurrentTime<sample_int*count+shift && V.CurrentTime<dur
                %                 video=readFrame(V);
                %             end
                if ~isempty(sel_ch)
                    video=video( ybound(1):ybound(2),xbound(1):xbound(2),sel_ch);
                else
                    video=video( ybound(1):ybound(2),xbound(1):xbound(2),:);
                end
                %             if do_extract_background==1
                %                 video=255-background+video;
                %                 bw=im2bw(video,0.5);
                %             else
                %                 bw=im2bw(video,0.2);
                %             end
                
                if do_extract_background==1  if shift+count*sample_int-background_pre>0%shift+count*sample_int-5/V.FrameRate>0
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
                
                %     video=readFrame(V);
                %             bw=im2bw(video,0.1);
                %             bw=im2bw(video,0.2);
                video = imfilter(video,h);
                %                 bw=im2bw(video,0.6);
                
                aa=reshape(video,1,size(video,1)*size(video,2)*size(video,3));
                aa=double(aa);
                aa_sort=sort(aa);
                thre=aa_sort(round(0.04*length(aa)));
                bw=mean(double(video),3);
                bw(bw>thre)=255;
                %                 bw=im2bw(video,thre);
                bw = imfilter(bw,h);
                
                if strfind(movname,'2#_R1_2')
                    bw(1:75,1:95)=1;
                end
                
                bw =bw(5:end-4,5:end-4);
                
                a=sum(bw,1);
                b=sum(bw,2);
                
                %             [~,ia(count)]=min(a(3:end-3));
                %             [~,ib(count)]=min(b(3:end-3));
                %             ia(count)=ia(count)+2;
                %             ib(count)=ib(count)+2;
                %             if ia(count)<4 || ib(count)<4
                %
                %                  bw=im2bw(video,0.2);
                %           if strfind(movname,'2#_R1_2')
                %             bw(1:75,1:95)=1;
                %           end
                %             bw=bw(ybound(1):ybound(2),xbound(1):xbound(2));
                %             bw = imfilter(bw,h);
                %             a=sum(bw,1);
                %             b=sum(bw,2);
                %
                %             [~,ia(count)]=min(a(3:end-3));
                %             [~,ib(count)]=min(b(3:end-3));
                %             ia(count)=ia(count)+2;
                %             ib(count)=ib(count)+2;
                %
                %             end
                
                
                
                a=reshape(a,1,length(a));
                b=reshape(b,1,length(b));
                
                
                %                 a=a(5:end-4);
                %                 b=b(5:end-4);
                
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
                %                 while start<0.9 && (isempty(ia_low) || isempty(ib_low))
                while start<255-25 && (isempty(ia_low) || isempty(ib_low))
                    %                     start=start+0.1;
                    %                     bw=im2bw(video,start);
                    start=start+25;
                    bw=mean(double(video),3);
                    bw(bw>thre)=255;
                    
                    bw = imfilter(bw,h);
                    bw =bw(5:end-4,5:end-4);
                    a=sum(bw,1);
                    b=sum(bw,2);
                    a=reshape(a,1,length(a));
                    b=reshape(b,1,length(b));
                    
                    %                     a=a(5:end-4);
                    %                     b=b(5:end-4);
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
                ia(count)=round([ia_low(ia_start(bwsel_a))+ia_low(ia_end(bwsel_a))]/2)+4;
                
                
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
                ib(count)=round([ib_low(ib_start(bwsel_b))+ib_low(ib_end(bwsel_b))]/2)+4;
                
                if count>1 && sqrt((ia(count)-ia(count-1))^2+(ib(count)-ib(count-1))^2)>maxspeed/distance_factor
                    debug_count=[debug_count,count];
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
                    ia(count)=round((ia_start1+ia_end1)/2)+4;
                    
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
                    ib(count)=round((ib_start1+ib_end1)/2)+4;
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
            else
                tcount=tcount-1;
            end
        end
        distance=sqrt((ib(2:end)-ib(1:end-1)).^2+...
            (ia(2:end)-ia(1:end-1)).^2)*distance_factor;
    else
        load(strrep(movfullname,'.mov',''));
        video=readFrame(V);
    end
    %% speed ana
    nwin=size(win,1);
    t=shift+sample_int:sample_int:tmax;
    clear distance_sec
    
    for i=1:round(tmax-shift)-1
        t_sec=i+shift-1;
        distance_sec(i)=sum(distance(t>t_sec & t<=t_sec+1));
    end
    clear seg distance_seg max_speed mean_speed
    clear distance_sec_seg max_speed_sec mean_speed_sec
    for i=1:nwin
        seg{i}=find(t>win(i,1) & t<win(i,2));
        seg_tmp=setdiff(seg{i},length(ia));
        if ~isempty(seg_tmp)
            distance_seg{i}=distance(seg_tmp);
            max_speed(i)=max(   distance_seg{i});
            mean_speed(i)=mean(   distance_seg{i});
        else
            distance_seg{i}=NaN;
            max_speed(i)=NaN;
            mean_speed(i)=NaN;
        end
        distance_sec_seg{i}=distance_sec(win(i,1)-shift+1:min([length(distance_sec),win(i,2)-shift]));
        max_speed_sec(i)=max( distance_sec_seg{i});
        mean_speed_sec(i)=mean( distance_sec_seg{i});
    end
    max_speed_global=max(max_speed);
    max_speed_sec_global=max(max_speed_sec);
    %% central area 20%-80%
    center_boundx=[center_bound_factor*width,width*(1-center_bound_factor)];
    center_boundy=[center_bound_factor*height,height*(1-center_bound_factor)];
    
    in_center=find(ia> center_boundx(1) & ia <center_boundx(2)...
        & ib>center_boundy(1) & ib<center_boundy(2));
    out_center=setdiff(1:length(ia),in_center);
    clear in_center_seg out_center_seg percent_incenter
    for i=1:nwin
        in_center_seg{i}=in_center(ismember(in_center,seg{i}));
        out_center_seg{i}=out_center(ismember(out_center,seg{i}));
        percent_incenter(i)=length( in_center_seg{i})/(length( in_center_seg{i})+length( out_center_seg{i}));
    end
    %% plot trace
    close all;
    figure(1), 
    set(gcf,'position',[ 5   282   843   423]);
    for i=1:nwin
        %         subplot(2,nwin,i),
        %         hold on
        %         %         imagesc(video(ybound(1):ybound(2),xbound(1):xbound(2),:));
        %         imagesc(video);
        %         plot(ia(seg{i}),ib(seg{i}),'k');
        %         axis off;
        %         title(title_list{i});
        
        subplot(2,nwin,i)%+nwin),
        hold on
        patch([0,width,width,0],[0,0,height,height],shade_color);
        patch([center_boundx,center_boundx([2,1])],...
            [center_boundy(1),center_boundy(1),center_boundy(2),center_boundy(2)],blue_light,'edgecolor','none');
        plot(ia(seg{i}),ib(seg{i}),'k');
        box off
        axis off
        title([title_list{i},',center=',num2str(percent_incenter(i)*100,'%.1f'),'%']);
    end
    
    %     figure(2),
    %     set(gcf,'position',[ 227   478   910   220]);
    subplot(2,1,2),
    hold on
    if  strfind(movname,'20180504_1_1chamber-leftled')
        on_section=[2,4,6,8,10];
        led_box=[];
        for i=1:length(on_section)
            led_box=[win(on_section(i),1),max_speed_global;win(on_section(i),2),max_speed_global;
                win(on_section(i),2),0;win(on_section(i),1),0];
            patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
        end
    elseif size(win,1)>1
        on_section=[];
        for i=1:length(title_list)
            if strcmp(title_list{i},'On')
                on_section=[on_section,i];
                led_box=[win(i,1),max_speed_global;win(i,2),max_speed_global;
                    win(i,2),0;win(i,1),0];
                patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
                
            end
        end
    end
    %     plot(t(1:end-2),distance,'k','linewidth',1);box off;
    plot(shift+1:tmax-1,distance_sec,'k','linewidth',1);box off;
    ylabel('Speed (cm/s)');xlabel('Time (s)');
    xlim([shift,tmax]);
    for i=1:nwin
        text(mean(win(i,:),2),max_speed_sec_global*1.1,num2str(mean_speed_sec(i),'%.1f'),'horizontalalignment','center');
    end
    %     ylim([0,max_speed_global]);
    %         speed_act=distance_sec/(ybound(2)-ybound(1))*29.6;%cm
    %% jump analysis
    if ana_jump==1
        threshold=200;
        a=find(ib<threshold);
        jump_timestamp_ori=a'*sample_int+shift;
        jump_timestamp=jump_timestamp_ori(setdiff(1:length(jump_timestamp_ori),find((jump_timestamp_ori(2:end)-jump_timestamp_ori(1:end-1))<0.5)+1));
        jump_timestamp_disp=[fix(jump_timestamp/60),jump_timestamp-fix(jump_timestamp/60)*60];
        jump_timestamp_disp=round(jump_timestamp_disp);
        % jump_timestamp_disp=unique(jump_timestamp_disp,'rows');
        time_bin=0:60:tmax;
        n_jump=histc(jump_timestamp+global_shift,time_bin);
        pdf_njump=cumsum(n_jump);
        
        figure(3),set(gcf,'position',[360   473   712   225]);
        subplot(121),hold on
        if size(win,1)>1
            patch([win(2,1)/60,win(2,2)/60,win(2,2)/60,win(2,1)/60]+global_shift/60,[max(n_jump),max(n_jump),0,0],blue_light,'edgecolor','none');
        end
        plot(1:length(n_jump),n_jump);
        xlabel('Time(min)');
        ylabel('Count of Jump');
        text(mean(win(2,:))/60+global_shift/60,max(n_jump),num2str(length(find(jump_timestamp>=win(2,1)& jump_timestamp<=win(2,2)))));
        text(mean(win(3,:))/60+global_shift/60,max(n_jump),num2str(length(find(jump_timestamp>=win(3,1)& jump_timestamp<=win(3,2)))));
        subplot(122),hold on
        if size(win,1)>1
            patch([win(2,1)/60,win(2,2)/60,win(2,2)/60,win(2,1)/60]+global_shift/60,[max(pdf_njump),max(pdf_njump),0,0],blue_light,'edgecolor','none');
        end
        plot(1:length(pdf_njump),pdf_njump);
        xlabel('Time(min)');
        ylabel('PDF');
    end
    %%
    if do_tracking==1
        saveas(1,strrep(movfullname,'.mov',['_trace_',num2str(sample_int),'.fig']));
        %         saveas(2,strrep(movfullname,'.mov','_speed.fig'));
        if ana_jump==1
            saveas(3,strrep(movfullname,'.mov',['_jump_',num2str(sample_int),'.fig']));
            save(strrep(movfullname,'.mov',['_track_',num2str(sample_int),'.mat']),...
                'xbound','ybound','shift','sample_int','ia','ib','distance',...
                'max_speed','mean_speed','seg','t','jump_timestamp_ori',...
                'jump_timestamp','n_jump','pdf_njump','win','global_shift',...
                'distance_seg','distance_sec','max_speed_sec','mean_speed_sec',...
                'distance_sec_seg','in_center_seg','out_center_seg','percent_incenter');
        else
            save(strrep(movfullname,'.mov',['_trace_',num2str(sample_int),'.mat']),...
                'xbound','ybound','shift','sample_int','ia','ib','distance',...
                'max_speed','mean_speed','seg','t','win','global_shift',...
                'distance_seg','distance_sec','max_speed_sec','mean_speed_sec',...
                'distance_sec_seg','in_center_seg','out_center_seg','percent_incenter');
        end
    end
end
%%

if strfind(movname,'20180504_1_1chamber-leftled')
    spon_off_section=1;
    off_section=[3,5,7,9,11];
    on_section=[2,4,6,8,10];
    
    figure,
    subplot(131),hold on
    plot(ia(seg{spon_off_section}),ib(seg{spon_off_section}),'k');
    dur_spon_off=length(seg{spon_off_section})/10;
    distance_spon_off=distance(seg{spon_off_section});
    distance_sec_spon_off=distance_sec(win(spon_off_section,1)+1:win(spon_off_section,2));
    
    title(['(spon)LED OFF,dur=',num2str(dur_spon_off)]);
    
    subplot(132),hold on
    dur_off=0;
    distance_off=[];
    distance_sec_off=[];
    for i=1:length(off_section)
        plot(ia(seg{off_section(i)}),ib(seg{off_section(i)}),'k');
        dur_off=dur_off+length(seg{off_section(i)})/10;
        distance_off=[distance_off,distance(min([seg{off_section(i)},length(distance)]))];
        distance_sec_off=[distance_sec_off,distance_sec(win(off_section(i),1):min([win(off_section(i),2),length(distance_sec)]))];
    end
    title(['LED OFF,dur=',num2str(dur_off)]);
    subplot(133),hold on
    dur_on=0;
    distance_on=[];
    distance_sec_on=[];
    for i=1:length(on_section)
        plot(ia(seg{on_section(i)}),ib(seg{on_section(i)}),'k');
        dur_on=dur_on+length(seg{on_section(i)})/10;
        distance_on=[distance_on,distance(seg{on_section(i)})];
        distance_sec_on=[distance_sec_on,distance_sec(win(on_section(i),1):win(on_section(i),2))];
    end
    title(['LED ON,dur=',num2str(dur_on)]);
    %%
    figure,plot(spon_off_section,mean_speed(spon_off_section),'ko');
    hold on
    plot(on_section,mean_speed(on_section),'ro');
    plot(off_section,mean_speed(off_section),'bo');
    plot(1:length(seg),mean_speed,'k');
    box off
    set(gca,'xticklabel',title_list);
    ylabel('Mean Speed');
    xlim([0,length(seg)+1]);
    %      mean(distance_spon_off)
    %      mean(distance_on)
    %      mean(distance_off)
    speed_act_factor=29.6/(ybound(2)-ybound(1));% or 29.6/(xbound(2)-xbound(1));
    mean(distance_sec_spon_off)*speed_act_factor
    mean_on=mean(distance_sec_on)*speed_act_factor
    mean_off=mean(distance_sec_off)*speed_act_factor
    se_on=std(distance_sec_on)/sqrt(length(distance_sec_on));
    se_off=mean(distance_sec_off)/sqrt(length(distance_sec_off));
    
    %      [p,h]=ranksum(distance_on,distance_off)
    [p,h]=ranksum(distance_sec_on,distance_sec_off)%p= 9.7403e-18
    %  [p,h]=ranksum(distance_sec_on,distance_sec_spon_off)%p=  5.0819e-07
    %  [p,h]=ranksum(distance_sec_off,distance_sec_spon_off)%p=  2.3482e-36
    % [p,h]=ranksum(distance_sec_on,[distance_sec_spon_off,distance_sec_off])%p=  2.3482e-36
    %%
    figure,hold on
    bar([1,2],[mean_on,mean_off],'facecolor','w');
    errorbar([1,2],[mean_on,mean_off],[se_on,se_off],'k','linestyle','none');
    set(gca,'xtick',[1,2],'xticklabel',{'ON','Off'});
    ylabel('Speed(cm/s)');
    xlim([0,3]);
    box off;
    %% central area
    center_bound=[51,180];
    in_center=find(ia> center_bound(1) & ia <center_bound(2)...
        & ib>center_bound(1) & ib<center_bound(2));
    out_center=setdiff(1:length(ia),in_center);
    
    spon_off_in_center=in_center(ismember(in_center,seg{spon_off_section}));
    spon_off_out_center=out_center(ismember(out_center,seg{spon_off_section}));
    percent_incenter_sponoff=length(spon_off_in_center)/(length(spon_off_in_center)+length(spon_off_out_center));%11.88
    
    on_in_center=[];
    on_out_center=[];
    for i=1:length(on_section)
        on_in_center=[on_in_center,in_center(ismember(in_center,seg{on_section(i)}))];
        on_out_center=[on_out_center,out_center(ismember(out_center,seg{on_section(i)}))];
    end
    percent_incenter_on=length(on_in_center)/(length(on_in_center)+length(on_out_center));%15.98
    
    off_in_center=[];
    off_out_center=[];
    for i=1:length(off_section)
        off_in_center=[off_in_center,in_center(ismember(in_center,seg{off_section(i)}))];
        off_out_center=[off_out_center,out_center(ismember(out_center,seg{off_section(i)}))];
    end
    percent_incenter_off=length(off_in_center)/(length(off_in_center)+length(off_out_center));%24.48
    
    %% correction
    %     ia(3222)=110;
    %     ia(7407)=45;
    %     ia(7408)=45;
    %     ia(7409)=48;
    %     ia(8974)=28;
    %     ib(8974)=191;
    %     ia(8975)=31;
    %     ib(8975)=191;
    %     ia(8976)=31;
    %     ib(8976)=191;
end
%% correction
if do_correction==1
    outlier=find(distance>50);
    for oi=1:length(outlier)
        for j=[-1,0,1]
            count=outlier(oi)+j;
            V=VideoReader(movfullname,'CurrentTime',shift+count*sample_int);
            video= readFrame(V);
            video=video(ybound(1):ybound(2),xbound(1):xbound(2),:);
            %     close(1),
            figure(1),subplot(221),image(video);
            title([num2str(oi),'-',num2str(count)]);
            
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
            
            ia_old=ia(count)
            ib_old=ib(count)
            
            subplot(222),imshow(bw);  hold on
            plot(ia_old,ib_old,'ro');
            plot(ia_tmp,ib_tmp,'bo');
            %   [x,y] = ginput(n)
            hold off
            subplot(223),plot(a);
            subplot(224),plot(b);
            
            pause
        end
    end
end
