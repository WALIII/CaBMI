# CaBMI
In-development Calcium imaging BMI scripts for 2P imaging.

## Overview

Scripts for the on-line analysis of user defined regions of interest (ROIs) for
mice Brain Machine Interface (BMI) experiments.

## Hardware Prerequisites

These functions are dependent on the proprietary Bruker 2P (Ultima) Microscope interface,
which by current design is not 'real time', and is highly susceptible to delays
like OS scheduling, etc. that increase jitter in the on-line analysis
and feedback deployment.

 ATM the hardware output is an NI 3009 usb device.
