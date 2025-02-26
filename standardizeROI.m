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
[surf1, msurf] = extractSphereROI(r, sub_coord_target, middle_gm_surf);

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

disp([newline '-------------------------------------------------'])
disp('--- Efield paramemeters for input coordinate ----')
disp('-------------------------------------------------')
disp(['Avg. Efield Magnitude: ', num2str(avg_field_roi_E_magn_target), ' V/m'])
disp(['Number of elements: ', num2str(numnodes(1)), newline])

disp([newline '-------------------------------------------------'])
disp('--- Efield paramemeters after standardizeROI ----')
disp('-------------------------------------------------')
disp(['Avg. Efield Magnitude: ', num2str(avg_field_roi_E_magn_target_adj), ' V/m'])
disp(['Number of elements: ', num2str(numnodes(2))])

% plots

if strcmp(input.plot_display, 'yes')

    figure,
    subplot(121)
    subtitle(['Raw Target: ', num2str(avg_field_roi_E_magn_target), 'V/m'])
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    %mesh_show_surface(m_roi_elem_target,'showSurface',true,'surfaceColor',[1 0 0],'haxis',gca);
    drawROI(sub_coord_target, input.radius, 'r')
    view(-1.603900050839838,45.710847384029769)

    subplot(122)
    subtitle(['StandardizeROI target: ', num2str(avg_field_roi_E_magn_target_adj),'V/m'])
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    %mesh_show_surface(m_roi_elem_target_adj,'showSurface',true,'surfaceColor',[0 1 0],'haxis',gca);
    drawROI(sub_coord_target_adj, input.radius,'b')
    view(-1.603900050839838,45.710847384029769)
    %%view(60,60)%rotate(h,[1 0 0],25)




    % another view

    figure,
    subplot(121)
    subtitle('Raw Target')
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.5 0.5 0.5], 'facealpha', 0.5,'haxis',gca);
    %mesh_show_surface(m_roi_elem_target,'showSurface',true,'surfaceColor',[1 0 0],'haxis',gca);
    %drawROI(sub_coord_target, 10)
    lighting gouraud
    hlight=camlight('headlight');
    set(gca,'UserData',hlight);
    view(-1.239850434788998e+02,35.608441171615468)

    subplot(122)
    subtitle('StandardizeROI target')
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.5 0.5 0.5], 'facealpha', 0.5,'haxis',gca);
    mesh_show_surface(m_roi_elem_target_adj,'showSurface',true,'surfaceColor',[0 0 1],'haxis',gca);
    %drawROI(sub_coord_target_adj, 10)
    view(-1.239850434788998e+02,35.608441171615468)
    %view(60,60)%rotate(h,[1 0 0],25)


    % Fig 1.A

    figure,
    %subplot(121)
    subtitle('Raw Target')
    mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    %mesh_show_surface(m_roi_elem_target,'showSurface',true,'surfaceColor',[1 0 0],'haxis',gca);
    drawROI(sub_coord_target, 1, 'r')
    view(-1.603900050839838,45.710847384029769)

    %subplot(122)
    %subtitle('StandardizeROI target')
    %mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
    %mesh_show_surface(m_roi_elem_target_adj,'showSurface',true,'surfaceColor',[0 1 0],'haxis',gca);
    drawROI(sub_coord_target_adj, 1,'b')
    %drawROI(vm, 1,'g')
    view(-1.603900050839838,45.710847384029769)
    %%view(60,60)%rotate(h,[1 0 0],25)

end
end
