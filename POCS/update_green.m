%% update green 
function G_rcnst = update_green(img1_r,img1_g_intp,img1_b,h0,h1,g0,g1)
%function G_rcnst = update_green(img1,h0,h1,g0,g1)
obs_b = img1_b(2:2:end,1:2:end);
intp_g1 = img1_g_intp(2:2:end,1:2:end);
obs_r = img1_r(1:2:end,2:2:end);
W1_b = conv2(h0,h0,obs_b,'same');W2_b = conv2(h0,h1,obs_b,'same');
W3_b = conv2(h1,h0,obs_b,'same');W4_b = conv2(h1,h1,obs_b,'same');
W1_g = conv2(h0,h0,intp_g1,'same');W2_g = W2_b;W3_g = W3_b;W4_g = W4_b;
U1_g = conv2(g0,g0,W1_g,'same');U2_g = conv2(g0,g1,W2_g,'same');% reconstruct G channel for blue
U3_g = conv2(g1,g0,W3_g,'same');U4_g = conv2(g1,g1,W4_g,'same');
G_temp = U1_g + U2_g + U3_g + U4_g;

intp_g2 = img1_g_intp(1:2:end,2:2:end);
W1_r = conv2(h0,h0,obs_r,'same');W2_r = conv2(h0,h1,obs_r,'same');
W3_r = conv2(h1,h0,obs_r,'same');W4_r = conv2(h1,h1,obs_r,'same');
W1_g = conv2(h0,h0,intp_g2,'same');W2_g = W2_r;W3_g = W3_r;W4_g = W4_r;
U1_g = conv2(g0,g0,W1_g,'same');U2_g = conv2(g0,g1,W2_g,'same');% reconstruct G channel for red
U3_g = conv2(g1,g0,W3_g,'same');U4_g = conv2(g1,g1,W4_g,'same');
G_temp2 = U1_g + U2_g + U3_g + U4_g;

G_rcnst = img1_g_intp;
G_rcnst(2:2:end,1:2:end) = G_temp;%(4:end-3,4:end-3);
G_rcnst(1:2:end,2:2:end) = G_temp2;%(4:end-3,4:end-3);

% figure,subplot(231),imagesc(img1(:,:,2)),colorbar('southoutside'),title('original G'),axis off
% subplot(232),imagesc(G_rcnst),colorbar('southoutside'),title('reconstruct G'),axis off
% subplot(233),imagesc(img1_g_intp),colorbar('southoutside'),title('bilinear-intp G'),axis off
% subplot(235),imagesc((img1(:,:,2)-G_rcnst)),colorbar('southoutside'),title('reconstruct error'),axis off
% subplot(236),imagesc((img1(:,:,2)-img1_g_intp)),colorbar('southoutside'),title('bilinear error'),axis off
% %print(gcf,'-dtiff','reconstruct G-01.tif')