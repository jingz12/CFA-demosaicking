%% EC520 proj 
%% original article: Mukherjee, Jayanta, R. Parthasarathi, and S. Goyal. 
%%"Markov random field processing for color demosaicing." Pattern Recognition Letters 22.3-4 (2001): 339-351.
clear,clc,close all
%% set global
%global mask_cfa
for imgno = 1
img = im2double(imread(['0',num2str(imgno),'.tif']));
%img = img(250:313,250:313,:); %img5
img = img(129:384,237:492,:);
%img = img(512/4+1:512/4*3,728/4+1:728/4*3,:);
%img = img(1:64,1:64,:); %for testing
%%
[img_cfa,mask_cfa] = get_cfa(img);
img_intp = bi_intp(img_cfa);
[sizey,sizex,~] = size(img);%Inew_temp = img_intp;
Inew = img_intp;
%%initialize T
T0 = 1;T = T0;Tsmall = 1e-30;
%% initialize U
U_sm0 = zeros(sizey,sizex);U_rho0 = zeros(sizey,sizex);
for ii = 2:sizey-1
    for jj = 2:sizex-1
        img_intp_patch = img_intp(ii-1:ii+1,jj-1:jj+1,:);
        mask_cfa_patch = mask_cfa(ii-1:ii+1,jj-1:jj+1,:);
        [U_sm_temp,U_rho_temp] = get_energy(img_intp_patch,mask_cfa_patch);
        U_sm0(ii,jj) = U_sm_temp;
        U_rho0(ii,jj) = U_rho_temp;
    end
end
clear img_intp_patch mask_cfa_patch
miu = 0.4;lambda = 0.4;gama = 0.2;%%?
U0 = miu*U_sm0 + lambda*U_rho0; %% for U0, Is0 = Is0, no gamma
U0(find(isnan(U0)==1)) = 0;
Unew = U0;
niter = 1;
MSEarr = zeros(65,1);
%% iteration
while T > Tsmall
    ntrials = abs(log(T) + 1);
    for k = 0:int8(ntrials)%% int8 here or above
        for ii = 2:sizey-1 %% 
            for jj = 2:sizex-1 %% 
                [temp_r,temp_g,temp_b] = get_temp_s(ii,jj,'uniform');%'gaussian'
                mask_temp = squeeze(mask_cfa(ii,jj,:));
                temps = ((1-mask_temp).*[temp_r;temp_g;temp_b] + mask_temp.*squeeze(img_intp(ii,jj,:)))';
                Inew_temp = Inew;
                Inew_temp(ii,jj,:) = temps;
                Inew_patch = Inew_temp(ii-1:ii+1,jj-1:jj+1,:);
                mask_cfa_patch = mask_cfa(ii-1:ii+1,jj-1:jj+1,:);
                [U_sm,U_rho,sigma] = get_energy(Inew_patch,mask_cfa_patch);%
                %get_energy(ii,jj,Inew_patch,mask_cfa);
                U_new_temp = miu*U_sm + lambda*U_rho + gama*...
                    sum((1-mask_cfa(ii,jj,:)).*(Inew(ii,jj,:)-img_intp(ii,jj,:)).^2/2/sigma^2);
                if U_new_temp <= U0(ii,jj)
                    Unew(ii,jj,:) = U_new_temp;
                    %mask_temp = squeeze(mask_cfa(ii,jj,:));
                    Inew(ii,jj,:) = temps;%(1-mask_temp).*[temp_r;temp_g;temp_b] + mask_temp.*squeeze(img_intp(ii,jj,:));
                else
                    if (rand(1) < exp(-(U_new_temp - U0(ii,jj))/T))
                        Unew(ii,jj,:) = U_new_temp;
                        mask_temp = squeeze(mask_cfa(ii,jj,:));
                        Inew(ii,jj,:) = temps;%(1-mask_temp).*[temp_r;temp_g;temp_b] + mask_temp.*squeeze(img_intp(ii,jj,:));
                    end  
                end
            end
        end
        %delta = mean(mean((U0-Unew).^2))
        U0 = Unew;
        %err_temp = img - Inew;
        %MSE = mean(mean(mean(err_temp.^2)))
    end
    T = T/log(niter + 1);
    err_temp = img - Inew;
    MSE = mean(mean(mean(err_temp.^2)))
    MSEarr(niter) = MSE;
    if mod(niter,20)==0
        save(['test0',num2str(imgno),'_resutls_0429_',num2str(niter),'.mat'],'Inew','Unew')
    end
    niter = niter + 1;
end
save(['test0',num2str(imgno),'_resutls_0428_final','.mat'],'Inew','Unew','MSEarr')
%
% figure,subplot(121),imshow(img),title('original')
% subplot(122),imshow(Inew),title('Inew')
                
end

function [U_sm,U_rho,sigma] = get_energy(Inew_temp,mask_cfa)
%%Inew_temp and mask_cfa are small patch 
[sizey,sizex,~] = size(Inew_temp);
neighbor_locs = get_neighbor_locs(2,2,sizey,sizex);
U_sm = 0;
U_rho = 0;

%mask_temp = squeeze(mask_cfa(ii,jj,:));
%Inew_temp_temp = squeeze(Inew_temp(ii,jj,:));

c_temp = sum(mask_cfa(2,2,:).*Inew_temp(2,2,:));
c_ver = abs(sum(mask_cfa(2-1,2,:).*Inew_temp(2-1,2,:))-...
    sum(mask_cfa(2+1,2,:).*Inew_temp(2+1,2,:)));
c_hor = abs(sum(mask_cfa(2,2-1,:).*Inew_temp(2,2-1,:))-...
    sum(mask_cfa(2,2+1,:).*Inew_temp(2,2+1,:)));
sigma = min(c_ver,c_hor)/2/sqrt(2) + 10/256;

for ccc = 1:size(neighbor_locs,1)
    locsx = neighbor_locs(ccc,1);%% locs of the current neighbor
    locsy = neighbor_locs(ccc,2);
    sum_spectra = sum(mask_cfa(2,2,:).*Inew_temp(locsx,locsy,:));
    phi = exp((-c_temp - sum_spectra)^2/2/sigma)/sqrt(2*pi*sigma);
    U_sm = U_sm + sum(phi.*(1-mask_cfa(2,2,:)).*...
        (Inew_temp(2,2,:) - Inew_temp(locsx,locsy,:)).^2);
    U_rho = U_rho + sum(phi.*(1-mask_cfa(2,2,:)).*...
        (Inew_temp(2,2,:)./c_temp - Inew_temp(locsx,locsy,:)./...
        sum(mask_cfa(2,2,:).*Inew_temp(locsx,locsy,:))).^2);
%     if isnan(U_rho) == 1
%         U_rho
%     end
    
end
end
   

    
    
