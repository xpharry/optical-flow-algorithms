function psidashFS = computePsidashFS_brox( u, v )
% This function computes the value psi(i~j)(k,l) as mentioned in the PhD
% thesis of Dr. Brox.

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.

[h, w] = size( u ) ;
psidashFS = zeros( 2 * h + 1, 2 * w + 1 ) ;

ux = convn( u, [1 -1] ) ; % x and y derivatives of u.
uy = convn( u, [1 -1]' ) ;

vx = convn( v, [1 -1] ) ; % x and y derivatives of v.
vy = convn( v, [1 -1]' ) ;

uxd = convn( ux, [1 1] / 2, 'valid' ) ; % averaging as per the numerics section
vxd = convn( vx, [1 1] / 2, 'valid' ) ; % of the second chapter.

uyd = convn( uy, [1 1]' / 2, 'valid' ) ;
vyd = convn( vy, [1 1]' / 2, 'valid' ) ;


t = convn( uyd, [1 1] / 2 ) ; % Computes the delta u(i+1/2, j) and delta u(i-1/2, j).
uxpd = ux .^ 2 + t .^ 2 ;
t = convn( uxd, [1 1]' / 2 ) ; % Computes the delta u(i, j+1/2) and delta u(i, j-1/2).
uypd = uy .^ 2 + t .^ 2 ;

t = convn( vyd, [1 1] / 2 ) ; % Computes the delta v(i+1/2, j) and delta v(i-1/2, j).
vxpd = vx .^ 2 + t .^ 2 ;
t = convn( vxd, [1 1]' / 2 ) ; % Computes the delta v(i+1/2, j) and delta v(i-1/2, j).
vypd = vy .^ 2 + t .^ 2 ;

% Finally g( delta u ) (i+1/2, j) and (i-1/2, j) and (i, j+1/2) and (i, j-1/2).
psidashFS( 1:2:end, 2:2:end ) = psiDerivative( uypd + vypd ) ;
psidashFS( 2:2:end, 1:2:end ) = psiDerivative( uxpd + vxpd ) ;
