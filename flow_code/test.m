% filename = '/home/peng/projects/optical_flow/flow_estimation_py/data/other-gt-flow/RubberWhale/flow10.flo';
filename = '/home/peng/projects/optical_flow/flow_estimation_py/data/009_Crates1/1_2.flo';

fid = fopen(filename, 'r');
if (fid < 0)
    error('readFlowFile: could not open %s', filename);
end;

tag     = fread(fid, 1, 'float32');
width   = fread(fid, 1, 'int32');
height  = fread(fid, 1, 'int32');

% sanity check
if (width < 1 || width > 99999)
    error('readFlowFile(%s): illegal width %d', filename, width);
end;

if (height < 1 || height > 99999)
    error('readFlowFile(%s): illegal height %d', filename, height);
end;

nBands = 2;

% arrange into matrix form
tmp = fread(fid, inf, 'float32');
% disp('------------')
% disp(tmp(1))
% disp(tmp(2))
% disp(tmp(3))
tmp = reshape(tmp, [width*nBands, height]);
tmp = tmp';

img = zeros(height, width, nBands);
img(:,:,1) = tmp(:, (1:width)*nBands-1);
img(:,:,2) = tmp(:, (1:width)*nBands);

tu = img(:, :, 1);
tv = img(:, :, 2);
% disp('++++++++++++++++');
% disp(tu(1:5, 1:5));

fclose(fid);

% Set unknown values to nan
UNKNOWN_FLOW_THRESH = 1e9; 
tu (tu>UNKNOWN_FLOW_THRESH) = NaN;
tv (tv>UNKNOWN_FLOW_THRESH) = NaN;

disp('=====================')
disp(tu(1:5, 1:5));
tumax = max(max(tu))
tumin = min(min(tu))
tvmax = max(max(tv))
tvmin = min(min(tv))
tu = (tu - tumin) / (tumax - tumin);
tv = (tv - tvmin) / (tvmax - tvmin);
disp('-----------------')
disp(tu(1:5, 1:5));

% ------------------------------
% img1Filename = '/home/peng/projects/optical_flow/flow_estimation_py/data/other-data/RubberWhale/frame10.png';
% img2Filename = '/home/peng/projects/optical_flow/flow_estimation_py/data/other-data/RubberWhale/frame11.png';      

img1Filename = '/home/peng/projects/optical_flow/flow_estimation_py/data/009_Crates1/1.png';
img2Filename = '/home/peng/projects/optical_flow/flow_estimation_py/data/009_Crates1/2.png'; 

im1=double(imread(img1Filename));
im2=double(imread(img2Filename));

method = 'classic+nl-fast';

uv = estimate_flow_interface(im1, im2, method);
save('uvmat12.mat', 'uv')
% uvmat = load('uvmat.mat');
% uv = uvmat.uv;

u = uv(:,:,1);
v = uv(:,:,2);

disp('=====================')
disp(u(1:5, 1:5));
umax = max(max(u))
umin = min(min(u))
vmax = max(max(v))
vmin = min(min(v))
u = (u - umin) / (umax - umin);
v = (v - vmin) / (vmax - vmin);
disp('-----------------')
disp(u(1:5, 1:5));

[aae stdae aepe] = flowAngErr(tu, tv, u, v, 0);
% [aae stdae aepe] = flowAngErr(tu(1:5, 1:5), tv(1:5, 1:5), u(1:5, 1:5), v(1:5, 1:5), 0);
fprintf('\nAAE %3.3f average EPE %3.3f \n', aae, aepe);

