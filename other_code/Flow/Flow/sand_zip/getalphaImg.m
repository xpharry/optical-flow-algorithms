function alphaImg = getalphaImg( img, alpha_cov )

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.


if nargin < 2
	alpha_cov = 2.0 ;
end

img_g = rgb2gray( img ) ;
[ix, iy] = imgGrad( img_g ) ;

alphaImg = ix .^ 2 + iy .^ 2 ;
alphaImg = exp( -alphaImg / ( 2 * alpha_cov .^ 2 ) ) ;
alphaImg = alphaImg / sqrt( 2 * pi * alpha_cov .^ 2 ) ;
