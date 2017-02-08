function [A, b] = constructMatrix( Ikx, Iky, Ikz, Ixx, Ixy, Iyy, Ixz, Iyz, pd, pdfs, u, v, gamma )
% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.



[ht, wt] = size( u ) ;

% small adjustment. remove if necessary. respecting the boundary conditions
% for all the images.
pdfs( 1, : ) = 0 ;
pdfs( :, 1 ) = 0 ;
pdfs( end, : ) = 0 ;
pdfs( :, end ) = 0 ;

% Then construct the A and b matrices.
tmp = repmat( 1 : 2 * ht * wt, 6, 1 ) ;
rs =  tmp(:) ;	% Rows
cs = rs ; % Cols
ss = zeros( size( rs ) ) ; % Values
cs(1:6:end) = rs(1:6:end) - 2 * ht ;	% x-1
cs(2:6:end) = rs(2:6:end) - 2 ;			% y-1
cs(9:12:end) = rs(9:12:end) - 1 ;		% v
cs(4:12:end) = rs(4:12:end) + 1 ;		% u
cs(5:6:end) = rs(5:6:end) + 2 ;			% y+1
cs(6:6:end) = rs(6:6:end) + 2 * ht ;	% x+1

% sigma (j belongs N(i)) (psi dash) (i~j) (k,l)
pdfsum = pdfs( 1 : 2 : 2 * ht, 2 : 2 : end ) + pdfs( 3 : 2 : end, 2 : 2 : end ) +...
		 pdfs( 2 : 2 : end, 1 : 2 : 2 * wt ) + pdfs( 2 : 2 : end, 3 : 2 : end ) ;

% argument to u(i) in the first of the 2 linear Euler Lagrange equations.
uapp = pd .* ( Ikx .^ 2 + gamma * ( Ixx .^ 2 + Ixy .^ 2 ) ) + pdfsum ;
% argument to v(i) in the second of the 2 linear Euler Lagrange equations.
vapp = pd .* ( Iky .^ 2 + gamma * ( Iyy .^ 2 + Ixy .^ 2 ) ) + pdfsum ;
% argument to v(i) in the first of the 2 linear Euler Lagrange equations.
uvapp = pd .* ( Ikx .* Iky + gamma * ( Ixx .* Ixy + Iyy .* Ixy ) ) ;
% argument to u(i) in the second of the 2 linear Euler Lagrange equations.
vuapp = pd .* ( Ikx .* Iky + gamma * ( Ixx .* Ixy + Iyy .* Ixy ) ) ;

ss( 3 : 12 : end ) = uapp(:) ;
ss( 10 : 12 : end ) = vapp(:) ;
ss( 4 : 12 : end ) = uvapp(:) ;
ss( 9 : 12 : end ) = vuapp(:) ;

% arguments to u(j) in the linear Euler Lagrange equations.
tmp = pdfs( 2 : 2 : end, 1 : 2 : 2 * wt ) ;
ss( 1 : 12 : end ) = -tmp(:) ;
ss( 7 : 12 : end ) = -tmp(:) ;
tmp = pdfs( 2 : 2 : end, 3 : 2 : end ) ;
ss( 6 : 12 : end ) = -tmp(:) ;
ss( 12 : 12 : end ) = -tmp(:) ;

% arguments to v(j) in the linear Euler Lagrange equations.
tmp = pdfs( 1 : 2 : 2 * ht, 2 : 2 : end ) ;
ss( 2 : 12 : end ) = -tmp(:) ;
ss( 8 : 12 : end ) = -tmp(:) ;
tmp = pdfs( 3 : 2 : end, 2 : 2 : end ) ;
ss( 5 : 12 : end ) = -tmp(:) ;
ss( 11 : 12 : end ) = -tmp(:) ;

upad = padarray( u, [1 1] ) ;
vpad = padarray( v, [1 1] ) ;

% Computing the constant terms for the first of the Euler Lagrange equations
pdfaltsumu = pdfs(2:2:end, 1:2:2*wt) .* ( upad(2:ht+1, 1:wt) - upad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 2:2:end, 3:2:end) .* ( upad(2:ht+1, 3:end) - upad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 1:2:2*ht, 2:2:end) .* ( upad(1:ht, 2:wt+1) - upad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 3:2:end, 2:2:end) .* ( upad(3:end, 2:wt+1) - upad(2:ht+1, 2:wt+1) ) ;

% Computing the constant terms for the second of the Euler Lagrange equations
pdfaltsumv = pdfs(2:2:end, 1:2:2*wt) .* ( vpad(2:ht+1, 1:wt) - vpad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 2:2:end, 3:2:end) .* ( vpad(2:ht+1, 3:end) - vpad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 1:2:2*ht, 2:2:end) .* ( vpad(1:ht, 2:wt+1) - vpad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 3:2:end, 2:2:end) .* ( vpad(3:end, 2:wt+1) - vpad(2:ht+1, 2:wt+1) ) ;

constu = pd .* ( Ikx .* Ikz + gamma * ( Ixx .* Ixz + Ixy .* Iyz ) ) - pdfaltsumu ;
constv = pd .* ( Iky .* Ikz + gamma * ( Ixy .* Ixz + Iyy .* Iyz ) ) - pdfaltsumv ;

b = zeros( 2 * ht * wt, 1 ) ;
b(1:2:end) = -constu(:) ;
b(2:2:end) = -constv(:) ;

% Now trim
ind = find(cs > 0) ;
rs = rs( ind ) ;
cs = cs( ind ) ;
ss = ss( ind ) ;
ind = find(cs < ( 2 * ht * wt + 1 ) ) ;
rs = rs( ind ) ;
cs = cs( ind ) ;
ss = ss( ind ) ;

A = sparse( rs, cs, ss ) ;
