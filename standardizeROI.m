function standardizeROI(input)
% ADDME test

% check the coordinate system. All calculations are done in Subject space

if strcmp(input.coord_system, 'MNI')
    sub_coord_target = mni2subject_coords(input.target_coordinate, fullfile(pwd));
elseif strcmp(input.coord_system, 'Subject')
    sub_coord_target = input.target_coordinate;
end

% Define surf and load surface overlay .msh file
gm_surf = mesh_load_gmsh4(input.mesh);


if isempty(gm_surf.element_data)
    % mesh is composed of nodes (overlay surface)
    type_element = 'node';

    % calculate the euclidian distance from the input coordinate to the gray matter mesh.
    % return the closest coordinate in contact with the gray matter
    % surface.

    % findClosest3DCoord extracted from GTT package. 
    % For more information: https://github.com/SVH35/GetTissueThickness
    sub_coord_target_adj = findClosest3DCoord(gm_surf.nodes, sub_coord_target);

else
    % mesh is composed of tetrahedra.
    type_element='tetrahedra';
    gm_surf = mesh_extract_regions(gm_surf, 'region_idx', 2);

    elm_centers = mesh_get_tetrahedron_centers(gm_surf);
    sub_coord_target_adj = findClosest3DCoord(elm_centers, sub_coord_target);
    
end


% Extract spherical ROI using the input coordinate
[roi_elem_target, m_roi_elem_target, n_elem_target] = extractSphereROI(input.radius, sub_coord_target, gm_surf);

% Extract spherical ROI using coordinate after adjustment
[roi_elem_target_adj, m_roi_elem_target_adj, n_elem_target_adj] = extractSphereROI(input.radius, sub_coord_target_adj, gm_surf);

% extract a section of gray matter for visualization
r = input.radius*5;
[~, msurf] = extractSphereROI(r, sub_coord_target_adj, gm_surf);


% Calculate e-field parameters: avg e-field magnitude and number of
% elements used in its calculation

% e-field for raw coordinate
e_field_target = get_avg_efieldROI(type_element, gm_surf, roi_elem_target);


% e-field after adjustment
e_field_target_adj = get_avg_efieldROI(type_element, gm_surf, roi_elem_target_adj);



% output results in the command window


if length(fieldnames(e_field_target_adj)) > 1

    text_input = ['Raw target ', newline, 'Avg. Efield Magn : ', num2str(e_field_target.avg_roi_E_magn),' V/m',...
        newline, 'Avg. normal component : ', num2str(e_field_target.avg_roi_E_normal),' V/m',...
        newline, 'Avg. tangential component : ', num2str(e_field_target.avg_roi_E_tangent),' V/m',...
        newline, 'N of elements: ', num2str(n_elem_target), newline];
    
    text_stdROI = ['StandardizeROI target ', newline, 'Avg. Efield Magn : ', num2str(e_field_target_adj.avg_roi_E_magn),' V/m',...
        newline, 'Avg. normal component : ', num2str(e_field_target_adj.avg_roi_E_normal),' V/m',...
        newline, 'Avg. tangential component : ', num2str(e_field_target_adj.avg_roi_E_tangent),' V/m',...
        newline, 'N of elements: ', num2str(n_elem_target_adj), newline];
else

    text_input = ['Raw target ', newline, 'Avg. Efield Magn : ', num2str(e_field_target.avg_roi_E_magn),' V/m',...
        newline, 'N of elements: ', num2str(n_elem_target), newline];
    
    text_stdROI = ['StandardizeROI target ', newline, 'Avg. Efield Magn : ', num2str(e_field_target_adj.avg_roi_E_magn),' V/m',...
        newline, 'N of elements: ', num2str(n_elem_target_adj), newline];
end

disp(['Mesh elements:', type_element])
disp([newline '-------------------------------------------------'])
disp('--- Efield paramemeters for input coordinate ----')
disp('-------------------------------------------------')
disp(text_input)
disp([newline '-------------------------------------------------'])
disp('--- Efield paramemeters after standardizeROI ----')
disp('-------------------------------------------------')
disp(text_stdROI)

% plots

