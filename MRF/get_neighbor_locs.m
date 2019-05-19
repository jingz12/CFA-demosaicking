function locs = get_neighbor_locs(ii,jj,sizey,sizex)
if (ii == 1)&&(jj ==1)
    locs = [1,2;2,1];
elseif (ii == 1)&&(jj == sizex)
    locs = [1,sizex-1;2,sizex];
elseif (ii == sizey)&&(jj == 1)
    locs = [sizey-1,1;sizey,2];
elseif (ii == sizey)&&(jj == sizex)
    locs = [sizey,sizex-1;sizey-1,sizex];
elseif (ii == 1)&&(jj < sizex)&&(jj > 1)
    locs = [1,jj-1;1,jj+1;2,jj];
elseif (ii == sizey)&&(jj < sizex)&&(jj > 1)
    locs = [sizey,jj-1;sizey,jj+1;sizey-1,jj];
elseif (jj == 1)&&(ii < sizey)&&(ii > 1)
    locs = [ii-1,1;ii+1,1;ii,2];
elseif (jj == sizex)&&(ii < sizey)&&(ii >1)
    locs = [ii-1,sizex;ii+1,sizex;ii,sizex-1];
else
    locs = [ii-1,jj;ii+1,jj;ii,jj-1;ii,jj+1];
end
end   