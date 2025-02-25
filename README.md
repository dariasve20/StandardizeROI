This is **StandardizeROI**, a **MATLAB** script that helps to standardize the ROI extraction for e-field calculation when using **SimNIBS** pipeline. There are cases when coordinates obtained from the literature fall outside the gray matter layer. This causes ROI to extract few data from superficial regions, overestimating the average e-field magnitude. This simple script takes as input a coordinate of interest in either MNI or native subject space and returns the closest gray matter surface from the coordinate of interest using the Euclidean distance formula. This adjustment of the ROI placement provides a more consistent approach that allows calculating the average e-field in an ROI based on a similar amount of mesh elements (tetrahedra or nodes) between and within subjects.


![Presentation1](https://github.com/user-attachments/assets/d1897d75-5a90-40f1-8344-b2ea2b30e287)

#How to use it:


#How to cite:


Contributors:

- Diego E. Arias
- Christopher T. Sege
- Lisa M. McTeague
- Kirstin-Friederike Heise
- Kevin A. Caulfield
