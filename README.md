# 2022_AntibodyCatenatedOnSurface

Title: DeepIS : Deep-learning based three-dimensional label-free tracking and analysis of immunological synapses of CAR-T cells

Authors: Moosung Lee, Young-Ho Lee, Jinyeop Song, Geon Kima, YoungJu Joa, HyunSeok Mine, Chan Hyuk Kimc, and YongKeun Park.

Link: https://www.biorxiv.org/content/10.1101/539858v2

This is the ReadMefor the DeepIS pipeline in the above paper. 

ReadMe Author: Jinyeop Song

## Overview

### Workflow

![img/fig1.png](img/fig1.png)


DeepIS is an DCNN supervised learning method to enable general, high-throughput, and automated segmentation for 3D Refractive Index(RI) tomograms. We applied this framework to perform Immunological Synnapse segmentation from raw 3D RI tomographic videos of immune response between CART19 and K562-CD19 cells. 

### Datset Preparation

The dataset is composed of 3D RI tomogram(input) and annotation of cell masks(label). To annotate the 3D masks of the CART19 and K562-CD19 cells, we first applied a combination of image processing and the watershed algorithm to a raw RI tomogram. Among the outcomes, 236 pairs of well-annotated 3D tomograms were finally chosen with consensus by three experts in cellular biology. The detailed procedure for dataset preparation is described in the manuscript. 

### Model Architecture

![img/fig2.png](img/fig2.png)

This deep neural network is implemented with pytorch. The architecture has the contracting path consisting of ResNet blocks and down-pooling layers and the expanding path consisting of convolutional layers and up-pooling layers. Features are passed from the contracting path and to the expanding path through global convolutional network (GCN) layers. The number of features for each level is 32, 64, 128, 256, 512 respectively.

Input file and output file should be 128*128*64.

## How to use

### Dependencies
* Tensorflow
* Keras >= 1.0
* Python >= 3.6
* scikit-image >= 0.14.2


### Run main_DeepIS.py

Before running the main code, "fpath_input" and "fpath_ouput" variables must be set properly.

    python3 main_DeepIS.py --feature_scale 1 --gpus 2,3 --test 1
       
### Results

Use the trained model to do segmentation on test images, the result is statisfactory.

![img/fig3.png](img/fig3.png)

