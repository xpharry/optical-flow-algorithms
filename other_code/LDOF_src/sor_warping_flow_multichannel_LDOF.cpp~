// // [du,dv]=sor_warping_flow(ix,iy,iz, ixx, ixy, iyy, ixz,...
// iyz,psi_data, psi_smooth_east, psi_smooth_south, du, dv,u,v,alpha,gamma,sor_iter,w)

# include "mex.h"
# include "math.h"

#define at_r(ptr, y, x, c)  ( ((y)<0 || (y)>=raws || (x)<0 || (x)>=cols) ? 0.0 : (ptr)[(y) + ((x) + (c)*cols)*raws] )
#define lat_r(ptr, y, x, c) ((ptr)[(y) + ((x) + (c)*cols)*raws])


void sor(double* u_descr, double* v_descr, double * ro_descr, double* psi_descr,
        double* ix, double* iy, double* iz, double* ixx, double* ixy, double* iyy,
        double* ixz, double* iyz, double* psi_data, double* psi_smooth_east,
        double* psi_smooth_south,
        double* du, double* dv, double* u, double* v, double alpha, double beta,
        double gamma, double sor_iter, int p, int q, int nchannels, double w) {
    int iter=0;
    int i, j, k, n;
    double psi_n, psi_s, psi_w, psi_e,
            u_n, u_s, u_w, u_e,
            v_n, v_s, v_w, v_e,
            du_n, du_s, du_w, du_e,
            dv_n, dv_s, dv_w, dv_e;
    // B_coef_u, B_const_u, B_coef_v, B_const_v, Aiipart_u, Aiipart_v;
    n=p*q;
//       mexPrintf("\t\t\t  p=%d, q=%d, nchannels=%d \n", p, q, nchannels);
//       return;
    double *B_coef_u = (double*)mxCalloc(n, sizeof(double));
    double *B_const_u = (double*)mxCalloc(n, sizeof(double));
    double *B_coef_v = (double*)mxCalloc(n, sizeof(double));
    double *B_const_v = (double*)mxCalloc(n, sizeof(double));
    double *Aiipart_u = (double*)mxCalloc(n, sizeof(double));
    double *Aiipart_v = (double*)mxCalloc(n, sizeof(double));
    
    for (i=0; i<n; i++) {
        B_coef_u[i]=0.0;
        B_const_u[i]=0.0;
        B_coef_v[i]=0.0;
        B_const_v[i]=0.0;
        Aiipart_u[i]=0.0;
        Aiipart_v[i]=0.0;
        for (k=0; k<nchannels; k++) {
            j=k*n+i;
            B_coef_u[i]+=psi_data[j]*(ix[j]*iy[j]+gamma*ixx[j]*ixy[j]+gamma*ixy[j]*iyy[j]);
            B_const_u[i]+=psi_data[j]*(ix[j]*iz[j]+gamma*ixx[j]*ixz[j]+gamma*ixy[j]*iyz[j]);
            
            
            
            B_coef_v[i]+=psi_data[j]*(ix[j]*iy[j]+gamma*ixx[j]*ixy[j]+gamma*ixy[j]*iyy[j]);
            B_const_v[i]+=psi_data[j]*(iy[j]*iz[j]+gamma*ixy[j]*ixz[j]+gamma*iyy[j]*iyz[j]);
            
            
            
            Aiipart_u[i]+=psi_data[j]*(pow(ix[j], 2)+gamma*pow(ixy[j], 2)+gamma*pow(ixx[j], 2));
            Aiipart_v[i]+=psi_data[j]*(pow(iy[j], 2)+gamma*pow(ixy[j], 2)+gamma*pow(iyy[j], 2));
            //adding the descriptors
            
            if (k==0)
            {B_const_u[i]+=beta*ro_descr[i]*psi_descr[i]*(u[i]-u_descr[i]);
             B_const_v[i]+=beta*ro_descr[i]*psi_descr[i]*(v[i]-v_descr[i]);
             
             Aiipart_u[i]+=beta*ro_descr[i]*psi_descr[i];
             Aiipart_v[i]+=beta*ro_descr[i]*psi_descr[i];
            }
            
            
        }
    }
    
    
    
    
    for (iter=0; iter<sor_iter; iter++) {
        
        for (i=0; i<n; i++) {
            
            psi_n=((i%p==0)?0.0:psi_smooth_south[i-1]);
            psi_s=((i%p==p-1)?0.0:psi_smooth_south[i]);
            psi_w=((i<p)?0.0:psi_smooth_east[i-p]);
            psi_e=((i>=(q-1)*p)?0.0:psi_smooth_east[i]);
            
            u_n=((i%p==0)?0.0:u[i-1]);
            u_s=((i%p==p-1)?0.0:u[i+1]);
            u_w=((i<p)?0.0:u[i-p]);
            u_e=((i>=(q-1)*p)?0.0:u[i+p]);
            
            v_n=((i%p==0)?0.0:v[i-1]);
            v_s=((i%p==p-1)?0.0:v[i+1]);
            v_w=((i<p)?0.0:v[i-p]);
            v_e=((i>=(q-1)*p)?0.0:v[i+p]);
            
            du_n=((i%p==0)?0.0:du[i-1]);
            du_s=((i%p==p-1)?0.0:du[i+1]);
            du_w=((i<p)?0.0:du[i-p]);
            du_e=((i>=(q-1)*p)?0.0:du[i+p]);
            
            dv_n=((i%p==0)?0.0:dv[i-1]);
            dv_s=((i%p==p-1)?0.0:dv[i+1]);
            dv_w=((i<p)?0.0:dv[i-p]);
            dv_e=((i>=(q-1)*p)?0.0:dv[i+p]);
            
            
            
            
            du[i]=(1-w)*du[i]+
                    (w*(psi_n*(u_n+du_n)+
                    psi_e*(u_e+du_e)+
                    psi_w*(u_w+du_w)+
                    psi_s*(u_s+du_s)-
                    (psi_n+psi_e+psi_w+psi_s)*u[i])-
                    (w/alpha)*(B_coef_u[i]*dv[i]+B_const_u[i]))
                    /(psi_n+psi_e+psi_w+psi_s+
                    (1/alpha)*Aiipart_u[i]);
            if ((psi_n+psi_e+psi_w+psi_s+
                    (1/alpha)*Aiipart_u[i])==0)
            { mexPrintf("u zero denominator");}
            
            
            dv[i]=(1-w)*dv[i]+
                    (w*(psi_n*(v_n+dv_n)+
                    psi_e*(v_e+dv_e)+
                    psi_w*(v_w+dv_w)+
                    psi_s*(v_s+dv_s)-
                    (psi_n+psi_e+psi_w+psi_s)*v[i])-
                    (w/alpha)*(B_coef_v[i]*du[i]+B_const_v[i]))
                    /(psi_n+psi_e+psi_w+psi_s+
                    (1/alpha)*Aiipart_v[i]);
         //    if ((psi_n+psi_e+psi_w+psi_s+
          //          (1/alpha)*Aiipart_v[i])==0)
            if isnan(dv[i])
           // if isnan(-0.1)
            { mexPrintf("psi_n=%f \t",(psi_n+psi_e+psi_w+psi_s+
          (1/alpha)*Aiipart_v[i]));
              { mexPrintf("denom=%f \t",(psi_n+psi_e+psi_w+psi_s+
          (1/alpha)*Aiipart_v[i]));
                { mexPrintf("denom=%f \t",(psi_n+psi_e+psi_w+psi_s+
          (1/alpha)*Aiipart_v[i]));
                  { mexPrintf("denom=%f \t",(psi_n+psi_e+psi_w+psi_s+
          (1/alpha)*Aiipart_v[i]));
                    { mexPrintf("denom=%f \t",(psi_n+psi_e+psi_w+psi_s+
          (1/alpha)*Aiipart_v[i]));
                      mexPrintf("END.");
                      return;
                
               // mexPrintf("v zero denominator");
            }
        }
    }
    
    mxFree(B_coef_u);
    mxFree(B_const_u);
    mxFree(B_coef_v);
    mxFree(B_const_v);
    mxFree(Aiipart_u);
    mxFree(Aiipart_v);
    return;
}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
        const mxArray *prhs[]) {
    /* declare variables */
    double *ix, *iy, *iz, *ixx, *iyy, *ixy, *ixz, *iyz, *psi_data, *psi_smooth_east,
            *psi_smooth_south, *du, *dv, *u, *v, *dum;
    double *u_descr, *v_descr,  *ro_descr,  *psi_descr;
    double *dims;
    double alpha, beta,  gamma, sor_iter, w;
    int p, q, nchannels, i;
    mwSize elements;
//     if (nrhs < 18) {
// //         mexerrmsgtxt("not enough input arguments!!");
// //     }
    ix=mxGetPr(prhs[0]);
    elements=mxGetNumberOfElements(prhs[0]);
    //mexPrintf("\t\t\t  NumElems=%d \n", elements);
    iy=mxGetPr(prhs[1]);
    elements=mxGetNumberOfElements(prhs[1]);
    //mexPrintf("\t\t\t  NumElems=%d \n", elements);
    iz=mxGetPr(prhs[2]);
    ixx=mxGetPr(prhs[3]);
    ixy=mxGetPr(prhs[4]);
    iyy=mxGetPr(prhs[5]);
    ixz=mxGetPr(prhs[6]);
    iyz=mxGetPr(prhs[7]);
    elements=mxGetNumberOfElements(prhs[7]);
    //mexPrintf("\t\t\t  NumElems=%d \n", elements);
    psi_data=mxGetPr(prhs[8]);
    elements=mxGetNumberOfElements(prhs[8]);
    //mexPrintf("\t\t\t  NumElems=%d \n", elements);
    psi_smooth_east=mxGetPr(prhs[9]);
    psi_smooth_south=mxGetPr(prhs[10]);
    du=mxGetPr(prhs[11]);
    dv=mxGetPr(prhs[12]);
    u=mxGetPr(prhs[13]);
    v=mxGetPr(prhs[14]);
    p=mxGetScalar(prhs[15]);
    q=mxGetScalar(prhs[16]);
    nchannels=mxGetScalar(prhs[17]);
    dum=mxGetPr(prhs[18]);
    alpha=dum[0];
    dum=mxGetPr(prhs[19]);
    gamma=dum[0];
    dum=mxGetPr(prhs[20]);
    sor_iter=dum[0];
    dum=mxGetPr(prhs[21]);
    w=dum[0];
    
    //descriptors
    u_descr=mxGetPr(prhs[22]);
    v_descr=mxGetPr(prhs[23]);
    ro_descr=mxGetPr(prhs[24]);
    psi_descr=mxGetPr(prhs[25]);
    dum=mxGetPr(prhs[26]);
    beta=dum[0];
    
    //  , double* v_descr, double * ro, double psi_descr
    //mexPrintf("\t\t\t  p=%d, q=%d, nchannels=%dNumEl=%d\n", p, q, nchannels, p*q*nchannels);
    
//     return;
    sor(u_descr, v_descr,  ro_descr, psi_descr, ix, iy, iz, ixx, ixy, iyy,
            ixz, iyz, psi_data, psi_smooth_east, psi_smooth_south,
            du, dv, u, v, alpha, beta, gamma, sor_iter, p, q, nchannels, w);
    
    
    
    
    return;
}
