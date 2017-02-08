function [du, dv] = resolutionProcess_brox(Ikz, Ikx, Iky, Ixz, Iyz, alpha, gamma, omega, uinit, vinit, outer_iter, inner_iter) 
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

[Ixx, Ixy] = imgGrad( Ikx ) ; % Computing required gradients.
[Iyx, Iyy] = imgGrad( Iky ) ; % See the Phd thesis or the ECCV paper
							  % for more details.

% Initialize du, dv to 0. duv is the single vector which will hold the
% solution of SOR computations.
du = zeros( ht, wt ) ;
dv = zeros( ht, wt ) ;
tol = 1e-8 * ones( 2 * ht * wt, 1 ) ;
duv = zeros( 2 * ht * wt, 1 ) ;

% Now for outer_iter iterations.
for i = 1 : outer_iter
	% First compute the values of the data and smoothness terms
	psidash = psiDerivative( ( Ikz + Ikx .* du + Iky .* dv ) .^ 2 +...
	gamma * ( ( Ixz + Ixx .* du + Ixy .* dv ) .^ 2 + ...
			  ( Iyz + Ixy .* du + Iyy .* dv ) .^ 2 ) ) ;

	% Compute new psidashFS
	psidashFS = computePsidashFS_brox( u + du, v + dv ) ;

	% Constructing the new matrix.
	[A, b] = constructMatrix_brox( Ikx, Iky, Ikz, Ixx, Ixy, Iyy, Ixz, Iyz, psidash, alpha * psidashFS, u, v, gamma ) ;

	% Now call SOR for 500 iterations.
	[duv, err, it, flag] = sor( A, duv, b, omega, inner_iter, tol ) ;

	% Now convert duv into du and dv.
	du(:) = duv( 1:2:end ) ;
	dv(:) = duv( 2:2:end ) ;

	% This display shows the progress, change to imagesc if u want to see
	% other variants of the optical flow.
	figure(1); quiver(u+du, v+dv) ;
	title( sprintf('Iteration number: %d', i) ) ;
	axis ij ;
	pause(0.1) ;
end
