clc;clear;close all;
fatherfolder='/Users/Emily/Documents/PVT/behavior/';
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

prepath='apvt-zi/2step_zi';%20181012_apvt_vglut2_chr2_1chamber';
movname='20180504_1_1chamber-leftled';
% prepath='apvt-zi/2step_zi/20180502_2chamber';
% movname='2left';

plot_bound=0;
do_tracking=1;
do_test=0;
do_extract_background=0;
do_correction=0;

movfullname=fullfile(fatherfolder,prepath,[movname,'.mov']);
V=VideoReader(movfullname);

if plot_bound==1
    video= readFrame(V);
    figure,image(video);
    [x0,y0]=ginput(4)
else
    if do_tracking==1
        %          tmax=1200;
        dur=V.Duration;
        sample_int=0.1;
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
        end
        
        h = ones(5,5) / 25;
        clear ia ib
        if shift>0
            while V.CurrentTime<=shift
                readFrame(V);
            end
        end
        %         count=1;
       
        if do_extract_background==1
            background=extract_background(movfullname);
        end
        for count=1:tcount
            V=VideoReader(movfullname,'CurrentTime',shift+count*sample_int);
            video=readFrame(V);
            %
            %         while V.CurrentTime<tmax%dur
            %             while V.CurrentTime<sample_int*count+shift && V.CurrentTime<dur
            %                 video=readFrame(V);
            %             end
            video=video( ybound(1):ybound(2),xbound(1):xbound(2),:);
            
            if do_extract_background==1
                video=255-background+video;
                bw=im2bw(video,0.5);
            else
                bw=im2bw(video,0.2);
            end
            
            %     video=readFrame(V);
            %             bw=im2bw(video,0.1);
            
            if strfind(movname,'2#_R1_2')
                bw(1:75,1:95)=1;
            end
            
            
            
            %             bw=bw(ybound(1):ybound(2),xbound(1):xbound(2));
            bw = imfilter(bw,h);
            
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
                imagesc(video(ybound(1):ybound(2),xbound(1):xbound(2),:));
                hold on,plot(ia(count),ib(count),'r^');
                hold off
                pause
            end
%             count=count+1;
        end
        distance=sqrt((ib(2:end)-ib(1:end-1)).^2+...
            (ia(2:end)-ia(1:end-1)).^2);
    else
        load(strrep(movfullname,'.mov',''));
        video=readFrame(V);
    end
    %%
    blue_light=[0.9,0.9,1];
    nwin=size(win,1);
    t=shift:sample_int:tmax;
    clear seg
    for i=1:nwin
        seg{i}=find(t>win(i,1) & t<win(i,2));
    end
    
    width=xbound(2)-xbound(1);
    height=ybound(2)-ybound(1);
    shade_color=0.9*ones(1,3);
    %     blue_light=[0.9,0.9,1];
    close all;
    figure(1),
    set(gcf,'position',[ 5   282   843   423]);
    for i=1:nwin
        subplot(2,nwin,i),
        hold on
%         imagesc(video(ybound(1):ybound(2),xbound(1):xbound(2),:));
        imagesc(video);
        plot(ia(seg{i}),ib(seg{i}),'k');
        axis off;
        title(title_list{i});
        
        subplot(2,nwin,i+nwin),
        hold on
        patch([0,width,width,0],[0,0,height,height],shade_color);
        plot(ia(seg{i}),ib(seg{i}),'k');
        box off
        axis off
        title(title_list{i});
        seg_tmp=setdiff(seg{i},length(ia));
        if ~isempty(seg_tmp)
            max_speed(i)=max(distance(seg_tmp));
            mean_speed(i)=mean(distance(seg_tmp));
        else
            max_speed(i)=NaN;
            mean_speed(i)=NaN;
        end
    end
    
    max_speed_global=max(max_speed);
    %%
    for i=1:round(tmax-shift)-1
        t_sec=i+shift-1;
    distance_sec(i)=sum(distance(find(t>t_sec & t<=t_sec+1)));
    end
    figure(2),
    set(gcf,'position',[ 227   478   910   220]);
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
        led_box=[win(2,1),max_speed_global;win(2,2),max_speed_global;
            win(2,2),0;win(2,1),0];
        patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
    end
%     plot(t(1:end-2),distance,'k','linewidth',1);box off;
        plot(shift+1:tmax-1,distance_sec,'k','linewidth',1);box off;
   ylabel('Speed');xlabel('Time');
    xlim([shift,tmax]);
%     ylim([0,max_speed_global]);
    
    %% jump analysis
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
    
    figure,set(gcf,'position',[360   473   712   225]);
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
    %%
    if do_tracking==1
        saveas(1,strrep(movfullname,'.mov','_track.fig'));
        saveas(2,strrep(movfullname,'.mov','_speed.fig'));
        saveas(3,strrep(movfullname,'.mov','_jump.fig'));
        save(strrep(movfullname,'.mov','_track'),...
            'xbound','ybound','shift','ia','ib','distance',...
            'max_speed','mean_speed','seg','t','jump_timestamp_ori',...
            'jump_timestamp','n_jump','pdf_njump','win','global_shift');
    end
    speed_act=distance_sec/(ybound(2)-ybound(1))*29.6;%cm
end
%%

if strfind(movname,'20180504_1_1chamber-leftled') 
 
    figure,
    spon_off_section=1;
    subplot(131),hold on
    plot(ia(seg{spon_off_section}),ib(seg{spon_off_section}),'k');
    dur_spon_off=length(seg{spon_off_section})/10;
      distance_spon_off=distance(seg{spon_off_section});
   distance_sec_spon_off=distance_sec(win(spon_off_section,1)+1:win(spon_off_section,2));
    
   title(['(spon)LED OFF,dur=',num2str(dur_spon_off)]);
     
    off_section=[3,5,7,9,11];
    on_section=[2,4,6,8,10];
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
     ia(3222)=110;
     ia(7407)=45;
     ia(7408)=45;
      ia(7409)=48;
     ia(8974)=28;
     ib(8974)=191;
     ia(8975)=31;
     ib(8975)=191;
       ia(8976)=31;
     ib(8976)=191;
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
%%
end
