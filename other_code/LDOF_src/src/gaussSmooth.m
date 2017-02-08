function I = gaussSmooth(I_ori, omega)

mask = fspecial('gauss', [100, 100], omega);
a = diag(mask);
cut = find(a>0.0001, 1, 'first');
mask = mask(cut:100-cut+1, cut:100-cut+1);
mask = mask/sum(mask(:));

I = imfilter(I_ori, mask, 'replicate');