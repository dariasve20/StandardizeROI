function standardizeROI(input)
% ADDME test

% Define surf and load surface overlay .msh file
middle_gm_surf = mesh_load_gmsh4(input.mesh);

% check the coordinate system. All calculations are done in Subject space

if strcmp(input.coord_system, 'MNI')
    sub_coord_target = mni2subject_coords(input.target_coordinate, fullfile(pwd));
elseif strcmp(input.coord_system, 'Subject')
    sub_coord_target = input.target_coordinate;
end

% calculate the euclidian distance from the input coordinate to the middle gray matter surface.
% return the minimum distance
sub_coord_target_adj = findClosest3DCoord(middle_gm_surf.nodes, sub_coord_target);

% Extract spherical ROI using the input coordinate
[roi_elem_target, m_roi_elem_target] = extractSphereROI(input.radius, sub_coord_target, middle_gm_surf);

% Extract spherical ROI using coordinate after adjustment
[roi_elem_target_adj, m_roi_elem_target_adj] = extractSphereROI(input.radius, sub_coord_target_adj, middle_gm_surf);

% extract a section of gray matter for visualization
r = input.radius*4.5;
[~, msurf] = extractSphereROI(r, sub_coord_target, middle_gm_surf);

% Calculate average e-field magnitude

nodes_areas = mesh_get_node_areas(middle_gm_surf);

% calculate the average E-field magnitude
field_name = 'E_magn';
field_idx = get_field_idx(middle_gm_surf, field_name, 'node');
field_E_magn = middle_gm_surf.node_data{field_idx}.data;

avg_field_roi_E_magn_target = sum(field_E_magn(roi_elem_target) .* nodes_areas(roi_elem_target))/sum(nodes_areas(roi_elem_target));
avg_field_roi_E_magn_target_adj = sum(field_E_magn(roi_elem_target_adj) .* nodes_areas(roi_elem_target_adj))/sum(nodes_areas(roi_elem_target_adj));

efield = [avg_field_roi_E_magn_target
    avg_field_roi_E_magn_target_adj];

numnodes = [length(m_roi_elem_target.nodes) length(m_roi_elem_target_adj.nodes)];

% output results in the command window

text_input = ['Raw target ', newline, 'Avg. Efield Magn : ', num2str(avg_field_roi_E_magn_target),' V/m', newline, 'N of elements: ', num2str(numnodes(1)), newline];

disp([newline '-------------------------------------------------'])
disp('--- Efield paramemeters for input coordinate ----')
disp('-------------------------------------------------')
disp(text_input)


text_stdROI = ['StandardizeROI target ', newline, 'Avg. Efield Magn : ', num2str(avg_field_roi_E_magn_target_adj),' V/m', newline, 'N of elements: ', num2str(numnodes(2)), newline];

disp([newline '-------------------------------------------------'])
disp('--- Efield paramemeters after standardizeROI ----')
disp('-------------------------------------------------')
disp(text_stdROI)


% plots

if strcmp(input.plot_display, 'yes')

    figure,
    subtitle('Coodinates relative to the graymatter mesh')
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    drawROI(sub_coord_target, 1, 'r')
    view(-1.6, 45.7)

    drawROI(sub_coord_target_adj, 1,'b')
    view(-1.6, 45.7)
  

    figure,
    subplot(121)
    subtitle(text_input)
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    drawROI(sub_coord_target, input.radius, 'r')
    view(-1.6, 45.7)

    subplot(122)
    subtitle(text_stdROI)
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    drawROI(sub_coord_target_adj, input.radius,'b')
    view(-1.6, 45.7)


    figure,
    subplot(121)
    subtitle(text_input)
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.5 0.5 0.5], 'facealpha', 0.5,'haxis',gca);
    try
        mesh_show_surface(m_roi_elem_target,'showSurface',true,'surfaceColor',[1 0 0],'haxis',gca);
    catch
        warning('There is no enough elements to display surface')
          lighting gouraud
          hlight=camlight('headlight');
          set(gca,'UserData',hlight);
    end
  
    view(-1.23e+02, 35.6)

    subplot(122)
    subtitle(text_stdROI)
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.5 0.5 0.5], 'facealpha', 0.5,'haxis',gca);
    mesh_show_surface(m_roi_elem_target_adj,'showSurface',true,'surfaceColor',[0 0 1],'haxis',gca);
    view(-1.23e+02, 35.6)



end
end
