clear
clc;
close all;
movfile='..\demo\Lick_demo.mp4';
lick_movname='..\demo\Lick_demo_lick.csv';
%% configurations
inv_lick=1; % 0: brighter for lick ; 1: darker for lick
smooth_lick=1; % smooth
smooth_range=51;

thre_percent = 80; % automatic thresholding
diff_lick = 1; % 1: difference signal; 0: absolute signal
%%
v = VideoReader(movfile);
frate = v.FrameRate;

tmp=xlsread(lick_movname);
lick=tmp(:,2);
%%
if smooth_lick ==1
    lick_smooth = smooth(lick,smooth_range);
    lick_smoothed = lick- lick_smooth;
    lick = lick_smoothed;
end
if inv_lick == 1
    lick = -lick;
end
if diff_lick==1
    lick=diff(lick);
end
%% visualization
t=1:length(lick);
t=t/frate;
plot_lick=zeros(1,length(lick));
tmp=sort(lick);
thre_stat=tmp(fix(thre_percent/100*length(lick)));

figure(1),subplot(311)
plot(t,lick);
hold on
plot([t(1),t(end)],thre_stat*ones(1,2),'g--');
axis tight; box off

subplot(311)
hold on,
plot([t(1),t(end)],thre_stat*ones(1,2),'r')
title('Lick Index');

subplot(312),
h=histogram(lick,100);
hold on
plot(thre_stat*ones(1,2),[0,max(h.Values)],'g--');
axis tight; box off
title('Distribution');
%tmp=find(h.Values>0.5*max(h.Values));
%thre_stat=(h.BinEdges(tmp(end)+1)+h.BinEdges(tmp(end)+2))/2;

a=diff(lick);
b=lick(1:end-1)-lick(2:end);
local_trough=find(a(2:end)>0 & b(1:end-1)>0)+1;
local_peak=find(a(2:end)<0 & b(1:end-1)<0)+1;
troughs=lick(local_trough);
peaks=lick(local_peak);
subplot(313),
htroughs=histogram(troughs,100);
hold on,
hpeaks=histogram(peaks,100);
plot(thre_stat*ones(1,2),[0,max([htroughs.Values,hpeaks.Values])],'r');
title('Peaks vs Troughs');
%% thresholding 
thre= thre_stat;
lick_timestamp= t(local_peak(ismember(local_peak,find(lick>thre))));
%% visualize
figure(1)
subplot(311)
hold on
for i=1:length(lick_timestamp)
    plot(lick_timestamp(i)*ones(1,2),[0,max(lick)],'r')
end
