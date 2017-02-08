function [dist]=get_pair_dist_matrix(E,U_p,V_p)
%number of proposals
L=length(U_p);
e=length(E);
dist=zeros(L,L*e);
for i=1:L
    U_pc1=U_p{i};
    V_pc1=V_p{i};
    for j=i:L
        U_pc2=U_p{j};
        V_pc2=V_p{j};
        
        dist(i,[j:L:e*L])=(abs(U_pc1(E(:,1))-U_pc2(E(:,2)))+...
            abs(V_pc1(E(:,1))-V_pc2(E(:,2))))';
        dist(j,[i:L:e*L])=dist(i,[j:L:e*L]);
    end
end