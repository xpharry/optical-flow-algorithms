function [HOG_arr, HOG_grid_x, HOG_grid_y] = dense_HOG(I,...
    cellsize, dstep,nbins,dist_bin,num_angles)
assert(rem(dist_bin,dstep)==0);

I = double(I);
I = mean(I,3);
I = I /max(I(:));

% parameters
alpha = 9; %% parameter for attenuation of angles (must be odd)
angle_step = 2 * pi / num_angles;
angles = 0:angle_step:2*pi;
angles(num_angles+1) = []; % bin centers
% sigma_edge = 1;
[h w] = size(I);

% [G_X,G_Y]=gen_dgauss(sigma_edge);
% I_X = filter2(G_X, I, 'same'); % vertical edges
% I_Y = filter2(G_Y, I, 'same'); % horizontal edges
[I_X, I_Y] = gaussDeriv_dir(I);
I_mag = sqrt(I_X.^2 + I_Y.^2); % gradient magnitude
I_theta = atan2(I_Y,I_X);
I_theta(find(isnan(I_theta))) = 0; 



% make orientation images
I_orientation = zeros([h, w, num_angles], 'single');

% for each histogram angle
cosI = cos(I_theta);
sinI = sin(I_theta);
for a=1:num_angles
    % compute each orientation channel
    tmp = (cosI*cos(angles(a))+sinI*sin(angles(a))).^alpha;
    tmp = tmp .* (tmp > 0);
    % weight by magnitude
    I_orientation(:,:,a) = tmp .* I_mag;
end

%compute integral image
for a=1:num_angles
    AII=cumsum(cumsum(I_orientation(:,:,a),2));
    I_orientation(:,:,a)=AII;
end



cell_y=cellsize+2:dstep:h-cellsize-2;
cell_x=cellsize+2:dstep:w-cellsize-2;
[cell_grid_y,cell_grid_x]=ndgrid(cell_y,cell_x);
cell_grid_y=cell_grid_y(:);
cell_grid_x=cell_grid_x(:);
%accumulate orientations in cells
boxes=[cell_grid_x-cellsize cell_grid_y-cellsize ...
    cell_grid_x+cellsize cell_grid_y+cellsize];
cell_arr = zeros([length(cell_grid_y) num_angles], 'single');

boxes=boxes+1;
for a=1:num_angles
    I_orientationc=I_orientation(:,:,a);
    B=zeros(h+1,w+1);
    B(2:end,2:end)=I_orientationc;
    I_orientationc=B;
    cell_arr(:,a)=I_orientationc((boxes(:,3)-1)*(h+1)+boxes(:,4))-...
        I_orientationc((boxes(:,1)-2)*(h+1)+boxes(:,4))-...
        I_orientationc((boxes(:,3)-1)*(h+1)+(boxes(:,2)-1))+...
        I_orientationc((boxes(:,1)-2)*(h+1)+(boxes(:,2)-1));
    
end
cell_arr=reshape(cell_arr,[length(cell_y) length(cell_x) num_angles]);
clear I_orientation

%stacking
cellstep=dist_bin/dstep;
[sample_x,sample_y] = meshgrid((-1)*nbins*cellstep:cellstep:cellstep*nbins);
HOG_y=cell_y(nbins*cellstep+1:end-nbins*cellstep);
r_grid_y=nbins*cellstep+1:length(cell_y)-nbins*cellstep;
HOG_x=cell_x(nbins*cellstep+1:end-nbins*cellstep);
r_grid_x=nbins*cellstep+1:length(cell_x)-nbins*cellstep;
[HOG_grid_y,HOG_grid_x]=ndgrid(HOG_y,HOG_x);

HOG_arr = zeros([length(HOG_y) length(HOG_x) ...
    num_angles*(2*nbins+1)*(2*nbins+1)], 'single');
b = 0;
for n = 1:(2*nbins+1)*(2*nbins+1)
    HOG_arr(:,:,b+1:b+num_angles) = cell_arr(r_grid_y+sample_y(n),...
        r_grid_x+sample_x(n), :);
    b = b+num_angles;
end


