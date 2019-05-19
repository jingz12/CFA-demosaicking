%% detail projection

function [R_new,B_new] = detail_proj(img1_r_intp,img1_b_intp,G_rcnst,h0,h1,g0,g1,T)
W1_r = conv2(h0,h0,img1_r_intp,'same');W2_r = conv2(h0,h1,img1_r_intp,'same');
W3_r = conv2(h1,h0,img1_r_intp,'same');W4_r = conv2(h1,h1,img1_r_intp,'same');
W1_g = conv2(h0,h0,G_rcnst,'same');W2_g = conv2(h0,h1,G_rcnst,'same');
W3_g = conv2(h1,h0,G_rcnst,'same');W4_g = conv2(h1,h1,G_rcnst,'same');
W1_b = conv2(h0,h0,img1_b_intp,'same');W2_b = conv2(h0,h1,img1_b_intp,'same');
W3_b = conv2(h1,h0,img1_b_intp,'same');W4_b = conv2(h1,h1,img1_b_intp,'same');

%% update red
%figure,
for kk = 2:4
    eval(sprintf('W_temp = W%d_r;',kk));
    eval(sprintf('WG_temp = W%d_g;',kk));
    rr = W_temp - WG_temp;%map_temp = (rr - T > 0);
    eval(sprintf('W%d_r = (WG_temp + T).*(rr - T > 0);',kk));
    eval(sprintf('W%d_r = W%d_r + (WG_temp - T).*(rr + T < 0);',kk,kk));
    eval(sprintf('W%d_r = W%d_r + (W_temp).*(abs(rr) <= T);',kk,kk));
    %subplot(1,3,kk-1),histogram(rr),title(['error-W',num2str(kk-1)])
    if kk == 2     
        eval(sprintf('U%d_r = conv2(g0,g1,W%d_r,''same'');',kk,kk));
    elseif kk == 3
        eval(sprintf('U%d_r = conv2(g1,g0,W%d_r,''same'');',kk,kk));
    elseif kk == 4
        eval(sprintf('U%d_r = conv2(g1,g1,W%d_r,''same'');',kk,kk));
    end
end
%print(gcf,'-dtiff','error-red-1.tif')
U1_r = conv2(g0,g0,W1_r,'same');
R_new = U1_r + U2_r + U3_r + U4_r;
%% update blue
%figure
for kk = 2:4
    eval(sprintf('W_temp = W%d_b;',kk));
    eval(sprintf('WG_temp = W%d_g;',kk));
    rr = W_temp - WG_temp;%map_temp = (rr - T > 0);
    eval(sprintf('W%d_b = (WG_temp + T).*(rr - T > 0);',kk));
    eval(sprintf('W%d_b = W%d_r + (WG_temp - T).*(rr + T < 0);',kk,kk));
    eval(sprintf('W%d_b = W%d_r + (W_temp).*(abs(rr) <= T);',kk,kk));
    %subplot(1,3,kk-1),histogram(rr),title(['error-blue-W-',num2str(kk-1)])
    if kk == 2    
        eval(sprintf('U%d_b = conv2(g0,g1,W%d_b,''same'');',kk,kk));
    elseif kk ==3
        eval(sprintf('U%d_b = conv2(g1,g0,W%d_b,''same'');',kk,kk));
    elseif kk ==4
        eval(sprintf('U%d_b = conv2(g1,g1,W%d_b,''same'');',kk,kk));
    end
end
%%
%print(gcf,'-dtiff','error-blue-1.tif')
U1_b = conv2(g0,g0,W1_b,'same');
B_new = U1_b + U2_b + U3_b + U4_b;