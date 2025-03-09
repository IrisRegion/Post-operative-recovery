# Getting Started With the Pipeline

This repository contains the pipeline codes for the Post-operative-recovery project. This pipeline includes data processing and analysis, organized by **Python** and **MATLAB**.

## Installation

Please install the dependencies using: 

​`pip install -r environment.txt`

## Datasets

* The entire dataset, which includes the extracted neuronal traces of 3 mice, will be open-sourced after publication. The transgenic mice consisted of two types: Cx3Cr1-GFP mice (for microglia labeling) and Rasgrf2-2A-dCre/Ai148D mice (for neuronal labeling with GCaMP6f in layers 2/3).

## Usage

These codes are tested under Python 3.8.15. The pipeline consists of the following sections:

### 1. Active neuron selection

  * '**/step_01_neuron_selection_mouseXX_dayXX.ipynb**': Select the neuronal populations in response to visual stimuli.
  <br/>

### 2. Data analysis of single mouse on a single day

  * '**/step_02_statistics_mouseXX_dayXX.ipynb**': Analyzing the functional responsiveness of a single rat on a given day.
  <br/>

### 3. Data analysis of single mouse on multiple days


  * '**/step_03_data_analysis_mouseXX_multiple_days.ipynb**': Analyzing the evolution of functional responsiveness in a single rat over days 1-56.
  <br/>

### 4. Data analysis of all mice on multiple days

  * '**/step_04_data_analysis_multiple_mice_and_days.ipynb**': Characterizing the overall evolution of functional responsiveness in multiple rats over days 1-56.
  <br/>
