function check_flow_correspondence(im1,im2,F)
[p,q,~]=size(F);
step=4;
[ys,xs]=ndgrid(1:p,1:q);
ys2=ys+F(:,:,2);
xs2=xs+F(:,:,1);
xs=xs(1:step:end,1:step:end);
ys=ys(1:step:end,1:step:end);
xs2=xs2(1:step:end,1:step:end);
ys2=ys2(1:step:end,1:step:end);
xs=xs(:);
ys=ys(:);
xs2=xs2(:);
ys2=ys2(:);


visualize_correspondence(im1,im2,xs',ys',xs2',...
    ys2',11);