function [u, v] = optic_flow_sand( img1, img2 )

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.



alpha_global = 10.0 ;
alpha_local = 15.0 ;

[ht, wt, dt] = size( img1 ) ;
% num_levels = round( power( 0.9, 50 / min( ht, wt ) ) ) 
num_levels = round( log10( 30 / min( ht, wt ) ) / log10( 0.9 ) ) 

u = zeros( fix( power( 0.9, num_levels ) * ht ), fix( power( 0.9, num_levels ) * wt ) ) ;
v = zeros( fix( power( 0.9, num_levels ) * ht ), fix( power( 0.9, num_levels ) * wt ) ) ;
du = zeros( fix( power( 0.9, num_levels ) * ht ), fix( power( 0.9, num_levels ) * wt ) ) ;
dv = zeros( fix( power( 0.9, num_levels ) * ht ), fix( power( 0.9, num_levels ) * wt ) ) ;

num_channels = 5 ;

for i = num_levels : -1 : 8
	im1_hr = gaussianRescaling( img1, power( 0.9, i ) ) ;
	im2_hr = gaussianRescaling( img2, power( 0.9, i ) ) ;
	[htn, wtn, dtn] = size( im1_hr ) ;

 	alphaImg = alpha_local * getalphaImg( im2_hr ) + alpha_global * ones( htn, wtn ) ;

 	im2_hrw = uint8( mywarp_rgb( double( im2_hr ), u, v ) ) ; % warp images.

 	I1 = channels_new( im1_hr ) ;
 	I2 = channels_new( im2_hrw ) ;

	[Ikx Iky] = imgGrad( I2 ) ;
	Ikz = I2 - I1 ;
 
 	alphaImg = alpha_local * getalphaImg( im2_hr ) + alpha_global * ones( htn, wtn ) ;
 
	[du, dv] = resolutionProcess_sand( Ikz, Ikx, Iky, alphaImg, 1.9, u, v, 3, 500 ) ;

	figure(1); quiver( u+du, v+dv ) ;
	title( sprintf( 'Optical flow at resolution %d', i ) ) ;
	axis ij ;

	figure(2); subplot(2, 3, 1); imshow(im1_hr) ;
	subplot(2, 3, 2); imshow(im2_hrw) ;
	subplot(2, 3, 3); imshow(im2_hr) ;
	subplot(2, 3, 4); imshow(uint8(double(im1_hr)-double(im2_hrw))) ;
	subplot(2, 3, 5); imshow(uint8(double(im1_hr)-double(im2_hr))) ;
	subplot(2, 3, 6); imshow(alphaImg, []) ;
	pause(3) ;

	htn = fix( power( 0.9, i-1 ) * ht ) ;	% Dimensions of the next level.
	wtn = fix( power( 0.9, i-1 ) * wt ) ;

	u = imresize( u+du, [htn wtn], 'bilinear' ) ;
	v = imresize( v+dv, [htn wtn], 'bilinear' ) ;

	figure(1); quiver( u, v ) ;
	title( sprintf( 'Initial Optical flow at resolution %d', i-1 ) ) ;
	axis ij ;
	% pause ;
end
