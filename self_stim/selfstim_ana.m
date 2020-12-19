%% var:stim: stim port nosepoke 0-1 sequence read from csv
%%     nostim: nostim port nosepoke timestamp count manually
%% dur read from video
dur=1999;%2402;%2406;%2557;%2234;%2397;
% find(stim,1)
shift=7;%564;%54;%-33;%4;
ori_stim_loc=find(stim);
ori_stim_cumsum=cumsum(stim);
% stim_timestamp=(ori_stim_loc+ori_stim_cumsum(ori_stim_loc-1)-shift)/2;
stim_timestamp=(find(stim)-shift)/2;
stim_histc=histc(stim_timestamp,0:dur);
nostim_histc=histc(nostim_timestamp,0:dur);
stim_cumsum=cumsum(stim_histc);
nostim_cumsum=cumsum(nostim_histc);
figure,plot(0:dur,stim_cumsum,'r');hold on;
plot(0:dur,nostim_cumsum,'k');
xlabel('Time (sec)');
ylabel('Entry Count Accumulation');
legend('Stim','No Stim');
% first
stim_timestamp_first=find(stim(1:end-1)==0 & stim(2:end)==1)+1;
stim_timestamp_first=(stim_timestamp_first-shift)/2;
stim_histc_first=histc(stim_timestamp_first,0:dur);
stim_cumsum_first=cumsum(stim_histc_first);
figure,plot(0:dur,stim_cumsum_first,'r');hold on;
plot(0:dur,nostim_cumsum,'k');
xlabel('Time (sec)');
ylabel('Entry Count Accumulation');
legend('Stim','No Stim');
%% include weak
nostim_histc_includeweak=histc(nostim_timestamp_includeweak,0:dur);
nostim_cumsum_includeweak=cumsum(nostim_histc_includeweak);
figure,plot(0:dur,stim_cumsum,'r');hold on;
plot(0:dur,nostim_cumsum_includeweak,'k');
xlabel('Time (sec)');
ylabel('Entry Count Accumulation');
legend('Stim','No Stim');

figure,plot(0:dur,stim_cumsum_first,'r');hold on;
plot(0:dur,nostim_cumsum_includeweak,'k');
xlabel('Time (sec)');
ylabel('Entry Count Accumulation');
legend('Stim','No Stim');
%% track
% dur=2097;%2406;%307+1288;%2557;%2397;
frate=23.99;%23.97;%29.94;%30;%30.02;%29.98;%29.97;%25.1436;%24.96;
xbound=[30,125,220];
% xbound=[50,125,200];
ybound=90;
frames=size(track,1);

% long_track=track(:,1);
% short_track=track(:,2);
long_track=track(:,2);
short_track=track(:,1);
figure,plot(long_track,short_track);

% stim_zone=find(long_track>xbound(2)  & long_track<xbound(3) & short_track>ybound);
% nostim_zone=find(long_track>xbound(1) & long_track<xbound(2) & short_track>ybound);
nostim_zone=find(long_track>xbound(2)  & long_track<xbound(3) & short_track>ybound);
stim_zone=find(long_track>xbound(1) & long_track<xbound(2) & short_track>ybound);

stim_zone_histc=histc(stim_zone,1:frames);
nostim_zone_histc=histc(nostim_zone,1:frames);
stim_zone_cumsum=cumsum(stim_zone_histc);
nostim_zone_cumsum=cumsum(nostim_zone_histc);

figure,plot(linspace(0,dur,frames),stim_zone_cumsum/frate,'r'),hold on
plot(linspace(0,dur,frames),nostim_zone_cumsum/frate,'k')
xlabel('Time (sec)');
ylabel('Time spending in the port zone (sec)');
legend('Stim','No Stim');

figure,plot(linspace(0,dur,frames),stim_zone_cumsum/frames*100,'r'),hold on
plot(linspace(0,dur,frames),nostim_zone_cumsum/frames*100,'k')
xlabel('Time (sec)');
ylabel('Time percentage spending in the port zone (%)');
legend('Stim','No Stim');

stim_zone_second=length(stim_zone)/frate
nostim_zone_second=length(nostim_zone)/frate
stim_zone_percent=length(stim_zone)/frames
nostim_zone_percent=length(nostim_zone)/frames