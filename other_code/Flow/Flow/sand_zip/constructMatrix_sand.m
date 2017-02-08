function [A, b] = constructMatrix_sand( Ikx, Iky, Ikz, pd, pdfs, u, v )

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

pdfsum = pdfs( 1 : 2 : 2 * ht, 2 : 2 : end ) + pdfs( 3 : 2 : end, 2 : 2 : end ) +...
		 pdfs( 2 : 2 : end, 1 : 2 : 2 * wt ) + pdfs( 2 : 2 : end, 3 : 2 : end ) ;

uapp = sum( pd .* ( Ikx .^ 2 ), 3 ) + pdfsum ;
vapp = sum( pd .* ( Iky .^ 2 ), 3 ) + pdfsum ;
uvapp = sum( pd .* ( Ikx .* Iky ), 3 ) ;
vuapp = sum( pd .* ( Ikx .* Iky ), 3 ) ;

ss( 3 : 12 : end ) = uapp(:) ;
ss( 10 : 12 : end ) = vapp(:) ;
ss( 4 : 12 : end ) = uvapp(:) ;
ss( 9 : 12 : end ) = vuapp(:) ;

tmp = pdfs( 2 : 2 : end, 1 : 2 : 2 * wt ) ;
ss( 1 : 12 : end ) = -tmp(:) ;
ss( 7 : 12 : end ) = -tmp(:) ;
tmp = pdfs( 2 : 2 : end, 3 : 2 : end ) ;
ss( 6 : 12 : end ) = -tmp(:) ;
ss( 12 : 12 : end ) = -tmp(:) ;

tmp = pdfs( 1 : 2 : 2 * ht, 2 : 2 : end ) ;
ss( 2 : 12 : end ) = -tmp(:) ;
ss( 8 : 12 : end ) = -tmp(:) ;
tmp = pdfs( 3 : 2 : end, 2 : 2 : end ) ;
ss( 5 : 12 : end ) = -tmp(:) ;
ss( 11 : 12 : end ) = -tmp(:) ;

upad = padarray( u, [1 1] ) ;
vpad = padarray( v, [1 1] ) ;

pdfaltsumu = pdfs(2:2:end, 1:2:2*wt) .* ( upad(2:ht+1, 1:wt) - upad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 2:2:end, 3:2:end) .* ( upad(2:ht+1, 3:end) - upad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 1:2:2*ht, 2:2:end) .* ( upad(1:ht, 2:wt+1) - upad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 3:2:end, 2:2:end) .* ( upad(3:end, 2:wt+1) - upad(2:ht+1, 2:wt+1) ) ;

pdfaltsumv = pdfs(2:2:end, 1:2:2*wt) .* ( vpad(2:ht+1, 1:wt) - vpad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 2:2:end, 3:2:end) .* ( vpad(2:ht+1, 3:end) - vpad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 1:2:2*ht, 2:2:end) .* ( vpad(1:ht, 2:wt+1) - vpad(2:ht+1, 2:wt+1) ) + ...
			pdfs( 3:2:end, 2:2:end) .* ( vpad(3:end, 2:wt+1) - vpad(2:ht+1, 2:wt+1) ) ;

constu = sum( pd .* ( Ikx .* Ikz ), 3 ) - pdfaltsumu ;
constv = sum( pd .* ( Iky .* Ikz ), 3 ) - pdfaltsumv ;

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
