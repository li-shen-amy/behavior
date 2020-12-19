clc;clear;close all;
 blue_light=[0.9,0.9,1];
 
load('/Users/Emily/Documents/PVT/behavior/jump_20180116_#2.mat');
tmax=8460;
tbin=1200;%60;
time_bin=0:tbin:tmax;
global_shift=0;
 n_jump=histc(jump_timestamp,time_bin);
pdf_njump=cumsum(n_jump);
win=[0,1999;1201,1259;1261,tmax];

figure,set(gcf,'position',[360   473   712   225]);
subplot(121),hold on
patch([win(2,1)/tbin,win(2,2)/tbin,win(2,2)/tbin,win(2,1)/tbin]+global_shift/tbin,[max(n_jump),max(n_jump),0,0],blue_light,'edgecolor','none');
plot(1:length(n_jump),n_jump);
xlabel('Time(min)');
ylabel('Count of Jump');
text(mean(win(2,:))/tbin+global_shift/tbin,max(n_jump),num2str(length(find(jump_timestamp>=win(2,1)& jump_timestamp<=win(2,2)))));
text(mean(win(3,:))/tbin+global_shift/tbin,max(n_jump),num2str(length(find(jump_timestamp>=win(3,1)& jump_timestamp<=win(3,2)))));
subplot(122),hold on
patch([win(2,1)/tbin,win(2,2)/tbin,win(2,2)/tbin,win(2,1)/tbin]+global_shift/tbin,[max(pdf_njump),max(pdf_njump),0,0],blue_light,'edgecolor','none');
plot(1:length(pdf_njump),pdf_njump);
xlabel('Time(min)');
ylabel('PDF');