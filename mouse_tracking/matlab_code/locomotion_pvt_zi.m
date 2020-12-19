load('/Users/Emily/Documents/PVT/behavior/apvt-zi/2step_zi/20180504_1_1chamber-leftled_track.mat');
on_trace_a=[];
on_trace_b=[];
off_trace_a=[];
off_trace_b=[];
t=t+(t(2)-t(1))/2;
t=t(1:length(ia));
for i=2:2:10
    on_trace_a=[on_trace_a,ia(t>=win(i,1)&t<=win(i,2))];
    on_trace_b=[on_trace_b,ib(t>=win(i,1)&t<=win(i,2))];
    off_trace_a=[off_trace_a,ia(t>=win(i+1,1)&t<=win(i+1,2))];
    off_trace_b=[off_trace_b,ib(t>=win(i+1,1)&t<=win(i+1,2))];
end
figure,subplot(121)
plot(on_trace_a,on_trace_b);
title('LED ON');
subplot(122),
plot(off_trace_a,off_trace_b);
title('LED OFF');
%% interp2
clear count_xy_on count_xy_off
ixy=0:10:249;
for i=1:length(ixy)
    ix=ixy(i);
    for  j=1:length(ixy)
        iy=ixy(j);
        count_xy_on(i,j)=length(find(on_trace_a>=ix & on_trace_a<=ix+1 & ...
            on_trace_b>=iy & on_trace_b<=iy+1 ));
        count_xy_off(i,j)=length(find(off_trace_a>=ix & off_trace_a<=ix+1 & ...
            off_trace_b>=iy & off_trace_b<=iy+1 ));
    end
end
ixy_q=0:250;
[X,Y]=meshgrid(ixy,ixy);
[Xq,Yq]=meshgrid(ixy_q,ixy_q);
q_count_xy_on=interp2(X,Y,count_xy_on,Xq,Yq);%,'spine');
q_count_xy_off=interp2(X,Y,count_xy_off,Xq,Yq);%,'spine');
figure,subplot(121)
imagesc(ixy_q,ixy_q,q_count_xy_on);
title('LED ON');
subplot(122)
imagesc(ixy_q,ixy_q,q_count_xy_off);
title('LED OFF');
%%
clear distance_sec
for i=1:fix(length(distance)/10)
    distance_sec(i)=sum(distance((i-1)*10+1:i*10));
end

figure,
clear distance_sel
subplot(221),hold on
patch1=patch([0,60,60,0],[20,20,120,120],[0.9,0.9,1],'edgecolor','none');
subplot(222),hold on
patch1=patch([0,60,60,0],[100,100,600,600],[0.9,0.9,1],'edgecolor','none');

for i=1:5
    %     subplot(5,1,i)
    subplot(221),hold on
    it=find(t>=win(i*2-1,2)-60 &t<=win(i*2+1,1)+60);
    distance_sel(i,1:1830)=distance(it(1:1830));
    plot(t(it)-t(it(find(t(it)>=win(i*2,1),1))),distance(it)+20*i,'k');
    subplot(222),hold on
    tmp=distance_sec(win(i*2-1,2)-60:win(i*2+1,1)+60);
    distance_sec_sel(i,1:184)=tmp(1:184);
    plot(-61:122,distance_sec_sel(i,:)+100*i,'k');
end
subplot(221)
axis([-70,130,0,140]);
title('resolution=0.1s, Smoothed');
ylabel('Trial#');
set(gca,'ytick',20:20:100,'yticklabel',1:5);
subplot(222)
axis([-70,130,0,700]);
title('resolution=1s');
ylabel('Trial#');
set(gca,'ytick',100:100:500,'yticklabel',1:5);
% axis([-70,130,0,140]);
%
% figure,subplot(121),imagesc(distance_sel);
% subplot(122),imagesc(distance_sec_sel);
%
mean_distance_sel=mean(distance_sel);
sm_mean_distance_sel=smooth(mean_distance_sel,50);
mean_distance_sec_sel=mean(distance_sec_sel);

% figure,
subplot(223),hold on
patch1=patch([-64,664,664,-64],[0,0,5,5],[0.9,0.9,1],'edgecolor','none');
plot(-564:1164,sm_mean_distance_sel(51:end-51),'k');box off
title('resolution=0.1s, Smoothed');
subplot(224),hold on
patch1=patch([-5,65,65,-5],[0,0,60,60],[0.9,0.9,1],'edgecolor','none');
plot(-61:122,mean_distance_sec_sel,'k');box off
title('resolution=1s');