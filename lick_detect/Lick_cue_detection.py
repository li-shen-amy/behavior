# -*- coding: utf-8 -*-
"""
Created on Thu Oct 25 20:17:02 2018

@authors: Li Shen & Guangwei Zhang @ University of Southern California
"""
'''
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style

style.use('fivethirtyeight')

fig = plt.figure()
ax1 = fig.add_subplot(1,1,1)

def animate(i):
    graph_data = open('example.txt','r').read()
    lines = graph_data.split('\n')
    xs = []
    ys = []
    for line in lines:
        if len(line) > 1:
            x,y = line.split(',')
            xs.append(x)
            ys.append(y)
    ax1.clear()
    ax1.plot(xs,ys)
    
ani = animation.FuncAnimation(fig,animate,interval =1000)

'''
import numpy as np
import cv2
from tkinter import Tk
from tkinter.filedialog import askopenfilename
import os


## configurations
cue_detect = 1
lick_detect = 1
use_red_ch = 0


Tk().withdraw() # we don't want a full GUI, so keep the root window from appearing
filename = askopenfilename() # show an "Open" dialog box and return the path to the selected file
print(filename)
(root, ext) =os.path.splitext(filename) 

duration = 1  # second
freq = 440  # Hz

#mouse_cascade = cv2.CascadeClassifier('mouse_body_cascade.xml')
cap = cv2.VideoCapture(filename)


sdThresh = 10
font = cv2.FONT_HERSHEY_SIMPLEX
#TODO: Face Detection 1

def distMap(frame1, frame2):
    """outputs pythagorean distance between two frames"""
    frame1_32 = np.float32(frame1)
    frame2_32 = np.float32(frame2)
    diff32 = frame1_32 - frame2_32
    norm32 = np.sqrt(diff32[:,:,0]**2 + diff32[:,:,1]**2 + diff32[:,:,2]**2)/np.sqrt(255**2 + 255**2 + 255**2)
    dist = np.uint8(norm32*255)
    return dist

fourcc = cv2.VideoWriter_fourcc('m', 'p', '4', 'v')

cv2.namedWindow('frame')
cv2.namedWindow('dist')

#capture video stream from camera source. 0 refers to first camera, 1 referes to 2nd and so on.
#cap = cv2.VideoCapture(0)

_, frame1 = cap.read()
_, frame2 = cap.read()

facecount = 0
i=0;
while(True):
     
    _, frame3 = cap.read()
    i+=1
    if i==1:
        if cue_detect == 1:
            r = cv2.selectROI(frame3)
            #img_gray = cv2.cvtColor(frame3,cv2.COLOR_BGR2GRAY)
            y_start = int(r[0])
            y_stop = int(r[0]+r[2])
            
            x_start = int(r[1])
            x_stop = int(r[1]+r[3])
            #out = cv2.VideoWriter(root + '_roi.mp4', fourcc, 30, (r[2], r[3]))
            
        if lick_detect == 1:
            r2 = cv2.selectROI(frame3)
            # img_gray = cv2.cvtColor(frame3,cv2.COLOR_BGR2GRAY)
            y_start2 = int(r2[0])
            y_stop2 = int(r2[0] + r2[2])
            x_start2 = int(r2[1])
            x_stop2 = int(r2[1] + r2[3])
            #out2 = cv2.VideoWriter(root + '_lick_roi.mp4', fourcc, 30, (r2[2], r2[3]))

    #frame3 = img_gray
    cv2.imshow('frame', frame3)
    rows, cols, _ = np.shape(frame3)
    # cv2.imshow('dist', frame3[x_start:x_stop,y_start:y_stop])
    #dist = distMap(frame1[x_start:x_stop,y_start:y_stop], frame3[x_start:x_stop,y_start:y_stop])
    if cue_detect == 1:
        mod = frame3[x_start:x_stop,y_start:y_stop]
        cue_index = np.mean(mod)
        line = str(i)+','+str(cue_index)+'\n'
        with open(root+r'_cue.csv','a') as f:
            f.write(line)
        #out.write(mod)
            
    if lick_detect == 1:
        mod2= frame3[x_start2:x_stop2,y_start2:y_stop2,:]
        if use_red_ch==1:
            modg= mod2[:,:,0]
            modb= mod2[:,:,1]
            lick_index = np.mean(mod2[:,:,2])-0.5*(np.mean(modg)+np.mean(modb))
        else:
            lick_index = np.mean(mod2)

        cv2.imshow('lick', mod2)
        line = str(i) + ',' + str(lick_index) + '\n'
        with open(root + r'_lick.csv', 'a') as f:
            f.write(line)
    
    frame1 = frame2
    frame2 = frame3
    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()
out.release()