# required library or package
# --opencv # conda install opencv
# --tkinter

# @zhanglab

import cv2
import numpy as np
#import matplotlib.pyplot as plt
import os
from math import hypot
from Tkinter import Tk
from tkFileDialog import askopenfilename


Tk().withdraw() # we don't want a full GUI, so keep the root window from appearing
filename = askopenfilename() # show an "Open" dialog box and return the path to the selected file
print(filename)
(root, ext) =os.path.splitext(filename) 

duration = 1  # second
freq = 440  # Hz

#mouse_cascade = cv2.CascadeClassifier('mouse_body_cascade.xml')
cap = cv2.VideoCapture(filename)

Moving_track = [(0,0)]
font = cv2.FONT_HERSHEY_SIMPLEX

fourcc = cv2.VideoWriter_fourcc('m','p','4','v')
out = cv2.VideoWriter(root+'_out.mp4',fourcc,30,(1280,720))

Peak_speed = 0


while not cap.isOpened():
    cap = cv2.VideoCapture(filename)
    cv2.waitKey(1000)
    #os.system('play --no-show-progress --null --channels 1 synth %s sine %f' % (duration, freq))
    print("Can't load the file")
    break

a=[(0,0)]
i=0
record = False

while True:
    i+=1
    ret, img_raw =cap.read() #start capture images from webcam
    if ret == False:
        break        
    if i==1:
        r = cv2.selectROI(img_raw)    
    img_gray = cv2.cvtColor(img_raw,cv2.COLOR_BGR2GRAY)
    y_start = int(r[0])
    y_stop = int(r[0]+r[2])
    
    x_start = int(r[1])
    x_stop = int(r[1]+r[3])     
    
    img_gray = img_gray[x_start:x_stop,y_start:y_stop]
    color_img = cv2.cvtColor(img_gray, cv2.COLOR_GRAY2RGB)
    img=color_img.copy()
    blur = cv2.GaussianBlur(img_gray,(5,5),0)
    retval,img_bi = cv2.threshold(blur,20,255,cv2.THRESH_BINARY_INV)
    binary,contours,hierarchy = cv2.findContours(img_bi.copy(),cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)


    # only proceed if at least one contour was found
    if len(contours) > 0:
		# find the largest contour in the mask, then use
		# it to compute the minimum enclosing circle and
		# centroid
        c = max(contours, key=cv2.contourArea)
        ((x, y), radius) = cv2.minEnclosingCircle(c)
        try:
            M = cv2.moments(c)
            center = (int(M["m10"] / M["m00"])+int(y_start), int(M["m01"] / M["m00"])+int(x_start))
            if radius >10:
                prev_center= center
            else:
                center = prev_center

        except ZeroDivisionError:
            center = prev_center
            print("error")
    else:
        center = prev_center
        print('not detected')

    d_dist = hypot(Moving_track[-1][0]-center[0],Moving_track[-1][1]-center[1])
    Speed = (d_dist/0.04)*0.075
    Moving_track.append(center)
    points = np.array(Moving_track)
    cv2.polylines(img_raw,np.int32([points[1:]]),0,(0,0,255))
    cv2.imshow(r'img',img_raw)
    out.write(img_raw)
    line = str(center[0])+','+str(center[1])+','+str(Speed)+'\n'
    with open(root+r'_trackTrace.csv','a') as f:
        f.write(line)

    except ZeroDivisionError:
        print("error")

    print("this is frame#:", i)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break    

print("Processing Done!")
cap.release()
cv2.destroyAllWindows()
out.release()
