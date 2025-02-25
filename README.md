This is **StandardizeROI**, a **MATLAB** script that helps to standardize the ROI extraction for e-field calculation when using **SimNIBS** pipeline. There are cases when coordinates obtained from the literature fall outside the gray matter layer. This causes ROI to extract few data from superficial regions, overestimating the average e-field magnitude. This simple script takes as input a coordinate of interest in either MNI or native subject space and returns the closest gray matter surface from the coordinate of interest using the Euclidean distance formula. This adjustment of the ROI placement provides a more consistent approach that allows calculating the average e-field in an ROI based on a similar amount of mesh elements (tetrahedra or nodes) between and within subjects.


![Presentation1](https://github.com/user-attachments/assets/d1897d75-5a90-40f1-8344-b2ea2b30e287)

## How to use it

StandarizeROI receives a coordinate in either MNI and Subject space, a mesh from the SimNIBS **simulation output** (either the tetahedral mesh or the middle gray surface). We recommend to use the middle gray surface given that if the tetahedral mesh is no cleaned, might produced issues as the one below (you always can clean the mesh a reran StandarizeROI). 

Example:
```
input.coord_system = 'MNI' % or 'Subject'
input.target_coordinate = [-46, 45, 38] % Fitzgerald Target for DLPFC from Fox et al...
input.mesh = '/mesh.msh'
input.radius = 10 % spherical ROI of 10 mm radius
 
```

The ouput will be a plot (optional), with the adjusted coordinate, the average e-field magnitude, normal and tangential componennts (only if the middle gray matter surface was used as input), or just the average e-field magnitude for a tetahedral mesh.

## How to cite


Contributors:

- Diego E. Arias
- Christopher T. Sege
- Lisa M. McTeague
- Kirstin-Friederike Heise
- Kevin A. Caulfield
