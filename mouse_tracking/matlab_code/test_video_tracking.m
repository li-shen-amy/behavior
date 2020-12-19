clc;clear;close all;
dbstop if error
selet_ui=1;
if_roi=0;
roi=[180,430,80,330];
ext='.mov';
if selet_ui==1
    prepath='/Users/Emily/Documents/behavior/TWp';
    [movname,xpn,~]=uigetfile(ext,'Select a video file',prepath);
    tmp=fileparts(xpn);
    [~,movname]=fileparts(movname);
    date=tmp(strfind(tmp,prepath)+length(prepath):end);
else
    date='20171010';
    movname='group1_1_TWx5';
    xpn=fullfile(prepath,date);
end
movfullname=fullfile(xpn,[movname,ext]);
V=VideoReader(movfullname);
video=readFrame(V);%,'native');
FPS=V.FrameRate;
%%
if if_roi==1
    track_post='_roi_track.csv';
else
     track_post='_track.csv';
end
M=csvread(fullfile(prepath,[date,'_',movname,track_post]));
t=M(:,1);
x=M(:,2);
y=M(:,3);
if if_roi==1
    x=x+roi(3);
    y=y+roi(1);
end
figure,set(gcf,'position',[ 5         481        1273         190]);
subplot(131),
image(video);axis xy;
hold on,
plot(x,y,'w.');
if if_roi==1
plot([roi(1),roi(2)],roi(3)*ones(1,2),'r','linewidth',2);
plot([roi(1),roi(2)],roi(4)*ones(1,2),'r','linewidth',2);
plot(roi(1)*ones(1,2),[roi(3),roi(4)],'r','linewidth',2);
plot(roi(2)*ones(1,2),[roi(3),roi(4)],'r','linewidth',2);
end
ix_rep=find(t(2:end)-t(1:end-1)==0);
t(ix_rep)=t(ix_rep)-0.3;
t(ix_rep+1)=t(ix_rep+1)+0.3;
tq=1:max(t);
xq = interp1(t,x,tq);
yq=interp1(t,y,tq);
subplot(132),plot(xq,yq,'k.');
speed=sqrt((xq(2:end)-xq(1:end-1)).^2+(yq(2:end)-yq(1:end-1)).^2);
subplot(133),plot(tq(1:end-1)/FPS,speed,'k');title('Speed');
%%
% [yaudio,Fs] = audioread('/Users/Emily/Documents/behavior/20170929/audio/20170929_mice4_1_80db20ktone20s_1trial.m4a');
% taudio=1/Fs:1/Fs:size(yaudio,1)/Fs;
% figure,plot(taudio,yaudio(:,1));
% yaudio_single=yaudio(:,1)';
% locutoff=0;
% hicutoff=10;
% [smoothdata,filtwts] = eegfilt(yaudio_single,Fs,locutoff,hicutoff);
% figure,plot(taudio,smoothdata)
