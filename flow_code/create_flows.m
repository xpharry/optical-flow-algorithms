function create_flows()
    datapath = '/home/peng/dataset/uclOpticalFlow_v1.2';
    savepath = '/home/peng/dataset/deqing_flow';

    list = clean_dir(datapath);

    if ~isdir(savepath)
        mkdir(savepath)
    end
    
    for i = 1:length(list)
        video = list{i};
        frames = clean_dir(sprintf('%s/%s',datapath,video));
        for j = 1:length(frames)
            im1 = double(imread(sprintf('%s/%s/%s/1.png',datapath,video,frames{j})));
            im2 = double(imread(sprintf('%s/%s/%s/2.png',datapath,video,frames{j})));
            if (size(im1,3) == 1)
                continue;
            end
            method = 'classic+nl-fast';
            flow = estimate_flow_interface(im1, im2, method);
            if ~isdir(sprintf('%s/%s/%s',savepath,video,frames{j}))
                mkdir(sprintf('%s/%s/%s',savepath,video,frames{j}))
            end
            save(sprintf('%s/%s/%s/deqing.mat',savepath,video,frames{j}), 'flow');
        end
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