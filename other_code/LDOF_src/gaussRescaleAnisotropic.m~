function I,Ix_pen,Iy = gaussRescaleAnisotropic(I_ori, l, scale, omega,Ix_pen,Iy_pen)

[h, w, ~] = size(I_ori);

scale_c = scale^(l-1);
omega = omega/scale_c;

%I = gaussSmooth(I_ori, omega);
I=anisotropic_smoothing(I_ori,ceil(omega),Ix_pen,Iy_pen);

if l > 1
    I = imresize(I, [round(h*scale_c), round(w*scale_c)], 'bilinear');
    Ix_pen=imresize(Ix_pen, [round(h*scale_c), round(w*scale_c)], 'nearest');
    Iy_pen=imresize(Iy_pen, [round(h*scale_c), round(w*scale_c)], 'nearest');
end