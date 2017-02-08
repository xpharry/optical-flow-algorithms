function psi_data=get_psi_data_weighted(d1square,d2square,gamma,temperature)
w1=1/(1+exp(temperature*(psi(d1square)-psi(d2square))));
w2=1-w1;
psi_data=w1.*psiDeriv(d1square)+gamma*w2.*psiDeriv(d2square);
end