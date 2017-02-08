function im_w = warp2(im, u, v)
% u,v are displacment on x and y respectively.

[height, width, dim] = size(im);
im_w = im;

[u_ori v_ori] = meshgrid( 1:width, 1:height);
u1 = u_ori+u;
v1 = v_ori+v;

for d = 1:dim
    im_w(:,:,d) = squeeze(interp2(im(:,:,d), u1, v1));
end