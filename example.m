%% Example to test standardizeROI
%-------------------------------
% Diego E. Arias, Feb 2025            
%-------------------------------

close all
clearvars
clc

% create struct required by standarizeROI

input.coord_system = 'MNI'; % or 'Subject 
input.target_coordinate = [-46,45,38]; % Fitzgerald Target in MNI space for DLPFC from Fox et al...
input.plot_display = 'yes'; % or 'no'
input.radius = 10; % define a spherical ROI of 10 mm radius

% add your own mesh
input.mesh = '/Users/ariasd/Library/CloudStorage/OneDrive-MedicalUniversityofSouthCarolina/Documents/GitHub/StandarizeROI/NA111_41/m2m_NA111_41/BA46/subject_overlays/NA111_41_TMS_1-0001_MagVenture_Cool-B65_scalar_central.msh';

standardizeROI(input)