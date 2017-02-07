im1 = double(imread('a.jpg'));
im2 = double(imread('b.jpg'));
flow = mex_OF(im1,im2);

scale = 16;
mag = sqrt(flow(:,:,1).^2+flow(:,:,2).^2)*scale+128;
mag = min(mag, 255);
flow = flow*scale+128;
flow = min(flow,255);
flow = max(flow,0);

[x,y,z] = size(flow);
flow_image = zeros(x,y,3);
flow_image(:,:,1:2) = flow;
flow_image(:,:,3) = mag;

imwrite(flow_image./255, 'c_matlab.jpg')