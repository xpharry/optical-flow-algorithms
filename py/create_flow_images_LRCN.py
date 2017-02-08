# clean_dir just runs dir and eliminates files in a foldr
import os
import sys
import numpy as np
import cv2
import time

base = '~/LRCN_dataset/frames';
save_base = '~/LRCN_dataset/save_flows'

# obtain the file list
files = os.listdir(base);
# print(files);

# Path to be created
# print(os.path.isdir(save_base))
if not os.path.isdir(save_base):
    os.mkdir(save_base, 0755);
    # print("Path is created");

for index in range(len(files)):
    print(index);

    if np.mod(index, 100) == 0:
        print('On item ' + str(index) + ' of ' + str(len(files)));

    video = files[index];

    frames = os.listdir(base + '/' + video);
    # print(frames);

    if len(frames) > 1:

        if not os.path.isdir(save_base + '/' + video):
            os.mkdir(save_base + '/' + video, 0755)

        im1 = cv2.imread(base + '/' + video + '/' + frames[1]);

        for k in range(len(frames)):
            im2 = cv2.imread(base + '/' + video + '/' + frames[k]);

            # key line
            # flow = mex_OF(double(im1), double(im2));

            prvs = cv2.cvtColor(im1, cv2.COLOR_BGR2GRAY)
            next = cv2.cvtColor(im2, cv2.COLOR_BGR2GRAY)

            flow_image = np.zeros_like(im1);
            flow_image[..., 1] = 255;

            flow = cv2.calcOpticalFlowFarneback(prvs, next, None, 0.5, 3, 15, 3, 5, 1.2, 0)
            mag, ang = cv2.cartToPolar(flow[..., 0], flow[..., 1])

            horz = cv2.normalize(flow[..., 0], None, 0, 255, cv2.NORM_MINMAX)
            vert = cv2.normalize(flow[..., 1], None, 0, 255, cv2.NORM_MINMAX)
            horz = horz.astype('uint8')
            vert = vert.astype('uint8')

            flow_image[..., 0] = horz;
            flow_image[..., 1] = vert;
            flow_image[..., 2] = cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX);

            # cv2.imshow('flow_image{0}'.format(frames[k]), flow_image);
            cv2.imwrite(save_base + '/' + video + '/' + frames[k], flow_image);
            print(save_base + '/' + video + '/' + frames[k]);
            im1 = im2;
