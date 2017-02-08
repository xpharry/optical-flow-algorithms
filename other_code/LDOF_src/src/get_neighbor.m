function e_neib = get_neighbor(L, e_ind)

[r,c] = ind2sub(size(L), e_ind);
[rn, cn] = neighbor(r, c);
rn(rn<1 | rn>size(L,1)) = nan;
cn(cn<1 | cn>size(L,2)) = nan;
ind_n = sub2ind(size(L), rn, cn);

e_neib = ind_n;
tmp = L(ind_n(~isnan(ind_n)));
e_neib(~isnan(ind_n)) = tmp;