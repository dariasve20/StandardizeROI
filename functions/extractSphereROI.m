% extract ROI
% r: radius
% sub_roi_center: center coordinates in native space
% graymatter: graymatter surface

function [roi, m_roi, n_elements] = extractSphereROI(r, sub_roi_center, gray_matter)

if isempty(gray_matter.element_data)
    roi = sqrt(sum(bsxfun(@minus, gray_matter.nodes, sub_roi_center).^2, 2)) < r;
    m_roi = mesh_extract_regions(gray_matter, 'node_idx', roi);
    n_elements = length(m_roi.nodes);
else
    elm_centers = mesh_get_tetrahedron_centers(gray_matter);
    roi = sqrt(sum(bsxfun(@minus, elm_centers, sub_roi_center).^2, 2)) < r;
    m_roi = mesh_extract_regions(gray_matter, 'tet_idx', roi);
    n_elements = length(m_roi.tetrahedra);
    %m_roi = mesh_get_tetrahedron_sizes(gray_matter);
end

