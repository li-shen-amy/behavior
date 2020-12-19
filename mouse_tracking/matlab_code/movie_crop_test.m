clc;clear;close all;
prepath='/Users/Emily/Documents/PVT/behavior/20171208_openarm/';
movname='20171208_openarm_control_1.mov';

prepath='/Users/Emily/Documents/PVT/behavior/20171215/';
movname='20171215_non_2chamber.mov';
starttime=31;
movfullname=fullfile(prepath,movname);
V=VideoReader(movfullname);

while V.currentTime<starttime
 video=readFrame(V);%,'native');
end
figure,image(video);
[x,y]=ginput(4)
% frame= [ 190.3618  36.5000
%   467.5968  34.3978
%   467.5968  311.8869
%   188.8871   311.8869];