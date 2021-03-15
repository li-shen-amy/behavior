<p align="center">
  <img src="https://li-shen-amy.github.io/profile/images/projects/behavior.jpg" />
</p>

# Behavior toolbox

## Lick Detection
This python toolbox is for automatically detect rodent licking from video data.
Required packages: numpy, cv2, tkinter, os (python3)
Processing pipeline: 
- Select and Open the movie files
- Select the Region of Interest (ROI) interactively: areas contain tongue image (and trigger LED signal if needed)
- Average gray scale within ROI
- (Optional) Thresholding, Average, Standard-Deviation 
- Save index to Excel file (real-time)

## Self Stimulation
A behavior box for self-stimulation test: LED stimulation was triggered whenever the animal nose-poked the designated LED-on port, whereas nose-poking the other port did not trigger any photostimulation.
Details: Mice were placed in an operant box equipped with two ports for nose poke at symmetrical locations on one of the cage walls. The ports were connected to a photo-beam detection device allowing for measurements of responses. A valid nose poke at the LED-on port lasting for at least 500 ms triggered a 1 sec long 20 Hz (5-ms pulse duration) LED pulse train delivery controlled by an Arduino microcontroller. The LED-on port was randomly assigned and balanced within the group of tested animals. The test lasted for 40 mins. Video and time stamps associated with nose poke and laser events were saved in a computer file for post hoc analysis.

## Real-Time Animal Tracking (Cooperative project)
<p align="center">
  <img src="https://github.com/GuangWei-Zhang/TraCon-Toolbox/raw/master/Images/Architecture.jpg" />
</p>
<p align="center">
  <img src="
https://github.com/GuangWei-Zhang/TraCon-Toolbox/raw/master/Gif_folder/demo_1.gif" />
</p>
Paper: Guang-Wei Zhang, Li Shen, Zhong Li,  View ORCID ProfileHuizhong W. Tao, Li I. Zhang (2019). Track-Control, an automatic video-based real-time closed-loop behavioral control toolbox.bioRxiv. doi: https://doi.org/10.1101/2019.12.11.873372

Toolbox: https://github.com/GuangWei-Zhang/TraCon-Toolbox/
