%% Example to test standardizeROI
%-------------------------------
% Diego E. Arias, PhD Feb 2025            
%-------------------------------

%close all
clearvars
clc

% make sure you add simNIBS to the path (use your own path)
addpath('.../Applications/SimNIBS-4.1/simnibs_env/lib/python3.9/site-packages/simnibs/matlab_tools');

% make sure you add standardizeROI to the path
addpath('.../StandarizeROI')
addpath '.../StandarizeROI/functions'

% create input struct required by standardizeROI

input.coord_system = 'MNI'; % or 'Subject 
input.target_coordinate = [-46,45,38]; % Fitzgerald Target in MNI space for DLPFC from Fox et al...
input.plot_display = 'yes'; % or 'no'
input.radius = 10; % define a spherical ROI of 10 mm radius

% add your own mesh
input.mesh = 'your_simulation.msh';

[coords, params_raw, params_adj] = standardizeROI(input);

