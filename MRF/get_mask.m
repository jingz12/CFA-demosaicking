function [mask_r,mask_g,mask_b] = get_mask(img_cfa)
[sizey,sizex,~] = size(img);
mask_r = zeros(sizey,sizex);
mask_g = zeros(sizey,sizex);
mask_b = zeros(sizey,sizex);
locs_r = find(img_cfa(:,:,1) ~= 0);
locs_g = find(img_cfa(:,:,2) ~= 0);
locs_b = find(img_cfa(:,:,3) ~= 0);
mask_r(locs_r) = 1;
mask_g(locs_g) = 1;
mask_b(locs_b) = 1;
end