if strcmp(input.plot_display, 'yes')

    if strcmp(type_element,'node')

        %-----------PLOT 1------------%
        figure,
        subtitle('Coodinates relative to the gray matter mesh')
        mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
        view(-1.6, 45.7)
        drawROI(sub_coord_target, 1, 'r')        
        drawROI(sub_coord_target_adj, 1,'b')


        %-----------PLOT 2------------%
        figure,
        subplot(121)
        subtitle(text_input)
        mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
        view(-1.6, 45.7)
        drawROI(sub_coord_target, input.radius, 'r')
       
        subplot(122)
        subtitle(text_stdROI)
        mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.7 0.7 0.7], 'facealpha', 0.5,'haxis',gca);
        view(-1.6, 45.7)
        drawROI(sub_coord_target_adj, input.radius,'b')
        

        %-----------PLOT 3------------%
        figure,
        subplot(121)
        subtitle(text_input)
        mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.5 0.5 0.5], 'facealpha', 0.5,'haxis',gca);
        view(-1.23e+02, 35.6)
        try
            mesh_show_surface(m_roi_elem_target,'showSurface',true,'surfaceColor',[1 0 0],'haxis',gca);
        catch
            warning('There is no enough elements to display surface')
            lighting gouraud
            hlight=camlight('headlight');
            set(gca,'UserData',hlight);
        end

        subplot(122)
        subtitle(text_stdROI)
        mesh_show_surface(msurf,'showSurface',true,'surfaceColor',[0.5 0.5 0.5], 'facealpha', 0.5,'haxis',gca);
        view(-1.23e+02, 35.6)
        mesh_show_surface(m_roi_elem_target_adj,'showSurface',true,'surfaceColor',[0 0 1],'haxis',gca);
        
    else
        
        % create plots based on tetahedral mesh.
        faces = freeBoundary(triangulation(msurf.tetrahedra, msurf.nodes));
        
        %-----------PLOT 1------------%
        figure;
        % plot the subsection of gray matter 
        subtitle('Coodinates relative to the gray matter mesh')
        patch('Faces', faces, 'Vertices', msurf.nodes, ...
            'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        hold on
        % draw the raw coordinate
        drawROI(sub_coord_target, 1, 'r')
        view(-1.6, 45.7)
        % draw the coordinate after the adjustment
        drawROI(sub_coord_target_adj, 1,'b')
        %view(-1.6, 45.7)
        axis equal;
        axis off;
        lighting gouraud
        hlight=camlight('headlight');
        set(gca,'UserData',hlight);
        
        %-----------PLOT 2------------%
        figure,
        subplot(121)
        subtitle(text_input)
        % plot the subsection of gray matter
        patch('Faces', faces, 'Vertices', msurf.nodes, ...
            'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        view(-1.6, 45.7)
        hold on
        drawROI(sub_coord_target, input.radius, 'r')
        axis equal;
        axis off;
        lighting gouraud
        hlight=camlight('headlight');
        set(gca,'UserData',hlight);

        subplot(122)
        subtitle(text_stdROI)
        % plot the subsection of gray matter
        patch('Faces', faces, 'Vertices', msurf.nodes, ...
            'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        hold on
        view(-1.6, 45.7)
        drawROI(sub_coord_target_adj, input.radius,'b')
        axis equal;
        axis off;
        lighting gouraud
        hlight=camlight('headlight');
        set(gca,'UserData',hlight);

        %-----------PLOT 3------------%
        % create plots based on tetahedral mesh.
        

        figure,
        subplot(121)
        subtitle(text_input)
        patch('Faces', faces, 'Vertices', msurf.nodes, ...
            'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        view(-1.23e+02, 35.6)
        axis equal;
        axis off;
        lighting gouraud
        hlight=camlight('headlight');
        set(gca,'UserData',hlight);
        hold on
        try
            faces1 = freeBoundary(triangulation(m_roi_elem_target.tetrahedra, m_roi_elem_target.nodes));
            patch('Faces', faces1, 'Vertices', m_roi_elem_target.nodes, ...
                'FaceColor', [0.7 0 0], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        catch
            warning('There is no enough elements to display surface')
        end
       
        
        % create plots based on tetahedral mesh.
        faces2 = freeBoundary(triangulation(m_roi_elem_target_adj.tetrahedra, m_roi_elem_target_adj.nodes));
        subplot(122)
        subtitle(text_stdROI)
        patch('Faces', faces, 'Vertices', msurf.nodes, ...
                  'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        view(-1.23e+02, 35.6)
        hold on
        patch('Faces', faces2, 'Vertices', m_roi_elem_target_adj.nodes, ...
                'FaceColor', [0 0 0.7], 'EdgeColor', 'none', 'FaceLighting', 'gouraud','facealpha', 0.5);
        axis equal;
        axis off;
        lighting gouraud
        hlight=camlight('headlight');
        set(gca,'UserData',hlight);
        
    end

end
end
