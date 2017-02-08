function flow_warp(im1,im2,F,figno)
if uint8(im1)
    im1=double(im1);
end
I2warped=warp_image(im2,F(:,:,1),F(:,:,2));


figure(figno);clf;
subplot2_tim(3,2,1);
imshow(uint8(im1));
title('I1')
subplot2_tim(3,2,2);
imshow(uint8(I2warped));
title('I2 warped')
subplot2_tim(3,2,4);
imshow(uint8(im2));

subplot2_tim(3,2,3);
imagesc(sum(abs(im1-I2warped),3));
axis image;
title('error of warping')
subplot2_tim(3,2,6);
imagesc(sum(abs(im1-im2),3));
axis image;
title('error without warping')
