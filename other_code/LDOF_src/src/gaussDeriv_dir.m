function [Ix, Iy] = gaussDeriv_dir(I)
% taking the derivation with [-1 0 1] and then do gaussian smoothing
% if para.deriv_old
%     if nargin <= 2
%         sigma = 0.8;
%     end
%
%     k = [-1 0 1];
%
%     Ix_unsmooth = imfilter(I, k, 'replicate');
%     Iy_unsmooth = imfilter(I, k', 'replicate');
%
%     Ixo = gaussSmooth_dir(Ix_unsmooth, sigma);
%     Iyo = gaussSmooth_dir(Iy_unsmooth, sigma);
% else
k = (1/12)*[1 -8 0 8 -1];

Ix = imfilter(I, k, 'replicate');
Iy = imfilter(I, k', 'replicate');
% end