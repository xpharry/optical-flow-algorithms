% reverse-warp image I2 into I1 according to the optical flow field V
function [X] = image_warp(I1, I2, V)
  % alloc space for result
  X = zeros(size(I1));
  
  % get 1D indices for offsets (taken from V)
  [h w c] = size(I1);
  p = cell(2,1);
  [p{:}] = meshgrid(1:w,1:h);

  offseti = cell(2,1);
  offseti{1} = convertIdx3D1D([p{2}(:),p{1}(:),ones([numel(p{1}) 1])],...
			      size(V));
  offseti{2} = convertIdx3D1D([p{2}(:),p{1}(:),2*ones([numel(p{1}) 1])],...
			      size(V));

  % compute sample positions from offsets
  q = cell(2,1); % (x,y)

  q{1} = reshape(p{1}(:) + V(offseti{1}),size(p{1}));
  q{2} = reshape(p{2}(:) + V(offseti{2}),size(p{2}));
  
  % sample I2 at offset positions for all 3 color channels
  for i=1:3,
    X(:,:,i) = interp2(p{1},p{2},I2(:,:,i),q{1},q{2},'cubic');
  end;
