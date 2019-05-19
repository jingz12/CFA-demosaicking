%% get cfa image
function [img1_cfa,mask_cfa]= get_cfa(img1)
[size_y,size_x,size_n] = size(img1);
img1_r = zeros(size_y,size_x);mask_r = img1_r;
img1_g = zeros(size_y,size_x);mask_g = img1_g;
img1_b = zeros(size_y,size_x);mask_b = img1_b;
for ii = 1:size_y
    for jj = 1:size_x
        if (mod(ii,2)==1)&&(mod(jj,2)==0)
            img1_r(ii,jj) = img1(ii,jj,1);
            mask_r(ii,jj) = 1;
        elseif (mod(ii,2)==0)&&(mod(jj,2)==1)
            img1_b(ii,jj) = img1(ii,jj,3);
            mask_b(ii,jj) = 1;
        elseif ((mod(ii,2)==0)&&(mod(jj,2)==0))||((mod(ii,2)==1)&&(mod(jj,2)==1))
            img1_g(ii,jj) = img1(ii,jj,2);
            mask_g(ii,jj) = 1;
        end
    end
end
img1_cfa = zeros([size_y,size_x,size_n]);mask_cfa = img1_cfa;
img1_cfa(:,:,1) = img1_r;img1_cfa(:,:,2) = img1_g;img1_cfa(:,:,3) = img1_b;
mask_cfa(:,:,1) = mask_r;mask_cfa(:,:,2) = mask_g;mask_cfa(:,:,3) = mask_b;
% imshow(img1_cfa./255)