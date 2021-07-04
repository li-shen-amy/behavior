# Procedure:
## (1)	Connect Arduino to computer and infrared beam to detect nosepoke with input pin (13 by default).
## (2)	Set configuration in “SelfStimulation.ino”, program the Arduino:
```.cpp
const int InputPin=13;  // pin connected to infrared beam to detect nosepoke
const int PowerPin=6; // pin connected to stimulation
const int DetectInt=500;  // interval for detection
const int RewardDur=1000; // reward duration 
const int OnDur=20; // Stimulus On duration
const int OffDur=30; // Stimulus Off duration
```
## (3)	Set configurations in _“Export_nosepoking.py”_
Set the correct serial port and output filename:
```.cpp
ser = serial.Serial('/dev/cu.usbmodem14201',9600)
```
```.cpp
    with open('nosepoking.csv','a') as f:
 ```
## (4)	Run.
Set up camera, record the video and run _“Export_nosepoking.py”_.
## (5)	Align timestamp.
After experiment, align the first detected timestamp (shown as “1” in the output file) with the first nosepoke timestamp recorded in video.
