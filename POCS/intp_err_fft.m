%%
%%
function intp_err_fft(img1_r_intp,img1_g_intp,img1_b_intp,img1_cfa)
img1_r = img1_cfa(:,:,1);img1_g = img1_cfa(:,:,2);img1_b = img1_cfa(:,:,3);
[size_y,size_x,size_n] = size(img1_cfa);
err_r = img1_r_intp -img1_r;
err_b = img1_b_intp -img1_b;
err_g = img1_g_intp -img1_g;
figure,subplot(131),imagesc(err_r),colorbar
subplot(132),imagesc(err_g),colorbar
subplot(133),imagesc(err_b),colorbar
%% 
img1_intp = zeros([size_y,size_x,size_n]);
img1_intp(:,:,1) = img1_r_intp;
img1_intp(:,:,2) = img1_g_intp;
img1_intp(:,:,3) = img1_b_intp;
%imwrite(img1_intp,'01_up_bi.tif')
%%
fft_r = fft2(img1_r_intp);
fft_g = fft2(img1_g_intp);
fft_b = fft2(img1_b_intp);
%%
figure,subplot(131),imagesc(abs(fftshift(fft_r))),colorbar('southoutside')%
subplot(132),imagesc(abs(fftshift(fft_g))),colorbar('southoutside')
subplot(133),imagesc(abs(fftshift(fft_b))),colorbar('southoutside')
% histogram(abs(fftshift(fft_r)))%
% histogram(abs(fftshift(fft_g)))%
% histogram(abs(fftshift(fft_b)))%