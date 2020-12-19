clc;clear;close all;
path='/Users/Emily/Documents/conditioning/20180612_MS_chat_dreadd';
audioname='20180613_MS_chat_dreadd_test_5ktone+shockx5_1nonelefthindleg';
[y,fs]=audioread(fullfile(path,[audioname,'.m4a']));

y_single=y(:,1);
sec_bin=1:fs:size(y,1);
for i=1:length(sec_bin)-1
    sum_sec(i)=sum(abs(y_single(sec_bin(i):sec_bin(i+1))));
end
sum_exc=find(sum_sec>1500);
pre_sec=sum_exc(1);
trigger=sum_exc(1);
count=1;
for i=2:length(sum_exc)
    if sum_exc(i)>pre_sec+20
        count=count+1;
        trigger(count)=sum_exc(i);
        pre_sec=trigger(count);
    end
end
figure,plot(1/fs:1/fs:length(y_single)/fs,y_single/max(y_single))
hold on,plot(1:length(sec_bin)-1,sum_sec/max(sum_sec))
trigger
%%
% movfullname=fullfile(path,[audioname,'.mov']);
% % movfullname=fullfile(fatherfolder,prepath,[movname,'.mov']);
% V=VideoReader(movfullname);
% video_sum=  double(readFrame(V));
% time_list=V.CurrentTime:V.duration;
% for time=V.CurrentTime:V.duration
%     V=VideoReader(movfullname,'CurrentTime',time);
%     video_sum= video_sum+ double(readFrame(V));
% end
% video_sum=video_sum/length(time_list);
% figure,image(uint8(video_sum));
%%