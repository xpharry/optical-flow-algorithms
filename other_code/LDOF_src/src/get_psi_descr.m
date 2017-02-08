function Psi_descr=get_psi_descr(u,v,u_descr,v_descr,delta_inds)
[height,width,~]=size(u);
Psi_descr=zeros(width*height,1);
Psi_descr(delta_inds)=psiDeriv((u(delta_inds)-u_descr(delta_inds)).^2+...
    (v(delta_inds)-v_descr(delta_inds)).^2);