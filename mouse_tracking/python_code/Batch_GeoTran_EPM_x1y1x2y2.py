'''
@author: zhanglab
#Requirement : Python3 , opencv-python, tkinter

# Usage instruction: 
Choose point (double click left mouse button) in the order left, Upper, Right, Lower
Click "c" in the keyword for confirmation, the dimension is 

610 x 610 mm
            _ 
           | |
           | |
           | |
___________| |___________   
|__________   ___________| 
           | |
           | |                                                                                             
           | |
           |_|
           
The output video is 445 * 295 at 30fps, thus 1mm/pixel
Changes can be made, for "out" and the "pts2" for other behavior test

'''


import cv2
import numpy as np
#import matplotlib.pyplot as plt
import os
from math import hypot
from tkinter import Tk
from tkinter.filedialog import askopenfilenames


box_length = 610
box_width = 610
posList = []
def draw_circle(event,x,y,flags,param):
    global mouseX,mouseY
    if event == cv2.EVENT_LBUTTONDBLCLK:
        cv2.circle(img_raw,(x,y),1,(255,0,0),-1)
        mouseX,mouseY = x,y
        posList.append((x, y))       


root1 = Tk()
root1.withdraw()
filez = askopenfilenames(parent = root1, title = 'Choose file')
fourcc = cv2.VideoWriter_fourcc('m','p','4','v')
file_order = 0;
for fullFileName in root1.tk.splitlist(filez):
    print(fullFileName)
    filename = fullFileName
    (root, ext) =os.path.splitext(filename) 
    duration = 1  # second
    freq = 440  # Hz
    file_order +=1
    cap = cv2.VideoCapture(filename)
    i=0
    while i<2:
        i+=1
        ret, img_raw =cap.read() #start capture images from webcam
        if ret == False:
            break    
        while i==1:
            cv2.namedWindow("image")
            cv2.setMouseCallback("image", draw_circle)
            posNp = np.array(posList) 
            cv2.imshow('image',img_raw)
            k = cv2.waitKey(20) & 0xFF
            if k == ord("r"):    
                ret, img_raw =cap.read()                                                                                                                                                                                      
                image = img_raw
            if k == ord("c"):
                break 
    cap.release()    
cv2.destroyAllWindows()       

j=0
for fullFileName in root1.tk.splitlist(filez):
    j+=1
    filename = fullFileName
    print(filename)
    (root, ext) =os.path.splitext(filename) 
    cap = cv2.VideoCapture(filename)
    while not cap.isOpened():
        cap = cv2.VideoCapture(filename)
        cv2.waitKey(1000)
        #os.system('play --no-show-progress --null --channels 1 synth %s sine %f' % (duration, freq))
        print("Can't load the file")
        break
    duration = 1  # second
    freq = 440  # Hz   
    cap = cv2.VideoCapture(filename)
    width = int(cap.get(3))
    height = int(cap.get(4))

    font = cv2.FONT_HERSHEY_SIMPLEX
    out = cv2.VideoWriter(root+'_GeoTran.mp4',fourcc,25,(box_length,box_width))
    pts0 = np.float32(posList[(j-1)*4:(j*4)])
    pts1 = np.float32([[pts0[0][0],pts0[1][1]],[pts0[2][0],pts0[1][1]],[pts0[0][0],pts0[3][1]],[pts0[2][0],pts0[3][1]]])
    pts2 = np.float32([[0,0],[box_length,0],[0,box_width],[box_length,box_width]])
    M = cv2.getPerspectiveTransform(pts1,pts2)
    while True:
        ret, img_raw =cap.read() #start capture images from webcam
        if ret == False:
            break
        img = img_raw
        rows,cols,ch = img.shape
        dst = cv2.warpPerspective(img,M,(box_length,box_width))
        out.write(dst)          
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    out.release()
    cv2.destroyAllWindows()