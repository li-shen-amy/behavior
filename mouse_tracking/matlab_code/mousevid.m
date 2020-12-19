%% video
%note-code within a double % block can be run using ctrl+enter(which is
%what I often do) but when you first run it it's better to go few lines at
%a time using highlighting+F9. 

folder='/Users/Emily/Downloads/';
vids=dir([folder '*.mov']); %get all files ending with .wmv; can change it to .mp4 .mov etc

%%

vidid=1;

vidpath=[folder vids(vidid).name];
vid=VideoReader(vidpath); %vid object

frn=vid.NumberOfFrames;

%read the entire video 1000 frames at a time and convert to black and white
%along the way. One could read the whole thing at the same time but
%processing such big data can be prohibitive without enough memory
fr=[]; 
for i=1:1000:frn
frames=vid.read([i min(i+999,frn)]);
fr=cat(3,fr,squeeze(uint8(mean(frames,3)))); %convert to black and white (simple mean) 
display(num2str(i));
end;
clear frames;

L=size(fr,3);
Tframe=(1:L)/L*vid.Duration;

%%
%code to derive apparent motion from raw changes in pixel values (for
%freezing...)
%I haven't played with this part of the code in a while so there is
%currently no mask, no normalization of brightness etc. There is no way to
%tell whether the apparent motion is due to mouse moving or due to changes
%in background brightness/optogenetic stimulation/etc-that would require more robust code.
% 
% mv=[];
% for i=1:size(fr,3)-1
%     frdiff=abs(fr(:,:,i+1)-fr(:,:,i)); %difference in pixel values between consecutive frames
%         %you could store these and play them as a movie to see whether/when the
%         %frdiff pixels properly reflect mouse movement (and see what they
%         %look like when mouse freezes)
%     s=sort(frdiff(:),'descend');
%     mv(i)=mean(s(1:25)); %top 25 pixels with highest change (arbitrary). The idea is to only focus on pixels related to mouse movement
%         %but I haven't really empirically tested whether it helps (the difference seems small)
% end;
% 
% mv=[mv(1) (mv(2:end)+mv(1:end-1))/2 mv(end)]; %movement at frame n is the average of n-1 to n and n to n+1 movement. 
%     %first and last frame cannot be fully determined . 
    
%% led light/noise ?problematic?
    colorvid=vid.read([1 size(fr,3)]);
    blue=squeeze(colorvid(:,:,3,:));
    blue=reshape(blue,[size(blue,1)*size(blue,2) size(blue,3)]);
    mbl=max(blue);
    ledonfr=find(mbl>mean(mbl),1,'first')
    figure; hold on; 
    plot(1:ledonfr,mbl(1:ledonfr));
    plot(ledonfr:length(mbl),mbl(ledonfr:end),'r');
% 
% [y Fs]=audioread(vidpath); %trace and samplerate
% y(:,2)=[];
% non=find(abs(y)>0.1,1,'first');
% figure(1); hold on;
% plot((1:non)/Fs,y(1:non));
% plot((non:length(y))/Fs,y(non:end),'r');
% noiseonfr=round(non/Fs/vid.Duration*vid.NumberOfFrames)


 %% get mask

%Everything below here is for mouse position tracking. 

ppf=size(fr,1)*size(fr,2); %pixels per frame
% m=reshape(fr,[ppf size(fr,3)]);
% mb=mean(m); %mean brightness
% 
% figure; plot(Tframe,mb); %mean brightness. This can change if someone opens the cage or due to light from optogenetic stimulation

Trange=[0 10]; %time window to consider for analysis
frin=find(Tframe>=Trange(1)&Tframe<=Trange(2));
fr=fr(:,:,frin);
Tframe=Tframe(frin);


%The code below makes sure every frame has the same range of pixel values
%I added this primarily to deal with changes with brightness during
%optogenetic stimulation. 
%(0.5th percentile and below mapped to 0 and 99th percentile and above mapped to 255)
frorig=fr;
for i=1:size(fr,3)
    frtemp=double(fr(:,:,i));
    s=sort(frtemp(:),'ascend');
    ra=s(round(0.005*ppf)); %0.5 percentile 
    rb=s(round(0.99*ppf));
    frtemp(frtemp<ra)=ra;
    frtemp(frtemp>rb)=rb;
    frtemp=(frtemp-ra)/(rb-ra); %rescale 0 to 1
    fr(:,:,i)=uint8(255*frtemp);
    if rem(i,500)==0
        display(i); 
    end;
