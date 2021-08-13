'''
@author: zhanglab
#Requirement : Python3 , opencv-python, tkinter

# Usage instruction: 
Select downsampled video file (recommend 480p x 480p for faster speed)
Once finished, video with tracking trace and excel sheet appear in source folder for video
For excel file: three columns, first is x, second is y coord, third is pixel distance traveled between frames
For the third column, value is always incorrect, so change to zero.
Plot x and y columns for trace of motion graph (line graph)
Plot motion column for speed trace. Convert y-axis to inches per frame by measure how many pixels per inch in video (and convert speed to secs using 30 fps conversion).

Delete orginal excel file for a given video if you want to re-run the program analysis for the same video (it will just add data to the original excel file making it really long).
'''

import cv2
import numpy as np
#import matplotlib.pyplot as plt
import os
from math import hypot
from tkinter import Tk
from tkinter.filedialog import askopenfilenames


root1 = Tk()
filez = askopenfilenames(parent = root1, title = 'Choose file')
#threshold = 50
#print(root1.tk.splitlist(filez))
for fullFileName in root1.tk.splitlist(filez):
    filename = fullFileName
    (root, ext) =os.path.splitext(filename) 
    print(root)  
    
    duration = 1  # second
    freq = 440  # Hz
    #mouse_cascade = cv2.CascadeClassifier('mouse_body_cascade.xml')
    cap = cv2.VideoCapture(filename)    
    Moving_track = [(0,0)]
    ## add text
    font = cv2.FONT_HERSHEY_SIMPLEX    
    # export video setting
    width = int(cap.get(3))
    height = int(cap.get(4))    
    
    fourcc = cv2.VideoWriter_fourcc('m','p','4','v')
    out = cv2.VideoWriter(root+'_out.mp4',fourcc,30,(width,height))
    Peak_speed = 0
    while not cap.isOpened():
        cap = cv2.VideoCapture(filename)
        cv2.waitKey(1000)
        #os.system('play --no-show-progress --null --channels 1 synth %s sine %f' % (duration, freq))
        print("Can't load the file")
        break

    a=[(0,0)]
    i=0
    Counting = 0
    record = False

    while True:
        i+=1
        ret, img_raw =cap.read() #start capture images from webcam
        if ret == False:
            break
        if i ==1:
             ret, img_raw =cap.read()
             print("Select Closed Arm ROI, then Open Arm ROI")
             r = cv2.selectROI(img_raw)
             pt_1_1 = (int(r[0]),int(r[1]))
             pt_1_2 = (int(r[0]+r[2]),int(r[1]+r[3]))             
             mask = np.zeros(img_raw.shape[:2], dtype="uint8")
             cv2.rectangle(mask, pt_1_1, pt_1_2, 255, -1)             
             
             r_open = cv2.selectROI(img_raw)
             pt_1_1_open = (int(r_open[0]),int(r_open[1]))
             pt_1_2_open = (int(r_open[0]+r_open[2]),int(r_open[1]+r_open[3]))             
             cv2.rectangle(mask, pt_1_1_open, pt_1_2_open, 255, -1)
             
             x_start_region4Counting = pt_1_1[0]
             x_stop_region4Counting = pt_1_2[0]        
             y_start_region4Counting = pt_1_1[1]
             y_stop_region4Counting = pt_1_2[1]  
             
             mask_inv = 255- mask
             white_img = 255 * np.ones(img_raw.shape, dtype="uint8")
             cv2.rectangle(white_img, pt_1_1, pt_1_2, 0, -1)       
             cv2.rectangle(white_img, pt_1_1_open, pt_1_2_open, 0, -1) 
             print(r)
             print(r_open)
        masked = cv2.bitwise_and(img_raw, img_raw, mask) 
        masked = cv2.bitwise_or(masked, white_img, mask_inv)
           
        img_gray = cv2.cvtColor(masked,cv2.COLOR_BGR2GRAY)  
        y_start = 1
        y_stop = 629
        
        x_start = 1
        x_stop = 629
        masked = 255- masked

        blur = cv2.GaussianBlur(img_gray,(5,5),0)
        retval,img_bi = cv2.threshold(blur,50,255,cv2.THRESH_BINARY_INV)
        kernel = np.ones((5, 5), np.uint8)
        img_bi = cv2.erode(img_bi,kernel)
        
        contours,hierarchy = cv2.findContours(img_bi.copy(),cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)

        # only proceed if at least one contour was found
        if len(contours) > 0:
    		# find the largest contour in the mask, then use
    		# it to compute the minimum enclosing circle and
    		# centroid
            c = max(contours, key=cv2.contourArea)
            ((x, y), radius) = cv2.minEnclosingCircle(c)
            try:
                M = cv2.moments(c)
                center = ((M["m10"] / M["m00"])+(y_start), (M["m01"] / M["m00"])+(x_start))
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
        cv2.circle(img_raw, (int(center[0]), int(center[1])), 5, (0, 0, 255), -1)
        d_dist = hypot(Moving_track[-1][0]-center[0],Moving_track[-1][1]-center[1])
        Speed = (d_dist/0.04)*0.075
        temp = "{:0>.2f}".format(Speed)                    
        Moving_track.append(center)                    

        points = np.array(Moving_track)
        cv2.polylines(img_raw,np.int32([points[1:]]),0,(0,0,255))
        line = str(center[0])+','+str(center[1])+','+str(Speed)+'\n'    
        Counting_temp = (float(center[0]) > x_start_region4Counting) & (float(center[0]) < x_stop_region4Counting)  & (float(center[1]) > y_start_region4Counting) & (float(center[1]) < y_stop_region4Counting)       
        Counting+=Counting_temp
        
        percentage_in_region4Counting = Counting/i
        temp_percent = "{:0>.2f}".format(percentage_in_region4Counting)
        cv2.putText(img_raw,str(Counting_temp),(50,50),font,1,(255,0,0),2,cv2.LINE_AA)
        cv2.rectangle(img_raw,(x_start_region4Counting,y_start_region4Counting),(x_stop_region4Counting,y_stop_region4Counting),(255,0,0))
                                   
        cv2.imshow(r'img',img_raw)
        out.write(img_raw)        
        
        with open(root+r'_trackTrace.csv','a') as f:
            f.write(line)            
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        
    cap.release()
    print(temp_percent)        

print("Processing Done!")
cv2.destroyAllWindows()
out.release()
