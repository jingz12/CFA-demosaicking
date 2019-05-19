function [rr,gg,bb] = get_temp_s(ii,jj,type)
if strcmp(type,'gaussian')
    temp = 50.*randn(1,3) + 128;
    locs1 = find(temp<0);temp(locs1) = 0;
    locs2 = find(temp>255);temp(locs2) = 255;
    temp = temp./255;
elseif strcmp(type,'uniform')
    temp = rand(1,3);
% elseif strcmp(type,'gibbs')  
end
rr = temp(1);gg = temp(2);bb = temp(3);
end
