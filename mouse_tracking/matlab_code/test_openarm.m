clc;clear;close all;
prepath='/Users/Emily/Documents/PVT/behavior/20171208_openarm/';
for id=3:5
    movname=['20171208_openarm_control_',num2str(id),'.mov'];
movfullname=fullfile(prepath,movname);
V=VideoReader(movfullname);
% FPS=V.FrameRate;
dur=V.Duration;
frame= [ 190.3618  36.5000
  467.5968  34.3978
  467.5968  311.8869
  188.8871   311.8869];
bound=[40,161,188,312;186,312,338,468];%first y then x
h = ones(5,5) / 25;
%     figure,
count=0;
clear ia ib
shift=2;
while V.CurrentTime<shift
      readFrame(V);
end
while V.CurrentTime<dur
    while V.CurrentTime<count+shift && V.CurrentTime<dur
        readFrame(V);
    end
    if V.CurrentTime<dur
    video=readFrame(V);
    bw=im2bw(video,0.1);
 
    bw(bound(1,1):bound(1,2),bound(1,3):bound(1,4))=1;
    bw(bound(2,1):bound(2,2),bound(2,3):bound(2,4))=1;
    bw=bw(bound(1,1):bound(2,2),bound(1,3):bound(2,4));
    bw = imfilter(bw,h);
    a=sum(bw,1);
    b=sum(bw,2);
    count=count+1;
    [~,ia(count)]=min(a);
    [~,ib(count)]=min(b);
%   imagesc(video(40:312,188:468,:));hold on,plot(ia(count),ib(count),'r^');
%   hold off
%   pause
    end
end
figure(1),plot(ia,ib,'k');
saveas(1,strrep(movfullname,'.mov','.fig'));
close all;
dur_open=length(find(ia<(bound(1,4)-bound(1,3)+1) | ia>(bound(2,3)-bound(1,3)+1)));
dur_closed=length(find(ib<(bound(1,2)-bound(1,1)+1) | ia>(bound(2,1)-bound(1,1)+1)));
open_percent=dur_open/(dur_closed+dur_open)
save(strrep(movfullname,'.mov',''),'frame','bound','shift','ia','ib','dur_open','dur_closed','open_percent');
end