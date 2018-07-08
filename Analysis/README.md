[//]: # (Analysis pipeline for Calcium Imaging BMI scripts)



# CaBMI Analysis Guide
In-development Calcium imaging BMI analysis scripts for 2P imaging.

## Overview: Getting ROI data

raw data is stored as individual .tif files for every frame.


### Method 1: Automated Extraction using CaImAn Package

The main processing script is a wrapper for the demo version of the CaImIn scripts:
https://github.com/flatironinstitute/CaImAn-MATLAB

1P uses CNMF-E
https://github.com/flatironinstitute/CaImAn-MATLAB/tree/master/endoscope



Here is the main class function:

```
>> [ROI, roi_ave] = CaBMI_Process(BMI_data,'method','1P')
```

To run through and process an entire directory, use this function:

```
>> Automation_overview
```




### Method 2: Manual ROI selection

```
>> ROI = CaBMI_annotate_image(ROI)
```

```
>> roi_ave= CaBMI_plot_roi(ROI,varargin)
```


-----------------------------
Both methods will make a  few fields:

```
% ROI data:

ROI.coordinates
ROI.stats
ROI.type
ROI.reference_image

% ROI Timeseries Data  ( roi_ave )

roi_ave.
roi_ave.
roi_ave.
roi_ave.


% TData

TData.toc
TData.ROI_val
TData.cursor_actual_A
TData.cursor_actual_B
TData.cursor
TData.ROI_dff
TData.hit
TData.cursorA
TData.cursorB

```



## Basic Analysis Scripts
