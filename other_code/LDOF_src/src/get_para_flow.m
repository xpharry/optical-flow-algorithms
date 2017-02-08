function para=get_para_flow(p,q)

para.p=p;
para.q=q;
para.alpha = 30;  % weight of smoothness.
para.beta = 300;    % weight for descriptor positions match
para.s = 1.5;               % enlarge the gaussian kernel by s when smoothing the derivatives
para.gamma = 5;             % weight of gradient non-consistency
para.out_iter = 10;          % max iteration of the outer fixed point iteration
para.sor_iter = 5;        % max iteration of sor
para.downsampling = 0.98;   % downsampling rate
% para.sigma = 1.3;
para.sigma = 1/sqrt(2*para.downsampling);  % used for pyramid construction and smooth the derivatives

para.level = ceil((log(40)-log(para.q))/log(para.downsampling));            % levels of pyramid.:we need 70 for very large displacements
para.w = 1.99;
para.median_filtering=1;  %median filtering
para.medianx=5;
para.mediany=5;
para.margsz=[5 5];


%% descriptor matching
para.dstep=4;    %pixel sampling grid step for decsriptor extraction
para.cellsize=5;  %half size of a HOG descriptor
para.dist_bin=4;   %pixel distance between aggregated descriptors in a 8 neighborhood
para.fb_check=1;   %forward-backward check for descriptor matching
para.num_angles=12; %number of angles in HOG
para.nbins=1;       %how many descriptors to aggregate in ach direction
para.max_dist=200;  %maximum allowed eucleidean distance for descriptors matched