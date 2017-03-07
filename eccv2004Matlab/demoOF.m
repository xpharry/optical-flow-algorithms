disp(datestr(datetime('now')));

im1 = double(imread('../input/tennis492.jpg'));
im2 = double(imread('../input/tennis493.jpg'));
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

imwrite(flow_image./255, './optical_flow_mat.jpg')

% fileID = fopen('data.txt','w');
% fprintf(fileID,'%6s %12s\n','x','exp(x)');
% fprintf(fileID,'%3d %3d %3d\r\n', flow_image);
% fclose(fileID);

disp(datestr(datetime('now')));