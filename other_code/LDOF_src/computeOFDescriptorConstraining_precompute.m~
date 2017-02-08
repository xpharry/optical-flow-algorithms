function F = computeOFDescriptorConstraining_precompute(I1s,I2s,...
    confidence,centroids1,centroids2,para)

I1s=getImPyramid(im1,para.omega,para.downsampling,para.level);
I2s=getImPyramid(im2,para.omega,para.downsampling,para.level);

sigma = para.sigma;
s = para.s;
gamma = para.gamma;
max_iter = para.out_iter;
downsampling = para.downsampling;
num_level = para.level;
beta=para.beta;
inds_outofimage=[];


% loop every level
fprintf('\n')
for l = num_level:-1:1
    
    progress(sprintf('\t\t level \n'),para.level-l+1,para.level);

    
    I1=I1s{l};
    I2=I2s{l};
    
    
    [height, width, dim] = size(I1);
    [ys,xs]=ndgrid([1:height],[1:width]);
    
    if l == num_level
        % initial value. They are updated after every level
        u0 = zeros(height, width);
        v0 = zeros(height, width);
    end

    
    
    
    % duv is the reordering of du and dv, just for convenience
    duv = zeros(2*height*width, 1);
    du = zeros(height, width);
    dv = zeros(height, width);
    
    % compute the derivatives, smoothing considering the directions
    [Ix1, Iy1] = gaussDeriv_dir(I1, para,s*sigma);
    [Ix2, Iy2] = gaussDeriv_dir(I2, para,s*sigma);
    %warp the derivative according to the current displacement
    Ix2_warped = warp_image(Ix2, u0, v0);
    Iy2_warped = warp_image(Iy2, u0, v0);
    
    %estimate derivative direction by mixing i1 and i2 deivatives
    Ix_warped = 0.5*(Ix2_warped+Ix1);
    Iy_warped = 0.5*(Iy2_warped+Iy1);
    
    I2_warped = warp_image(I2,u0,v0);
    Iz_warped = I2_warped-I1;
    
    [Ixx1, Ixy1] = gaussDeriv_dir(Ix1, para,s*sigma);
    [~, Iyy1] = gaussDeriv_dir(Iy1, para,s*sigma);
    [Ixx2, Ixy2] = gaussDeriv_dir(Ix2, para,s*sigma);
    [~, Iyy2] = gaussDeriv_dir(Iy2, para,s*sigma);
    
    %same with second order derivatives
    Ixx_warped = 0.5*(warp_image(Ixx2, u0, v0)+Ixx1);
    Ixy_warped = 0.5*(warp_image(Ixy2, u0, v0)+Ixy1);
    Iyy_warped = 0.5*(warp_image(Iyy2, u0, v0)+Iyy1);
    
    Ixz_warped = Ix2_warped-Ix1;
    Iyz_warped = Iy2_warped-Iy1;
    
    Ixz_warped = fix_margin(Ixz_warped, inds_outofimage);
    Iyz_warped = fix_margin(Iyz_warped, inds_outofimage);
    Ixx_warped = fix_margin(Ixx_warped, inds_outofimage);
    Ixy_warped = fix_margin(Ixy_warped, inds_outofimage);
    Iyy_warped = fix_margin(Iyy_warped, inds_outofimage);
    Iyz_warped = fix_margin(Iyz_warped, inds_outofimage);
    
    
    %transform the descriptor matches to the current scale
    centroids1_c=[centroids1(:,1)*width/para.q centroids1(:,2)*height/para.p];
    centroids2_c=[centroids2(:,1)*width/para.q centroids2(:,2)*height/para.p];
    c1r=round(centroids1_c);
    c2r=round(centroids2_c);
    keep=find(c1r(:,1)>0&c1r(:,2)>0&c1r(:,1)>0&c2r(:,2)>0 & ...
        c2r(:,2)<=height & c1r(:,2)<=height & c2r(:,1)<=width& c1r(:,1)<=width);
    centroids1_c=centroids1_c(keep,:);
    centroids2_c=centroids2_c(keep,:);
    confidence_c=confidence(keep);
    delta_inds=sub2ind([height width],round(centroids1_c(:,2)),...
        round(centroids1_c(:,1)));
    
    
    if 0%l==1
        %check the descriptor match in the current scale
        visualize_correspondence(I1,I2,centroids1_c(:,1)',centroids1_c(:,2)',...
            centroids2_c(:,1)',centroids2_c(:,2)',11);
    end
    u_descr=zeros(width*height,1);
    u_descr(delta_inds)=centroids2_c(:,1)-centroids1_c(:,1);
    v_descr=zeros(width*height,1);
    v_descr(delta_inds)=centroids2_c(:,2)-centroids1_c(:,2);
    ro_descr=zeros(width*height,1);
    ro_descr(delta_inds)=confidence_c;
    
    

    % fix point inner interation
    for iter = 1:max_iter
        % duplicate du and dv on multiple channels to adapt to color image
        du_c = repmat(du,[1,1,dim]);
        dv_c = repmat(dv,[1,1,dim]);
        
        Psi_data = psiDeriv((Iz_warped+Ix_warped.*du_c+Iy_warped.*dv_c).^2 +...
            gamma*((Ixz_warped+Ixx_warped.*du_c+Ixy_warped.*dv_c).^2+...
            (Iyz_warped+Ixy_warped.*du_c+Iyy_warped.*dv_c).^2));
        
      
        
        [Psi_smooth_x, Psi_smooth_y] = get_psi_smooth(u0+du,v0+dv);
        
        
        
        du=du_c(:,:,1);
        dv=dv_c(:,:,1);
        
        Psi_descr=get_psi_descr(u0+du,u0+dv,u_descr,v_descr,delta_inds);
        
        sor_warping_flow_multichannel_LDOF(Ix_warped, Iy_warped, Iz_warped, ...
            Ixx_warped, Ixy_warped, Iyy_warped, Ixz_warped, Iyz_warped, ...
            Psi_data, Psi_smooth_x, Psi_smooth_y, du, ...
            dv,u0(:,:,1),v0(:,:,1),size(Ix_warped,1),...
            size(Ix_warped,2),size(Ix_warped,3),para.alpha,...
            para.gamma,para.sor_iter,para.w,u_descr,...
            v_descr,ro_descr,Psi_descr,beta);
        
        
        inds_outofimage=find((xs+u0+du<1 | xs+u0+du>width | ys+dv+v0<1 | ys+du+v0>height));
        
        
        if iter==max_iter & para.median_filtering
            du = medfilt2(du, [para.medianx para.mediany]);
            dv = medfilt2(dv, [para.medianx para.mediany]);
        end
        if para.verbose && iter==max_iter
            u = u0+du;
            v = v0+dv;
            flow_warp(I1,I2,cat(3,u,v),1)
            %check_flow_correspondence(I1,I2,cat(3,u,v));
           % flow_edge_map(I1,I2,cat(3,u,v),1);
            title(['pyramid level ' num2str(l)])
        end
    end
    
    % update the optical flow
    u = u0+du;
    v = v0+dv;
    if l > 1
        % interpolate to get the initial value of the finner pyramid level
        scale_next = downsampling^(l-2);
        h_f = round(para.p*(scale_next));
        w_f = round(para.q*(scale_next));
        u0 = imresize(u, [h_f, w_f], 'bilinear');
        v0 = imresize(v, [h_f, w_f], 'bilinear');
    end

end

F=cat(3,u,v);
fprintf('done!\n');
end
function A = fix_margin(A, inds)
if isempty(inds) return; end
[p,q,r]=size(A);
for i=1:r
    A(inds+(i-1)*p*q)=0;
end
end