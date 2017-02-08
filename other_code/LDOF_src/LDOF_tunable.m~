%function [F,Fb]=LDOF_tunable(imfile1,imfile2,verbose)
impath = '/data/v40/katef/UrbanStreetCroppedResized/sequence08/images_left/';
imList = dir([impath '*.jpg']);
imfile1=[impath, imList(25).name];
imfile2=[impath, imList(26).name];
im1=imread(imfile1);
im2=imread(imfile2);
im1=double(im1);
im2=double(im2);
verbose=0;
% [p,q,~]=size(im1);
% rsz=500/max(p,q);
% if rsz<1
%     im1=imresize(im1,rsz);
%     im2=imresize(im2,rsz);
% end

%% Parameters
para=get_para_flow(im1);

%% descriptor matching
[F1, x1, y1] = dense_HOG(im1,...
    para.cellsize, para.dstep,para.nbins,para.dist_bin,para.num_angles);
[F2, x2, y2] = dense_HOG(im2,...
    para.cellsize, para.dstep,para.nbins,para.dist_bin,para.num_angles);
D1=double(reshape(F1,[size(F1,1)*size(F1,2) size(F1,3)]));
D2=double(reshape(F2,[size(F2,1)*size(F2,2) size(F2,3)]));
clear F1  F2
[nnidx, dists] = annquery(D2', D1', 2);
n1=size(D1,1);
M1=[[1:n1]' nnidx(1,:)'];
% x1=x1(:);
% y1=y1(:);
% x2=x2(:);
% y2=y2(:);
% if verbose

%     x1c=x1(M1(:,1));
%     y1c=y1(M1(:,1));
%     x2c=x2(M1(:,2));
%     y2c=y2(M1(:,2));
%     c1=[x1c y1c];
%     c2=[x2c y2c];
%     visualize_correspondence(im1,im2,c1(:,1)',c1(:,2)',...
%         c2(:,1)',c2(:,2)',11);
% end

if para.fb_check
    [nnidx2] = annquery(D1', D2', 2);
    n2=size(D2,1);
    M2=[1:n2; nnidx2(1,:)]';
    %     if verbose
    %         x2c=x2(M2(:,1));
    %         y2c=y2(M2(:,1));
    %         x1c=x1(M2(:,2));
    %         y1c=y1(M2(:,2));
    %         c1=[x1c y1c];
    %         c2=[x2c y2c];
    %         visualize_correspondence(im1,im2,c1(:,1)',c1(:,2)',...
    %             c2(:,1)',c2(:,2)',11,confidence);
    %     end
    [M1]=fb_consistency_check(M1,M2,x1,x2,y1,y2,para.dstep+1);
    x1c=x1(M1(:,1));
    y1c=y1(M1(:,1));
    x2c=x2(M1(:,2));
    y2c=y2(M1(:,2));
    c1=[x1c y1c];
    c2=[x2c y2c];
    if verbose
        visualize_correspondence(im1,im2,c1(:,1)',c1(:,2)',...
            c2(:,1)',c2(:,2)',11);
    end
    confidence=(dists(2,M1(:,1))-dists(1,M1(:,1)))./(dists(1,M1(:,1))+eps);
else
    c1=[x1 y1];
    c2=[x2(nnidx(1,:)) y2(nnidx(1,:))];
    confidence=(dists(2,:)-dists(1,:))./dists(1,:);
end

% c1=c1*1/rsz;
% c2=c2*1/rsz;

[c1,c2,keep]=filter_descriptors(c1,c2,para.max_dist);
confidence=confidence(keep);

% visualize_correspondence(im1,im2,c1(:,1)',c1(:,2)',...
%     c2(:,1)',c2(:,2)',11);

visualize_correspondence(im1,im2,c1(:,1)',c1(:,2)',...
    c2(:,1)',c2(:,2)',11);

%%

fprintf('compute image pyramids... \n')
para.omega=2;
I1s=getImPyramid2(im1,para.omega,2,para.downsampling,para.level,0);
I2s=getImPyramid2(im2,para.omega,2,para.downsampling,para.level,0);
I1s=getImPyramid(im1,para.omega,para.downsampling,para.level);
I2s=getImPyramid(im2,para.omega,para.downsampling,para.level);

%%
close all;
para.beta=300;
para.alpha=30;
%confidence=ones(size(c1,1),1);
para.verbose=1;
para.occlusion=0;
para.median_filtering=0;
para.sor_iter=5;
para.gamma=5;
F = computeOFDescriptorConstraining_precompute(I1s,I2s,confidence,...
    c1,c2,para);
%  check_flow_correspondence(im1,im2,F);
% Fnew=zeros(p,q,2);
% Fnew(:,:,1)=imresize(F(:,:,1),[p q],'nearest');
% Fnew(:,:,2)=imresize(F(:,:,2),[p q],'nearest');
% im1=imread(imfile1);
% im2=imread(imfile2);
%   check_flow_correspondence(double(im1),double(im2),Fnew);
Fb = computeOFDescriptorConstraining_precompute(I2s,I1s,confidence,c2,c1,...
    para);


% Fb(:,:,1)=imresize(Fb(:,:,1),1/rsz,nearest);
% Fb(:,:,2)=imresize(Fb(:,:,2),1/rsz,nearest);

%check_flow_correspondence(im1,im2,F);

%%
%
% I2warped=warp_image(im2,F(:,:,1),F(:,:,2));
% if 1
%     figure(1);clf;
%     subplot2_tim(3,2,1);
%     imshow(uint8(im1));
%     title('I1')
%     subplot2_tim(3,2,2);
%     imshow(uint8(I2warped));
%     title('I2 warped')
%     subplot2_tim(3,2,4);
%     imshow(uint8(im2));
%     subplot2_tim(3,2,3);
%     imagesc(sum(abs(im1-I2warped),3));
%     axis image;
%     title('error of warping')
%     subplot2_tim(3,2,6);
%     imagesc(sum(abs(im1-im2),3));
%     axis image;
%     title('error without warping')
% end
% flow_view = flowToColor(F);
% h=figure(10),clf;imagesc(flow_view);
%
%