function I2warped = warp_image(I2, u, v)
% warp image I2 backward with u,v. where u,v is aligned with I2warped.
% I2(x+u, y+v) = I2warped(x,y)
I2=double(I2);
[height, width, dim] = size(I2);

u1 = u;
u1(isnan(u1)) = 0;
v1 = v;
v1(isnan(v1)) = 0;

[X,Y]=meshgrid([1:width],[1:height]);

xnew=X+u1;
ynew=Y+v1;
xnew(xnew>width)=width;
xnew(xnew<1)=1;
ynew(ynew>height)=height;
ynew(ynew<1)=1;

for ii=1:dim
    I2warpedc{ii}=interp2(X,Y,I2(:,:,ii),xnew,ynew,'bilinear');
    I2warpedc{ii}(isnan(u)|isnan(v)) = nan;
end
I2warped=cat(3,I2warpedc{:});