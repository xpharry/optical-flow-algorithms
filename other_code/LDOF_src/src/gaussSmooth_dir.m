function I = gaussSmooth_dir(I_ori, omega)
% smoothing considering positive and negative. on each point, choose the
% one with bigger magnitude

mask = fspecial('gauss', [100, 100], omega);
a = diag(mask);
cut = find(a>0.0001, 1, 'first');
mask = mask(cut:100-cut+1, cut:100-cut+1);
mask = mask/sum(mask(:));

Ip = I_ori;
ind = I_ori<0;
Ip(ind) = 0;
Ip = imfilter(Ip, mask, 'replicate');

In = I_ori;
ind = I_ori>=0;
In(ind) = 0;
In = imfilter(In, mask, 'replicate');

I = In;
ind = Ip>abs(In);
I(ind) = Ip(ind);