end;

MM=max(fr,[],3); %max should basically get you the background picture without a mouse



%Code below is a slightly inelegant interactive way to define 'mask' separating
%cage area from the surrounding region. The 't' button sets a threshold
%separating cage area from surroundings(threshold is the pixel value the
%mouse is pointing at when you press 't'). Unfortunately, simple thresholding
%never works so you can also add regions to the cage or outside. Regions
%are added using three mouse clicks(defining a parallelogram)-if the 3rd mouse click is the left
%button, it gets added to the 'cage' area. If it's the middle button, it
%gets added to 'surround' area. Moreover, after thresholding you can delete
%'holes' by pressing 't' again (neighbor count based delition) and you can
%switch between 'mask' view and masked frame view by pressing 's'.
%This is a VERY lazy way to make an interactive GUI. 
button=0;
counter=1;
A=MM;
imswitch=false;
[X Y]=meshgrid(1:size(fr,2),1:size(fr,1));
while button~=(' '+0)
    if imswitch
        A=double(MM>0).*double(fr(:,:,1));
    else
        A=MM;
    end;
    figure(1); imagesc(A); colormap(gray);
    [xx yy button]=ginput(1);
    if button=='s'+0
        imswitch=~imswitch;
    end;
        
    if button=='t'+0
        thr=MM(round(yy),round(xx));
        if thr==0||thr==255
            nbs=conv2(double(MM)/255,ones(5),'same');
            MM((MM==255)&(nbs<10))=0;
            MM((MM==0)&(nbs>10))=255;
        else
            MM(MM<=thr)=0;
            MM(MM>thr)=255;
        end
    end;
    
    if button==1||button==2
        
        xyc(counter,:)=[xx yy];
        
        if counter==3 %define parallelogram. linear algebra stuff. 
            %Slightly tricky, took me some time to figure out how to 'fill'
            %a parallelogram
            
            ab=xyc(2,:)-xyc(1,:);
            AB=norm(ab);
            ab=ab/AB; %normalize
            ac=xyc(3,:)-xyc(1,:);
            AC=norm(ac);
            ac=ac/AC;
            
            %The problem being solved here is: what are the coordinates of
            %pixels expressed in terms of vectors ab,ac that
            %you defined by mouse clicks... 
            
            Uinv=inv([ab' ac']);
            
            Xc=X-xyc(1,1);
            Yc=Y-xyc(1,2);
            
            Pab=Uinv(1,1)*Xc+Uinv(1,2)*Yc;
            Pac=Uinv(2,1)*Xc+Uinv(2,2)*Yc;
            
            pgram=(Pab>0)&(Pac>0)&((Pab/AB)<1)&((Pac/AC)<1);
            if button==1
                MM(pgram)=255;
            end;
            if button==2
                MM(pgram)=0;
            end;
            
            counter=0;
        end;
        counter=counter+1;
    end;
end;

mask=MM>0;

%readjust brightness again, this time using only the mask region 
%->This is actually very important because it makes sure that the mouse pixel
%values are near 0
for i=1:size(fr,3)
    frtemp=double(fr(:,:,i));
    usedpix=frtemp(mask);
    s=sort(usedpix,'ascend');
    ra=s(round(0.005*length(s))); %0.5 percentile 
    rb=s(round(0.99*length(s)));
    frtemp(frtemp<ra)=ra;
    frtemp(frtemp>rb)=rb;
    frtemp=(frtemp-ra)/(rb-ra); %rescale 0 to 1
    fr(:,:,i)=uint8(255*frtemp);
    if rem(i,500)==0
        display(i); 
    end;
end;

close all;

%% determine mouse position
[X Y]=meshgrid(-10:10,-10:10);
F=double((X.^2+Y.^2)<10^2); %<10^2 neighbor counting filter. Could just be a square but circle makes a bit more sense

