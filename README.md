# MesoBrain
[![biorXiv](https://img.shields.io/badge/biorXiv-10.1101%2F2021.07.21.453083-red)](https://www.biorxiv.org/content/10.1101/2024.09.10.612344v4)

This matlab script is compatible with modern versions of the matlab platform (later than Matlab 2020), depending on the "Signal Processing" toolbox. 

Inputs: 
- dFF0: 3D matrix (2D space x time) that contain a time stack of cortex calcium imaging fluorescence data (dF/F).
- Mask: Binary image mask that defines the contour of the cortical window. 

Outputs: 
- Waves: an object containing individual wave instances detected on the time stack, that encompass a description of the individual trajectories (x,y), onset time (t0), and strength of the fluorescence at the local maximum.

Demo: 
Example data (mask and time stacks) are provided in the Demos folder. Additional data is provided in the following Zenodo archive: https://zenodo.org/records/17900730
