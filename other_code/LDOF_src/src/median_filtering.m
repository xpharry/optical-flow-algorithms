function imgs=median_filtering(img,n);
if size(img,3)>1
%median filtering of an image with neibghorhood size n
R=medfilt2(img(:,:,1),[n,n]);
G=medfilt2(img(:,:,2),[n,n]);
B=medfilt2(img(:,:,3),[n,n]);
imgs=cat(3,R,G,B);
else
imgs=medfilt2(img,[n,n]);
end
end