function h=flow_edge_map(im1,im2,F,figno,pb_file1,pb_file2)
[p,q,r]=size(im1);

if r>1
    im1=rgb2gray(uint8(im1));
end
if r>1
    im2=rgb2gray(uint8(im2));
end

if ~exist('pb_file1','var')| isempty(pb_file1)
    e1=double(edge(im1,'canny'));
    e2=double(edge(im2,'canny'));
else
    e1=double(get_edge_map_weiyu(im1,pb_file1)>0.1);
    e2=double(get_edge_map_weiyu(im2,pb_file2)>0.1);
end



e_inds=find(e1);
[ye,xe]=find(e1);


u=F(:,:,1);
v=F(:,:,2);
ye_moved=ye+v(e_inds);
ye_moved=max(1,ye_moved);
ye_moved=min(p,ye_moved);
xe_moved=xe+u(e_inds);
xe_moved=max(1,xe_moved);
xe_moved=min(q,xe_moved);

%interp2()
e1_moved=zeros([p,q]);
inds=sub2ind([p,q],round(ye_moved),round(xe_moved));
e1_moved(inds)=1;
B_before=255*cat(3,e2,e1,zeros(p,q));

h=figure(figno);
subplot2(2,1,1);
imagesc(uint8(B_before));
axis image;
title('the two edge maps before alignment');

B_after=255*cat(3,e2,e1_moved,zeros(p,q));

subplot2(2,1,2);
imagesc(uint8(B_after));
axis image;
title('the two edge maps after alignment');


