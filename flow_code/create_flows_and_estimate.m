function create_flows_and_estimate()
    datapath = '/home/peng/dataset/uclOpticalFlow_v1.2';
    savepath = '/home/peng/dataset/deqing_flow';

    list = clean_dir(datapath);

    if ~isdir(savepath)
        mkdir(savepath)
    end
    
    fid = fopen(sprintf('%s/errorfile.txt',savepath),'w');
    
    for i = 1:length(list)
        video = list{i};
        frames = clean_dir(sprintf('%s/%s',datapath,video));
        for j = 1:length(frames)
            im1 = double(imread(sprintf('%s/%s/%s/1.png',datapath,video,frames{j})));
            im2 = double(imread(sprintf('%s/%s/%s/2.png',datapath,video,frames{j})));
            if (size(im1,3) == 1)
                continue;
            end
            
%             method = 'classic+nl-fast';
%             flow = estimate_flow_interface(im1, im2, method);
%             if ~isdir(sprintf('%s/%s/%s',savepath,video,frames{j}))
%                 mkdir(sprintf('%s/%s/%s',savepath,video,frames{j}))
%             end
%             save(sprintf('%s/%s/%s/deqing.mat',savepath,video,frames{j}), 'flow');
            
            flowmat = load(sprintf('%s/%s/%s/deqing.mat',savepath,video,frames{j}), 'flow');
            flow = flowmat.flow;
            
            [tu, tv] = read_gt(sprintf('%s/%s/%s/1_2.flo',datapath,video,frames{j}));
            u = flow(:,:,1);
            v = flow(:,:,2);
            
            tu = scale(tu);
            tv = scale(tv);            
            u = scale(u);
            v = scale(v);
            
            [aae stdae aepe] = flowAngErr(tu, tv, u, v, 0);
            % [aae stdae aepe] = flowAngErr(tu(1:5, 1:5), tv(1:5, 1:5), u(1:5, 1:5), v(1:5, 1:5), 0);
            fprintf(sprintf('%s/%s/%s',savepath,video,frames{j}));
            fprintf('\nAAE %3.3f average EPE %3.3f \n', aae, aepe);
%             fprintf(fid,sprintf('%s/%s/%s:',savepath,video,frames{j}));
            fprintf(fid,'%3.3f %3.3f\n', aae, aepe);
        end
    end
    fclose(fid);
end    


function files = clean_dir(base)
    %clean_dir just runs dir and eliminates files in a foldr
    files = dir(base);
    files_tmp = {};
    for i = 1:length(files)
        if strncmpi(files(i).name, '.',1) == 0
            files_tmp{length(files_tmp)+1} = files(i).name;
        end
    end
    files = files_tmp;
end
    
    
function [tu, tv] = read_gt(filename)
    fid = fopen(filename, 'r');
    if (fid < 0)
        error('readFlowFile: could not open %s', filename);
    end;
    
    tag     = fread(fid, 1, 'float32');
    width   = fread(fid, 1, 'int32');
    height  = fread(fid, 1, 'int32');

    % sanity check
    if (width < 1 || width > 99999)
        error('readFlowFile(%s): illegal width %d', filename, width);
    end;

    if (height < 1 || height > 99999)
        error('readFlowFile(%s): illegal height %d', filename, height);
    end;

    nBands = 2;

    % arrange into matrix form
    tmp = fread(fid, inf, 'float32');
    tmp = reshape(tmp, [width*nBands, height]);
    tmp = tmp';

    img = zeros(height, width, nBands);
    img(:,:,1) = tmp(:, (1:width)*nBands-1);
    img(:,:,2) = tmp(:, (1:width)*nBands);

    tu = img(:, :, 1);
    tv = img(:, :, 2);

    fclose(fid);
end


function u = scale(u)
    umax = max(max(u));
    umin = min(min(u));
    u = (u - umin) / (umax - umin);
end