%% EC520 proj 
%% original article: Gunturk, B. K., Altunbasak, Y., & Mersereau, R. M. (2002). 
%%Color plane interpolation using alternating projections. IEEE transactions on image processing, 11(9), 997-1013.
clear,clc,close all
error_mat2 = zeros(5,5);
for image_no = 1:5
image_name = ['0',num2str(image_no),'.tif'];
%img1 = im2double(imread('01.tif'));
img1 = im2double(imread(image_name));
%% get cfa image
img1_cfa = get_cfa(img1);
[size_y,size_x,size_n] = size(img1);
img1_r = img1_cfa(:,:,1);img1_g = img1_cfa(:,:,2);img1_b = img1_cfa(:,:,3);
%% initial interpolation-bilinear
%[img1_r_intp,img1_g_intp,img1_b_intp] = bi_intp(img1_cfa);
img_intp = bi_intp(img1_cfa);
img1_r_intp = img_intp(:,:,1);
img1_g_intp = img_intp(:,:,2);
img1_b_intp = img_intp(:,:,3);
%% plot intp err and fft
% intp_err_fft(img1_r_intp,img1_g_intp,img1_b_intp,img1_cfa)
%% 
h0 = [1 2 1]/4;%[H0,W]=freqz(h0,1,256);
h1 = [1 -2 1]/4;%[H1,W]=freqz(h1,1,256);
g0 = [-1 2 6 2 -1]/8;%g0 = [1 2 1]/4;[G0,W]=freqz(-g0,1,256);
g1 = [1 2 -6 2 1]/8;%g1 = [1 -2 1]/4;[G1,W]=freqz(-g1,1,256);
%figure,plot(abs(H0.*G0 + H1.*G1))
%% UPDATE GREEN CHANNEL USING BULE AND RED 
G_rcnst = update_green(img1_r,img1_g_intp,img1_b,h0,h1,g0,g1);
% figure,subplot(231),imagesc(img1(:,:,2)),colorbar('southoutside'),title('original G'),axis off
% subplot(232),imagesc(G_rcnst),colorbar('southoutside'),title('reconstruct G'),axis off
% subplot(233),imagesc(img1_g_intp),colorbar('southoutside'),title('bilinear-intp G'),axis off
% subplot(235),imagesc((img1(:,:,2)-G_rcnst)),colorbar('southoutside'),title('reconstruct error'),axis off
% subplot(236),imagesc((img1(:,:,2)-img1_g_intp)),colorbar('southoutside'),title('bilinear error'),axis off
%print(gcf,'-dtiff',[image_name(1:end-4),'reconstruct G-01.tif'])
%% TABLE II
%CORRELATION BETWEEN ORIGINAL IMAGES AND BILINEARLY INTERPOLATED OBSERVATIONS IN DIFFERENT SUBBANDS
% for now, img1_r_intp and img1_b_intp are after bilinear interpolation, ang G_rcnst
% are that after reconstruction. use these three to do iteration
% W1_r = conv2(h0,h0,img1_r_intp,'same');W2_r = conv2(h0,h1,img1_r_intp,'same');
% W3_r = conv2(h1,h0,img1_r_intp,'same');W4_r = conv2(h1,h1,img1_r_intp,'same');
% W1_g = conv2(h0,h0,G_rcnst,'same');W2_g = conv2(h0,h1,G_rcnst,'same');
% W3_g = conv2(h1,h0,G_rcnst,'same');W4_g = conv2(h1,h1,G_rcnst,'same');
% W1_b = conv2(h0,h0,img1_b_intp,'same');W2_b = conv2(h0,h1,img1_b_intp,'same');
% W3_b = conv2(h1,h0,img1_b_intp,'same');W4_b = conv2(h1,h1,img1_b_intp,'same');
T = 0.00005*ones(size_y,size_x);%threshold 
%%
err_mat = zeros(5,4);
temp_r = img1_r_intp;temp_b = img1_b_intp;
for iter = 1:50
    %% detail projection 
    [R_new,B_new] = detail_proj(temp_r,temp_b,G_rcnst,h0,h1,g0,g1,T);
    %% observation projection
    R_new2 = R_new;
    R_new2(1:2:end,2:2:end) = img1_r(1:2:end,2:2:end);
    B_new2 = B_new;
    B_new2(2:2:end,1:2:end) = img1_b(2:2:end,1:2:end);
    temp_r = R_new2;
    temp_b = B_new2;
    %figure,subplot(221),imagesc(R_new2),title(['R-iter',num2str(iter)])
    %subplot(222),imagesc(B_new2),title(['B-iter',num2str(iter)])
    err_r = mean(mean((img1(:,:,1)-R_new2)));
    err_b = mean(mean((img1(:,:,3)-B_new2)));
    mse_r = mean(mean((img1(:,:,1)-R_new2).^2));
    mse_b = mean(mean((img1(:,:,3)-B_new2).^2));
    err_mat(iter,1) = err_r;err_mat(iter,2) = err_b;
    err_mat(iter,3) = mse_r;err_mat(iter,4) = mse_b;
    %subplot(223),imagesc(err_r),title({['error-R-iter',num2str(iter),'-mean-err',num2str(err_r)];...
    %    ['mse-',num2str(mse_r)]})
    %subplot(224),imagesc(err_b),title({['error-B-iter',num2str(iter),'-mean-err',num2str(err_b)];...
    %    ['mse-',num2str(mse_b)]})
    %print(gcf,'-dtiff',[image_name(1:end-4),'iter-',num2str(iter),'-01.tif'])
end



%%
img_new = zeros([size_y,size_x,size_n]);
img_new(:,:,1) = R_new;
img_new(:,:,2) = G_rcnst;
img_new(:,:,3) = B_new;
imwrite(img_new,['0',num2str(image_no),'_POCS_50','.tif'])
imwrite(img_intp,['0',num2str(image_no),'_intp_50','.tif'])
img_intp = zeros([size_y,size_x,size_n]);
img_intp(:,:,1) = img1_r_intp;
img_intp(:,:,2) = img1_g_intp;
img_intp(:,:,3) = img1_b_intp;

%%
%img_original = img1;
ERR_POCS = img1 - img_new;
MSE1 = mean(mean(mean(ERR_POCS.^2)));
ERR_INTP = img1 - img_intp;
MSE_INTP = mean(mean(mean(ERR_INTP.^2)));
    % SSIM
SSIM1 = ssim(img_new,img1);
    % PSNR
PSNR1 = psnr(img_new,img1);
    % PCC
PCC1 = corrcoef(img_new,img1);

error_mat2(image_no,1) = MSE1;
error_mat2(image_no,2) = SSIM1;
error_mat2(image_no,3) = PSNR1;
error_mat2(image_no,4) = PCC1(2,1);
error_mat2(image_no,5) = MSE_INTP;

figure,subplot(131),imshow(img1),title([image_name(1:end-4),'-original'])
subplot(132),imshow(img_new),title({[image_name(1:end-4),'-POCS'];['MSE',num2str(MSE1)]})
subplot(133),imshow(img_intp),title({[image_name(1:end-4),'-bilinear intp'];['MSE',num2str(MSE_INTP)]})
print(gcf,'-dtiff',[image_name(1:end-4),'niter-',num2str(iter),'-02.tif'])
end
%%
save(['niter-',num2str(iter),'-02.mat'],'error_mat2')
%% channel correlation and optimize T (threshold map)






















