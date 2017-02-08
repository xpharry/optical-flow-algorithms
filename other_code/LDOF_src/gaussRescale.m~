function I = gaussRescale(I_ori, l, scale, omega)

[h, w, ~] = size(I_ori);

scale_c = scale^(l-1);
omega = omega*1/(scale_c);

I = gaussSmooth(I_ori, omega);

if l > 1
    I = imresize(I, [round(h*scale_c), round(w*scale_c)]);
end