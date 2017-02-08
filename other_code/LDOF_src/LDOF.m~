function [F,c1,c2]=LDOF(imfile1,imfile2,para,verbose)

im1=imread(imfile1);
im2=imread(imfile2);
im1=double(im1);
im2=double(im2);





%% descriptor matching
disp('extract HOG descriptors....')
[F1, x1, y1] = dense_HOG(im1,...
    para.cellsize, para.dstep,para.nbins,para.dist_bin,para.num_angles);
[F2, x2, y2] = dense_HOG(im2,...
    para.cellsize, para.dstep,para.nbins,para.dist_bin,para.num_angles);
D1=double(reshape(F1,[size(F1,1)*size(F1,2) size(F1,3)]));
D2=double(reshape(F2,[size(F2,1)*size(F2,2) size(F2,3)]));
clear F1  F2


disp('match descriptors....')
[nnidx, dists] = annquery(D2', D1', 2);
n1=size(D1,1);
M1=[[1:n1]' nnidx(1,:)'];



if para.fb_check
    [nnidx2] = annquery(D1', D2', 2);
    n2=size(D2,1);
    M2=[1:n2; nnidx2(1,:)]';

    [M1]=fb_consistency_check(M1,M2,x1,x2,y1,y2,para.dstep+1);
    x1c=x1(M1(:,1));
    y1c=y1(M1(:,1));
    x2c=x2(M1(:,2));
    y2c=y2(M1(:,2));
    c1=[x1c y1c];
    c2=[x2c y2c];
    confidence=(dists(2,M1(:,1))-dists(1,M1(:,1)))./(dists(1,M1(:,1))+eps);
else
    c1=[x1 y1];
    c2=[x2(nnidx(1,:)) y2(nnidx(1,:))];
    confidence=(dists(2,:)-dists(1,:))./(dists(1,:)+eps);
end

[c1,c2,keep]=filter_descriptors(c1,c2,para.max_dist);
confidence=confidence(keep);
if verbose
visualize_correspondence(im1,im2,c1(:,1)',c1(:,2)',...
    c2(:,1)',c2(:,2)',11);
end


%%

O,ti potheite paidiadisp('coarse to fine variational optical flow...')


F = variational_descriptor_flow(im1,im2,confidence,...
    c1,c2,para,verbose);




