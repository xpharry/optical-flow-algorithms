function ImPyramid=getImPyramid2(im,omega,downsampling,max_level)
[p,q,~]=size(im);
%im_or=im;
ImPyramid=cell(max_level,1);

for l=1:max_level
    if l~=2
      I = gaussSmooth(im, omega);
      Ismooth = gaussSmooth(Ismooth, omega);
      %I=im;
    else
        I=im;
    end
    if l > 1
       % I = gaussSmooth(Ismooth, omega);
        scale_c = downsampling^(l-1);
%         I = imresize(I, [round(p*scale_c), round(q*scale_c)], 'bicubic');
        I = imresize(Ismooth,  [round(p*scale_c), round(q*scale_c)], 'bicubic');
%         figure(1);imshow(uint8(I));
%         pause(0.5);
    end
    ImPyramid{l}=I;
   % im=I;
end

end

