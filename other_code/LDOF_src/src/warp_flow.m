function im_w = warp_flow(im, u, v)
% use u,v to warp im to a new image im_w. u,v are displacments on x and y
% respectively and are aligned with im

[height, width, dim] = size(im);
im_w = im;

[u_ori v_ori] = meshgrid( 1:width, 1:height);
u1 = u_ori+u;
v1 = v_ori+v;

% for d = 1:dim
%     im_w(:,:,d) = squeeze(interp2(im(:,:,d), u1, v1));
% end
for d = 1:dim
    X=[u1(:) v1(:)];
    a=im(:,:,d);
    V=a(:);
    F=TriScatteredInterp(X,V);
%  im_w(:,:,d) = squeeze(interp2(u1,v1,im(:,:,d), u_ori, v_ori));
    im_w(:,:,d) = F(u_ori, v_ori);%squeeze(TriScatteredInterp(X,V,im(:,:,d), u_ori, v_ori));
 end