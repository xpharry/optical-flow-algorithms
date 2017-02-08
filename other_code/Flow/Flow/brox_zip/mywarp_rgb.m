function warpedim = mywarp_rgb( im1, u, v )

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.

[h w d] = size(im1) ;

[uc vc] = meshgrid( 1:w, 1:h ) ;

uc1 = uc + u ;
vc1 = vc + v ;

warpedim = zeros( size(im1) ) ;
tmp = zeros(h, w) ;

tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 1))), uc1(:), vc1(:), 'bilinear') ;
warpedim(:, :, 1) = tmp ;
tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 2))), uc1(:), vc1(:), 'bilinear') ;
warpedim(:, :, 2) = tmp ;
tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 3))), uc1(:), vc1(:), 'bilinear') ;
warpedim(:, :, 3) = tmp ;
