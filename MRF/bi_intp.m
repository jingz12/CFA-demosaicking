%% get bilinear interpolated cfa image
function img_intp = bi_intp(img1_cfa)

[size_y,size_x,size_n] = size(img1_cfa);

img1_r = img1_cfa(:,:,1);img1_g = img1_cfa(:,:,2);img1_b = img1_cfa(:,:,3);

img1_r_intp = img1_r;
img1_b_intp = img1_b;
img1_g_intp = img1_g;
for ii = 2:size_y-1
    for jj = 2:size_x-1
        if (mod(ii,2)==0)&&(mod(jj,2)==0)
            img1_r_intp(ii,jj) = 0.5*(img1_r(ii-1,jj)+img1_r(ii+1,jj));
            img1_b_intp(ii,jj) = 0.5*(img1_b(ii,jj-1)+img1_b(ii,jj+1));
        elseif (mod(ii,2)==1)&&(mod(jj,2)==0)
            img1_b_intp(ii,jj) = 0.25*(img1_b(ii-1,jj-1)+img1_b(ii-1,jj+1)+img1_b(ii+1,jj-1)+img1_b(ii+1,jj+1));
            img1_g_intp(ii,jj) = 0.25*(img1_g(ii,jj-1)+img1_g(ii-1,jj)+img1_g(ii,jj+1)+img1_g(ii+1,jj));
        elseif (mod(ii,2)==0)&&(mod(jj,2)==1)
            img1_r_intp(ii,jj) = 0.25*(img1_r(ii-1,jj-1)+img1_r(ii-1,jj+1)+img1_r(ii+1,jj-1)+img1_r(ii+1,jj+1));
            img1_g_intp(ii,jj) = 0.25*(img1_g(ii,jj-1)+img1_g(ii-1,jj)+img1_g(ii,jj+1)+img1_g(ii+1,jj));
        elseif (mod(ii,2)==1)&&(mod(jj,2)==1)
            img1_r_intp(ii,jj) = 0.5*(img1_r(ii,jj-1)+img1_r(ii,jj+1));
            img1_b_intp(ii,jj) = 0.5*(img1_b(ii-1,jj)+img1_b(ii+1,jj));
        end
    end
end
for ii = 2:size_y-1
    if (mod(ii,2)==0)
        img1_r_intp(ii,1) = 0.5*(img1_r(ii-1,2)+img1_r(ii+1,2));
        img1_g_intp(ii,1) = 1/3*(img1_g(ii-1,1)+img1_g(ii+1,1)+img1_g(ii,2));
        img1_b_intp(ii,size_x) = img1_b(ii,size_x-1);
        img1_r_intp(ii,size_x) = 0.5*(img1_r(ii-1,size_x)+img1_r(ii+1,size_x));
    elseif (mod(ii,2)==1)
        img1_r_intp(ii,1) = img1_r_intp(ii,2);
        img1_b_intp(ii,1) = 0.5*(img1_b(ii-1,1)+img1_b(ii+1,1));
        img1_g_intp(ii,size_x) = 1/3*(img1_g(ii-1,size_x)+img1_g(ii+1,size_x)+img1_g(ii,size_x-1));
        img1_b_intp(ii,size_x) = 0.5*(img1_b(ii-1,size_x-1)+img1_b(ii+1,size_x-1));
    end
end
for jj = 2:size_x-1
    if (mod(jj,2)==0)
        img1_b_intp(1,jj) = 0.5*(img1_b(2,jj-1)+img1_b(2,jj+1));
        img1_g_intp(1,jj) = 1/3*(img1_g(1,jj-1)+img1_g(1,jj+1)+img1_g(2,jj));
        img1_r_intp(size_y,jj) = img1_r(size_y-1,jj);%0.5*(img1_r(size_y-1,jj-1)+img1_r(size_y-1,jj+1));
        img1_b_intp(size_y,jj) = 0.5*(img1_b(size_y,jj-1) + img1_b(size_y,jj+1));%0.5*(img1_g(size_y-1,jj-1)+img1_g(size_y-1,jj+1));%1/3*(img1_g(size_y,jj-1)+img1_g(size_y,jj+1)+img1_g(size_y,jj));
    elseif (mod(jj,2)==1)
        img1_r_intp(1,jj) = 0.5*(img1_r(1,jj-1)+img1_r(1,jj+1));
        img1_b_intp(1,jj) = img1_b(2,jj);
        img1_r_intp(size_y,jj) = 0.5*(img1_r(size_y-1,jj-1)+img1_r(size_y-1,jj+1));
        img1_g_intp(size_y,jj) = 1/3*(img1_g(size_y,jj-1)+img1_g(size_y,jj+1)+img1_g(size_y-1,jj));%img1_g(size_y-1,jj);
    end
end
%%
img1_b_intp(1,1) = img1_b(2,1);img1_b_intp(1,size_x) = img1_b(2,size_x-1);
img1_b_intp(size_y,size_x) = img1_b(size_y,size_x-1);%img1_b_intp(size_y,1) = img1_b(size_y-1,1);
img1_g_intp(1,size_x) = 0.5*(img1_g(2,size_x)+img1_g(1,size_x-1));
img1_g_intp(size_y,1) = img1_g(size_y-1,1);%0.5*(img1_g(size_y-1,size_x)+img1_g(size_y,size_x-1));
img1_r_intp(1,1) = img1_r(1,2);img1_r_intp(size_y,1) = img1_r(size_y-1,2);
img1_r_intp(size_y,size_x) = img1_r(size_y-1,size_x);
img_intp = zeros(size(img1_cfa));
img_intp(:,:,1) = img1_r_intp;
img_intp(:,:,2) = img1_g_intp;
img_intp(:,:,3) = img1_b_intp;

