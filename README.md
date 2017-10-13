# CaBMI
In-development Calcium imaging BMI scripts for 2P imaging.

## Overview

Scripts for the on-line analysis of user defined regions of interest (ROIs) for
mice Brain Machine Interface (BMI) experiments.

## Hardware Prerequisites

These functions are dependent on the proprietary Bruker 2P (Ultima) Microscope interface,
which by current design is not 'real time', and is highly susceptible to delays
like OS scheduling, etc. that increase jitter in the on-line analysis
and feedback deployment. Most software prototyping is in MATLAB.

 ATM the hardware output is an NI 3009 usb device.



## Basic Pipeline


Connect to the Microscope over matlab via PrairieLink:

```
pl = actxserver('PrairieLink.Application');
pl.Connect();
pl.SendScriptCommands('-lbs true 5')
```

Connect to NiDaq via the session interface in MATLAB

```
s = daq.createSession('ni');
s.Rate = 8000; % up the sampling rate
addDigitalChannel(s,'Dev5','port0/line1','OutputOnly')
```

Collect 100 frames of data for a baseline:

```
% Collect Baseline Data
max_frame = 100;
[Im1] = caBMI_pullPixel(pl,s,max_frame)
```


Create a Reference Image, and Manually select Regions of Interest:
```
% Selec ROIs & Save reference image
Ref_Im = uint16(mean(Im1,3));
imwrite(uint16(mean(Im1,3)),'Ref_Im.tif');
[ROI] = caBMI_annotate_image('Ref_Im.tif');
```



Plot these ROIs, and the underlying time series:
```
caBMI_refPlot(ROI,Im1)
```

ROIs are color coded:
![ScreenShot](images/ROIs_1.jpg)
The resulting Time-series for each ROI, with color matching the ROI Map above:
![ScreenShot](images/ROIs_2.jpg)
