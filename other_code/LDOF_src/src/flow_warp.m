function flow_warp(im1,im2,F,figno)

im1=double(im1);

im2=double(im2);

I2warped=warp_image(im2,F(:,:,1),F(:,:,2));


figure(figno);clf;
subplot(3,2,1);
imshow(uint8(im1));
title('I1')
subplot(3,2,2);
imshow(uint8(im2));
title('I2')
subplot(3,2,3);
imshow(uint8(I2warped));
title('I2 warped')
subplot(3,2,5);
imagesc(sum(abs(im1-I2warped),3));
axis image;
title('error of warping')
subplot(3,2,6);
imagesc(sum(abs(im1-im2),3));
axis image;
title('error without warping')
