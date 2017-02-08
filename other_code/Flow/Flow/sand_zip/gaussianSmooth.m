function img_smooth = gaussianSmooth(img, sigma, endthresh)

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.



% Setting variables.
maxMaskSize = 100 ;
if nargin < 3
	endthresh = 1e-9 ;
end
if nargin < 2
	sigma = 1.0 ;
end
if sigma < 0.1
	img_smooth = img ;
	return ;
end

% First create the 1D mask.
grid = linspace(-maxMaskSize, maxMaskSize, 2*maxMaskSize+1) ;
grid = 1.0 / (sqrt(2 * pi) * sigma) * exp(-grid.^2 / (2 * sigma ^ 2)) ;
lim = find( abs(grid) > abs(endthresh) ) ;
grid = grid(lim) ;

% Now normalizing the Gaussian.
grid = grid / sum(grid) ;

% Now smooth and create the 1D smoothed image.
% Take this 1D smoothed image and create the 2D smoothed image.
% This is the basic convolution step.
% It can be done in matlab using conv2.

if (size(img,3) == 3)
	% Color image Smoothing the different channels separately.
	img_smooth = img ;
	img_smooth(:, :, 1) = conv2(grid, grid, img(:, :, 1), 'same') ;
	img_smooth(:, :, 2) = conv2(grid, grid, img(:, :, 2), 'same') ;
	img_smooth(:, :, 3) = conv2(grid, grid, img(:, :, 3), 'same') ;
else
	img_smooth = conv2(grid, grid, img, 'same') ;
end	

% conv2 returns double result. Converting back to uint8.
% possible loss of information. Only uncomment if needed.
% img_smooth = uint8(img_smooth) ;
