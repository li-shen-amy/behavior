% interactive tracking
clc;clear;close all;
xpn='/Users/Emily/Documents/PVT/behavior/20171129_2chamber';
movname='PVT_AP_#2';

xpn='/Users/Emily/Documents/PVT/behavior/20171201_1chamber';
movname='pvt_#1_newcontext_20171201';

ext='.mov';
movfullname=fullfile(xpn,[movname,ext]);
V=VideoReader(movfullname);
FPS=V.FrameRate;
% time_sample=0.5:0.5:  fix(V.duration);
time_sample=313:fix(V.duration);
for t=1:length(time_sample)
while V.CurrentTime<time_sample(t)
video=readFrame(V);%,'native');
end
% V.CurrentTime
figure(1),
imagesc(video);
[x(t),y(t)]=ginput(1);
end
save(fullfile(xpn,movname),'time_sample','x','y');


