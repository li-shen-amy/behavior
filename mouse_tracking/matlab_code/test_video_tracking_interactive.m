clc;clear;close all;
xpn='/Users/Emily/Documents/PVT/behavior/20171129_2chamber';
movname='PVT_AP_#2_ori';
load(fullfile(xpn,movname));

ext='.mov';
movfullname=fullfile(xpn,[movname,ext]);
V=VideoReader(movfullname);
while V.CurrentTime<3
video=readFrame(V);%,'native');
end

ymin=fix(min(boundary(:,2)));
ymax=ceil(max(boundary(:,2)));
xmin=fix(min(boundary(:,1)));
xmax=ceil(max(boundary(:,1)));

x_trans=(x-xmin)/(xmax-xmin);
y_trans=(y-ymin)/(ymax-ymin);

[m,n,~]=size(video);

figure,set(gcf,'position',[ 360   428   706   270]);
subplot(121),image(video);
hold on
plot(x,y);
axis off;

subplot(122),image(video);
hold on
plot(x,y);
axis([xmin,xmax,ymin,ymax]);
axis off;
% plot(x_trans,y_trans);
%%
led_box='right';
ygap=119;
xgap=[135,141];
box_point=[xmin,ymin;xgap(1),ymin;xgap(1),ygap;
    xgap(2),ygap;xgap(2),ymin;xmax,ymin;
    xmax,ymax;xmin,ymax;xmin,ymin];
   if strcmp(led_box,'left')
   stimbox_point=[xmin,ymin;xgap(1),ymin;xgap(1),ymax;xmin,ymax;xmin,ymin];
 else
         stimbox_point=[max(xgap),ymin;max(xgap),ymax;...
        xmax,ymax;xmax,ymin]; 
   end
   
   blue_light=[0.9,0.9,1];
figure,
patch(stimbox_point(:,1),stimbox_point(:,2),blue_light,'edgecolor','none');
% image(video);
hold on,
plot(x,y);
plot(box_point(:,1),box_point(:,2),'k','linewidth',2);
axis([xmin,xmax,ymin,ymax]);
axis off
%%
in_left=find(x<min(xgap));
in_right=find(x>max(xgap));
time_left=length(in_left);   % 331
time_right=length(in_right);  %271

% distance=sqrt((y_trans(2:end)-y_trans(1:end-1)).^2+...
%     (x_trans(2:end)-x_trans(1:end-1)).^2);

distance=sqrt((y(2:end)-y(1:end-1)).^2+...
    (x(2:end)-x(1:end-1)).^2);
%%
max_speed=70;
if strcmp(led_box,'left')
    in_led=in_left;
else
in_led=in_right;
end

figure,set(gcf,'position',[ 227   478   910   220]);
hold on
for i=1:length(in_led)
    led_box=[in_led(i)-0.5,max_speed;in_led(i)+0.5,max_speed;
        in_led(i)+0.5,0;in_led(i)-0.5,0];
    patch(led_box(:,1),led_box(:,2),blue_light,'edgecolor','none');
end
plot(distance,'k','linewidth',2);box off;
ylabel('Speed');xlabel('Time');
xlim([0,time_sample(end)]);
% boundary=ginput(4);
% save(fullfile(xpn,movname),'time_sample','x','y','boundary');