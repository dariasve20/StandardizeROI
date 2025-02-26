% extract ROI
% r: radius
% sub_roi_center: center coordinates in native space
% graymatter: graymatter surface

function [roi, m_roi] = extractSphereROI(r, sub_roi_center, gray_matter)

roi = sqrt(sum(bsxfun(@minus, gray_matter.nodes, sub_roi_center).^2, 2)) < r;

m_roi = mesh_extract_regions(gray_matter, 'node_idx', roi);

end

