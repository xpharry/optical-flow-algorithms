
imfile1='im1.jpg';
imfile2='im2.jpg';



im1=imread(imfile1);
im2=imread(imfile2);

verbose=0;
[p,q,~]=size(im1);
para=get_para_flow(p,q);


[F,c1,c2]=LDOF(imfile1,imfile2,para,verbose);

% check_flow_correspondence(im1,im2,F);
flow_warp(im1,im2,F,1)
flow_view=flowToColor(F);
imwrite(flow_view,[pwd '/view.png'],'png');
