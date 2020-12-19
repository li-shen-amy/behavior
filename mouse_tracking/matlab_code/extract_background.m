function video_sum=extract_background(movfullname)
V=VideoReader(movfullname);
video_sum=  double(readFrame(V));
time_list=V.CurrentTime:V.duration;
for time=V.CurrentTime:V.duration
    V=VideoReader(movfullname,'CurrentTime',time);
    video_sum= video_sum+ double(readFrame(V));
end
video_sum=uint8(video_sum/length(time_list));