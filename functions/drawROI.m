function drawROI(roi_center, radius, color)

% Define the ROI center in MNI space (or subject space if applicable)

% Create a r mm radius sphere
[x_sphere, y_sphere, z_sphere] = sphere; % Default unit sphere

% Adjust sphere location to the ROI center
x_sphere = radius * x_sphere + roi_center(1);
y_sphere = radius * y_sphere + roi_center(2);
z_sphere = radius * z_sphere + roi_center(3);

% Plot the sphere
surf(x_sphere, y_sphere, z_sphere, 'EdgeColor', 'none', 'FaceColor', color, 'FaceAlpha', 0.3,'FaceLighting', 'gouraud');
end