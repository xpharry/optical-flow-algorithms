function [u, v] = optic_flow_brox(img1, img2)

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.

alpha = 30.0 ; % Global smoothness variable.
gamma = 80.0 ; % Global weight for derivatives.

[ht, wt, dt] = size( img1 ) ;

num_levels = 40 ; % for face; Number of pyramid levels. Can also be calculated automatically

im1_hr = gaussianRescaling( img1, power( 0.95, num_levels ) ) ; % Rescaling images
im2_hr = gaussianRescaling( img2, power( 0.95, num_levels ) ) ; % to the top of the
																% laplacian pyramid.
u = zeros(size(rgb2gray(im1_hr))); % Initialization.
v = zeros(size(rgb2gray(im1_hr)));

for i = num_levels-1 : -1 : 1

	I1 = rgb2gray(im1_hr) ;
	I2 = rgb2gray(im2_hr) ;

	% Computing derivatives.
	[Ikx Iky] = imgGrad( I2 ) ;
	[Ikx2 Iky2] = imgGrad( I1 ) ;
	Ikz = double(I2) - double(I1) ;
	Ixz = double(Ikx) - double(Ikx2) ;
	Iyz = double(Iky) - double(Iky2) ;
	
	% Calling the processing for a particular resolution.
	% Last two arguments are the outer and inner iterations, respectively.
	% 1.8 is the omega value for the SOR iteration.
	[du, dv] = resolutionProcess_brox( Ikz, Ikx, Iky, Ixz, Iyz, alpha, gamma, 1.8, u, v, 3, 500 ) ;
	
	% Adding up the optical flow.
	u = u + du ;
	v = v + dv ;

	im1_hr = gaussianRescaling( img1, power( 0.95, i ) ) ;
	im2_hr = gaussianRescaling( img2, power( 0.95, i ) ) ;
	im2_orig = im2_hr ; % Original image without warping for comparison.

	% Resize optical flow to current resolution.
	u = imresize( u, [size(im1_hr, 1), size(im1_hr, 2)], 'bilinear' ) ;
	v = imresize( v, [size(im1_hr, 1), size(im1_hr, 2)], 'bilinear' ) ;

	im2_hr = uint8( mywarp_rgb( double( im2_hr ), u, v ) ) ; % taking im1_hr closer to im2_hr.

	% Displaying relevant figures.
	figure(2); 
	subplot(3, 3, 1); imshow(im1_hr) ;
	subplot(3, 3, 2); imshow(rgb2gray(im2_hr)) ;
	subplot(3, 3, 3); imshow(rgb2gray(im2_orig)) ;
	subplot(3, 3, 4); imshow(uint8(double(im1_hr)-double(im2_hr))) ;
	subplot(3, 3, 5); imshow(uint8(double(im1_hr)-double(im2_orig))) ;
	subplot(3, 3, 6); imshow(uint8(double(im2_hr)-double(im2_orig))) ;
	subplot(3, 3, 7); imagesc(u) ;
	subplot(3, 3, 8); imagesc(v) ;
	subplot(3, 3, 9); imagesc(sqrt(u.^2 + v.^2)) ;
	% pause;
end
