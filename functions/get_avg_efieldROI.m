function [ef_results] = get_avg_efieldROI(type_element, gm_surf, roi_elem)

if strcmp(type_element,'node')

    nodes_areas = mesh_get_node_areas(gm_surf);

    %calculate the average E-field magnitude based on nodes elements
    field_name = 'E_magn';
    field_idx = get_field_idx(gm_surf, field_name, 'node');
    field_E_magn = gm_surf.node_data{field_idx}.data;

    %Extract E_normal
    field_name = 'E_normal';
    field_idx = get_field_idx(gm_surf, field_name, 'node');
    field_E_normal = gm_surf.node_data{field_idx}.data;

    % Extract E_tangent
    field_name = 'E_tangent';
    field_idx = get_field_idx(gm_surf, field_name, 'node');
    field_E_tangent = gm_surf.node_data{field_idx}.data;


    % return avg e-field magnitude, normal, and tangential components 

    sum_e_magn = field_E_magn(roi_elem) .* nodes_areas(roi_elem);
    sum_e_norm = field_E_normal(roi_elem) .* nodes_areas(roi_elem);
    sum_e_tang = field_E_tangent(roi_elem) .* nodes_areas(roi_elem);

    ef_results.avg_roi_E_magn = sum(sum_e_magn)/sum(nodes_areas(roi_elem));
    ef_results.avg_roi_E_normal = sum(sum_e_norm)/sum(nodes_areas(roi_elem));
    ef_results.avg_roi_E_tangent = sum(sum_e_tang)/sum(nodes_areas(roi_elem));

    ef_results.sum_e_magn = sum_e_magn;
    ef_results.sum_e_norm = sum_e_norm;
    ef_results.sum_e_tang = sum_e_tang;

else

    elm_vols = mesh_get_tetrahedron_sizes(gm_surf);
    
    % calculate the average E-field magnitude based on tetrahedral elements
    field_name = 'magnE';
    field_idx = get_field_idx(gm_surf, field_name, 'elements');
    field_E_magn = gm_surf.element_data{field_idx}.tetdata;

    % return avg e-field magnitude 
    ef_results.avg_roi_E_magn = sum(field_E_magn(roi_elem) .* elm_vols(roi_elem))/sum(elm_vols(roi_elem));
  
end

end