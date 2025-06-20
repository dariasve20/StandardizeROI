This is **StandardizeROI**, a **MATLAB** script that helps to standardize the ROI extraction for e-field calculation when using **SimNIBS** pipeline. There are cases when coordinates obtained from the literature fall outside the gray matter layer. This causes ROI to extract few data from superficial regions, overestimating the average e-field magnitude. This simple script takes as input a coordinate of interest in either MNI or native subject space and returns the closest gray matter surface from the coordinate of interest using the Euclidean distance formula. This adjustment of the ROI placement provides a more consistent approach that allows calculating the average e-field in an ROI based on a similar amount of mesh elements (tetrahedra or nodes) between and within subjects.

![Presentation1](https://github.com/user-attachments/assets/d1897d75-5a90-40f1-8344-b2ea2b30e287)

## How to use it

**StandardizeROI** receives a coordinate in either MNI or subject space, the radius that defines a spherical ROI, and a mesh from the SimNIBS simulation output (either the tetrahedral mesh or the middle gray surface). We recommend using the middle gray surface, as an uncleaned tetrahedral mesh might produce issues like the one below (you can always clean the mesh and rerun StandardizeROI).

Example:
```
input.coord_system = 'MNI' % or 'Subject'
input.target_coordinate = [-46, 45, 38] % Fitzgerald Target in MNI space for DLPFC from Fox et al...
input.mesh = '/mesh.msh'
input.radius = 10 % spherical ROI of 10 mm radius
input.plot_display = 'yes' %

standardizeROI(input);
 
```

**StandardizeROI** will plot (optional) the input and adjusted coordinates positioned relative to the gray matter. It will also ouput the average e-field magnitude, normal and tangential componennts (only if the middle gray matter surface was used as input), or just the average e-field magnitude for a tetahedral mesh. Finally, it will output the number of mesh elements used to calculate the e-field parameters.

## Dependencies

MATLAB and SimNIBS needs to be installed.

## Contigencies

We used code from other projects:

https://github.com/SVH35/GetTissueThickness

https://github.com/simnibs/simnibs

## How to cite
D. E. Arias, C. T. Sege, L. M. McTeague, K.-F. Heise, and K. A. Caulfield, “Standardizing ROI placement significantly increases the within- and between-subject reliability of electric field models,” Brain Stimulation, vol. 18, no. 4, pp. 1137–1140, Jul. 2025, doi: https://doi.org/10.1016/j.brs.2025.05.135


## Contributors:

- Diego E. Arias
- Christopher T. Sege
- Lisa M. McTeague
- Kirstin-Friederike Heise
- Kevin A. Caulfield


