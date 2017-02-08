function [du, dv] = resolutionProcess_sand(Ikz, Ikx, Iky, alphaImg, omega, uinit, vinit, outer_iter, inner_iter) 
% This function takes as input the two image channels
% and the smoothness image and returns the resultant
% optical flow matrices u and v.
% The algorithm follows the optical flow algorithm described in
% Peter Sand and Seth Teller, "Particle Video", CVPR 2006 and
% T Brox, A Bruhn, N Papenberg, J Weickert, "High Accuracy Optical Flow Estimation
%	Based on a Theory for Warping", ECCV 2004.

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.



% We need to do 3 fixed point steps with 500 iterations in each step.
[ht, wt, dt] = size( Ikz ) ;
if nargin < 8
	inner_iter = 500 ;
end
if nargin < 7
	outer_iter = 3 ;
end
if nargin < 6
	u = zeros( ht, wt ) ;
	v = zeros( ht, wt ) ;
else
	u = uinit ;
	v = vinit ;
end
if nargin < 4
	omega = 1.9 ;
end

num_channels = size( Ikz, 3 ) ;

% Initialize u, v, ux, vx, uy, vy, du, dv, dux, duy, dvx, dvy
du = zeros( ht, wt ) ;
dv = zeros( ht, wt ) ;
tol = 1e-5 * ones( 2 * ht * wt, 1 ) ;
duv = zeros( 2 * ht * wt, 1 ) ;

% Now for 3 iterations.
for i = 1 : outer_iter
	% First compute the values of the data and smoothness terms
	psidash = psiDerivative( ( Ikx .* repmat( du, [1, 1, num_channels] ) +...
		Iky .* repmat( dv, [1, 1, num_channels] ) + Ikz ) .^ 2 ) ;

	% computing diffusivity brox style.
	psidashFS = computePsidashFS_sand( u + du, v + dv, alphaImg ) ;


	[A, b] = constructMatrix_sand( Ikx, Iky, Ikz, psidash, psidashFS, u, v ) ;

	x = duv ;

	% Now call SOR for 500 iterations.
	% duv = MySOR( A, b, x, omega, tol, inner_iter ) ;
	[duv, err, it, flag] = sor( A, x, b, omega, inner_iter, tol ) ;

	% Now convert duv into du and dv.
	du(:) = duv( 1:2:end ) ;
	dv(:) = duv( 2:2:end ) ;

	quiver(u+du, v+dv) ;
	title( sprintf('Iteration number: %d', i) ) ;
	axis ij ;
	pause(0.1) ;
end