bodypix=[];
position=[];
mousegonefr=[]; %temporary code modification for mouse fleeing videos
for i=1:size(fr,3)
    frtemp=double(fr(:,:,i));
    frtemp(frtemp<40)=1; %equalize values between mouse butt and mouse head 
        %most of the mouse body is below 15, but the ears are much higher
        %mouse can also be higher when the led light is on-> 40 seems to
        %separate mouse from background in those cases
    frtemp(frtemp>=40)=0; %eequalize values between wall and ground 

    frtemp=frtemp.*mask;
    nbs=conv2(frtemp,F,'same');
    frtemp(nbs<round(sum(F(:))*0.75))=0; %eliminate 'inside mouse points' with too few mouse neighbors
    %this makes sure optic fiber isn't considered part of the mouse
    bodypix(i)=sum(frtemp(:));
    
    [rr cc]=find(frtemp);
        
    rin=round(mean(rr)); %center of mass of the mouse
    cin=round(mean(cc));
    
     %if mouse center of mass doesn't exist, mouse is gone. I should
     %probably not normalize within-mask pixels when I do this, because
     %mouse leaving will make other pixels dimmer...(ideally the video
     %always shows the mouse even if it goes to a different chamber)
    if ~(isnan(rin)||isnan(cin))     
        position=[position;rin cin];
        fr(rin-1:rin+1,cin-1:cin+1,i)=255; %set mouse-center pixel bright. This helps to check whether the algorithm is working correctly
    end;
    
    
    if rem(i,500)==0
        display(i); 
    end;
end;

mnbodypix=mean(bodypix(bodypix>0));
mousegonefr=find(bodypix<0.25*mnbodypix,1,'first')
figure; plot(bodypix);
%% code chunks for plotting

%this is a bit of a mess but different chunks of code are generally for
%different plots Xiao wanted OR for code evaluation. 

% vid=VideoWriter('test.mp4');
% vid.FrameRate=size(fr,3)/120;
% vid.open();
% for i=1:size(fr,3), vid.writeVideo(fr(:,:,i)); end;
% % vid.close();
% 
%  for i=mousegonefr-3:mousegonefr+3 
%      figure(i); imagesc(fr(:,:,i)); 
%  end;
%  
% % vidid=1;
% position=vids(vidid).position;
% mask=vids(vidid).mask;
% ledonfr=vids(vidid).ledonfr;
% mousegonefr=vids(vidid).mousegonefr;

% 
% 
% 
% figure; plot(position(:,2),-position(:,1),'-*k'); axis equal; xlim([0 640]); ylim([-480 0]); axis off;
% 
% figure(1);
% % plot(position(1:ledonfr-1,2),-position(1:ledonfr-1,1),'-r','LineWidth',3);
% hold on; 
% plot(position(ledonfr:mousegonefr-7,2),-position(ledonfr:mousegonefr-7,1),'-b','LineWidth',1.5);
% axis equal; xlim([0 640]); ylim([-480 0]); axis off;
% plot(boundary(:,2),-boundary(:,1),'k');
% 
% 
% figure(1); hold on;
% 
% for i=1:4
%     
%     vidid=i;
%     
%     position=vids(vidid).position;
%     mask=vids(vidid).mask;
%     ledonfr=vids(vidid).ledonfr;
%     mousegonefr=vids(vidid).mousegonefr;
%     
%     if isempty(mousegonefr)
%         mousegonefr=length(position);
%         position=2*position; %the 2 videos with no flight also happen to be 2x lower resolution
%     end;
%     
%     if i<=2
%         linestyle='-b';
%     else
%         linestyle='-r';
%     end;
%     
%     plot(position(ledonfr:mousegonefr-7,2),-position(ledonfr:mousegonefr-7,1),linestyle,'LineWidth',1.5);
%     axis equal; xlim([0 854]); ylim([-480 0]); axis off;
%     plot(boundary(:,2),-boundary(:,1),'k');
%     
% end;

% for i=1:4 figure(1); subplot(2,2,i); position=vids(i).position; plot(position(:,2),-position(:,1),'-*k'); axis off; axis equal; end;

% vid=VideoWriter('testC.mp4');
% vid.FrameRate=size(fr,3)/120;
% vid.open();
% % for i=1:size(fr,3), vid.writeVideo(fr(:,:,i)); end;
% vid.close();

for i=1:size(fr,3)
%     h=figure(1); subtightplot(1,2,1);  plot(position(1:i,2),-position(1:i,1),'-*k'); axis equal; xlim([0 640]); ylim([-480 0]); axis off; subtightplot(1,2,2); imagesc(fr(:,:,i)); axis equal; colormap(gray); axis off;
%     mv(i)=getframe(h);
    WaitSecs(0.05);
    h=figure(1); subtightplot(1,2,1); 
    plot(position(1:i,2),-position(1:i,1),'-k'); axis equal; xlim([0 size(fr,2)]); ylim([-size(fr,1) 0]); axis off; subtightplot(1,2,2); imagesc(fr(:,:,i)); axis equal; colormap(gray); axis off;
end;

