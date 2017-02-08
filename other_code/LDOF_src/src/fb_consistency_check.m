function [M1,M2]=fb_consistency_check(M1,M2,x1,x2,y1,y2,thresh)

%M1,M2: n1 X 2, n2 X 2
%how many of the 2d image are matched?
% M1=sort(M1,2);
% M2=sort(M2,2);
if nargin<3
    a=ismember(M1,[M2(:,2)  M2(:,1)],'rows');
    M1=M1(a,:);
    a=ismember(M2,[M1(:,2)  M1(:,1)],'rows');
    M2=M2(a,:);
else
    
    [a,loc]=ismember(M1(:,2),M2(:,1));
    inds1_back=M2(loc,2);
    inds1=M1(find(a),1);
   % inds2=loc(find(loc));
    dists=sqrt((x1(inds1)-x2(inds1_back)).^2+(y1(inds1)-y2(inds1_back)).^2);
    M1=M1(inds1(dists<thresh),:);
    M2=[];
    %M2=M2(inds2(dists<thresh),:);
end
