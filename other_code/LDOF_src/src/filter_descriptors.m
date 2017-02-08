function [c1,c2,keep]=filter_descriptors(c1,c2,max_dist)
dists=sqrt(sum((c1-c2).^2,2));
keep=find(dists<max_dist);
c1=c1(keep,:);
c2=c2(keep,:);
end
