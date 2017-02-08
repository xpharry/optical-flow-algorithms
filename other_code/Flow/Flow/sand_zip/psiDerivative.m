function y = psiDerivative( x, epsilon )
% The function being considered here is y = psi( x )
% psi = "sqrt( x + eps )"
% Return value psi'(x) where ' represents derivative

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.


if nargin < 2
	epsilon = 1e-3 ;
end

% Might be changed in the future to allow other possible functions.
y = 1 ./ (2 * sqrt( x + epsilon ) ) ;
