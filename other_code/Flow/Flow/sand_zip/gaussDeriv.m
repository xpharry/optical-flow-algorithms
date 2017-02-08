function gd = gaussDeriv(sigma, thresh)

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.



if nargin < 2
	thresh = 1e-6 ;
end

max_limit = 10000 ; % arbitrarily high to allow filters of any size.

x = linspace(-max_limit, max_limit, 2*max_limit+1) ;
variance = sigma ^ 2 ;
numer = x .* x ;
denom = 2 * variance ;
gd = exp( -numer / denom ) / ( pi * denom ) ^ 0.5 ;
gd = -gd .* ( x / variance ) ;

gd = gd( find( abs(gd) > thresh ) ) ; % cropping the filter.
