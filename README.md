This is StandardizeROI, a matlab script that helps to standarized the ROI extraction for e-field calculation. There are cases when coordinates obtained from the literature fall outside the gray matter layer. This produce that ROI-estimations extract few data from superficial regiones overstimating the avg e-field magnitude. This simple scripts takes as an input a coordinate of interest in either MNI or native subject space and return the closest gray matter surface from the coordinate of interest using the euclidian distance formula. This adjustment of the ROI placement provide a more consisten approach that allows to calculate the avg. e-field in an ROI based on a similar amount of mesh elements (tetahedra or nodes) between and within subjects.

If this hapen to help you, please cite:


Contributors

- Diego E. Arias
- Kevin A. Caulfield
