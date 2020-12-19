clc;clear;close all;
fatherfolder='/Users/Emily/Documents/PVT/behavior/';
prepath='20181012_apvt_vglut2_chr2_1chamber';
% movname='2#_top';
movname='2#_R1_2';
movfullname=fullfile(fatherfolder,prepath,[movname,'.mov']);
load(strrep(movfullname,'.mov','_track'));
%             'xbound','ybound','shift','ia','ib','distance',...
%             'max_speed','mean_speed','seg','t','jump_timestamp_ori',...
%             'jump_timestamp','n_jump','pdf_njump','win','global_shift');
  blue_light=[0.9,0.9,1];
  tmax=max(t);
 time_bin=0:tmax;
 n_jump=histc(jump_timestamp+global_shift,time_bin);
pdf_njump=cumsum(n_jump);

figure,set(gcf,'position',[360   473   712   225]);
subplot(121),hold on
patch([win(2,1)/60,win(2,2)/60,win(2,2)/60,win(2,1)/60]+global_shift/60,[max(n_jump),max(n_jump),0,0],blue_light,'edgecolor','none');
plot(1:length(n_jump),n_jump);
xlabel('Time(min)');
ylabel('Count of Jump');
text(mean(win(2,:))/60+global_shift/60,max(n_jump),num2str(length(find(jump_timestamp>=win(2,1)& jump_timestamp<=win(2,2)))));
text(mean(win(3,:))/60+global_shift/60,max(n_jump),num2str(length(find(jump_timestamp>=win(3,1)& jump_timestamp<=win(3,2)))));
subplot(122),hold on
patch([win(2,1)/60,win(2,2)/60,win(2,2)/60,win(2,1)/60]+global_shift/60,[max(pdf_njump),max(pdf_njump),0,0],blue_light,'edgecolor','none');
plot(1:length(pdf_njump),pdf_njump);
xlabel('Time(min)');
ylabel('PDF');