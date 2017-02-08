function I2warped = warp_image(I2, u, v)
% warp image I2 backward with u,v. where u,v is aligned with I2warped.
% I2(x+u, y+v) = I2warped(x,y)

[height, width, dim] = size(I2);



[X,Y]=meshgrid([1:width],[1:height]);

xnew=X+u;
ynew=Y+v;
xnew(xnew>width)=width;
xnew(xnew<1)=1;
ynew(ynew>height)=height;
ynew(ynew<1)=1;

for ii=1:dim
    I2warpedc{ii}=interp2(X,Y,I2(:,:,ii),xnew,ynew,'bilinear');
end
I2warped=cat(3,I2warpedc{:});