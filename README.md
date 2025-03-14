# Getting Started With the Pipeline

This repository contains the pipeline codes for the Post-operative-recovery project. This pipeline includes data processing and analysis, organized by **Python** and **MATLAB**.

## Installation

Please install the dependencies using: 

​`pip install -r environment.txt`

## Datasets

* The entire dataset, which includes the extracted neuronal traces of 3 mice, will be open-sourced after publication. The transgenic mice consisted of three types: Cx3Cr1-GFP mice (for microglia labeling), Rasgrf2-2A-DCre/Ai148D mice (for neuronal labeling with GCaMP6f in layers 2/3) and Thy1-YFP mice (for neuronal morphology labeling).

## Usage

These codes are tested under Python 3.8.15 and MATLAB R2019a. The pipeline consists of the following sections:
  <br/>

### 1. Functional Analysis

#### 1) Active neuron selection

  * '**/step_01_neuron_selection_mouseXX_dayXX.ipynb**': Select the neuronal populations in response to visual stimuli.

#### 2) Data analysis of single mouse on a single day

  * '**/step_02_statistics_mouseXX_dayXX.ipynb**': Analyzing the functional responsiveness of a single rat on a given day.

#### 3) Data analysis of single mouse on multiple days

  * '**/step_03_data_analysis_mouseXX_multiple_days.ipynb**': Analyzing the evolution of functional responsiveness in a single rat over days 1-56.

#### 4) Data analysis of all mice on multiple days

  * '**/step_04_data_analysis_multiple_mice_and_days.ipynb**': Characterizing the overall evolution of functional responsiveness in multiple rats over days 1-56.

### 2. Dynamic Correlation Analysis

'**/step_05_dynamic_correlation_analysis.m**': performs a dynamic correlation analysis between two time-series datasets. The code is organized as the following structure: 

#### 1) Parameter Settings
  * Defines window widths and the correlation test method.
  
#### 2) Read Data from Excel
  * Reads time data, header names (from C3 and H3), and the raw measurement data for each variable from the Excel file.

#### 3) Interpolate and Smooth Data
  * Generates a continuous time vector, performs linear interpolation, and applies a moving average for smoothing.
  
#### 4) Correlation Analysis
  * Uses a fixed window for one variable and a sliding window for the other variable to compute the correlation coefficients and p-values.
  
#### 5) Visualize Results
  * Plots the interpolated/smoothed data, the correlation coefficients versus window lag, and the p-values versus window lag (including a reference significance line).
  
#### 6) Interpret Results
  * Prints an interpretation of the correlation analysis results to the command window.
  <br/>
