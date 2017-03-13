# -*- coding: utf-8 -*-
"""
Author: Peng Xu


This work is one part of replicating of the LRCN paper, following the guide in https://people.eecs.berkeley.edu/~lisa_anne/LRCN_video.

In the original paper, the optical flows is generated using Brox's Algorithm, while we here implement the optical flow algorithm in python with Farnback's Algorithm and hopefully it would be faster than in Matlab.

The code has been tested in Python 3.5 and OpenCV 3.2.

- example use:

- The code accepts RGB input specified the path in "base" and save the generated optical flow images into the folder specified in "save_base".

"""

# clean_dir just runs dir and eliminates files in a folder
import os
import numpy as np
import cv2
import time

# start
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))

base = '/home/peng/LRCN_dataset/frames'
save_base = '/home/peng/LRCN_dataset/flow_images_py'

# obtain the file list
files = os.listdir(base)
# print(files)

# Path to be created
# print(os.path.isdir(save_base))
if not os.path.isdir(save_base):
    os.mkdir(save_base)
    # print("Path is created");

for index in range(len(files)):

    if np.mod(index, 100) == 0:
        print('On item ' + str(index) + ' of ' + str(len(files)))

    video = files[index]

    frames = os.listdir(base + '/' + video)
    # print(frames)

    if len(frames) > 1:

        if not os.path.isdir(save_base + '/' + video):
            os.mkdir(save_base + '/' + video)

        im1 = cv2.imread(base + '/' + video + '/' + frames[1])

        for k in range(len(frames)):
            im2 = cv2.imread(base + '/' + video + '/' + frames[k])

            # this ensures each pair of images are in the same size
            if not (im1.shape == im2.shape):
                print("The two image sizes do not match!")
                width = im1.shape[1]
                height = im1.shape[0]
                im2 = cv2.resize(im2, (width, height), interpolation=cv2.INTER_AREA)

            prvs = cv2.cvtColor(im1, cv2.COLOR_BGR2GRAY)
            next = cv2.cvtColor(im2, cv2.COLOR_BGR2GRAY)

            flow_image = np.zeros_like(im1)

            flow = cv2.calcOpticalFlowFarneback(prvs, next, None, 0.5, 3, 15, 3, 5, 1.2, 0)
            mag, ang = cv2.cartToPolar(flow[..., 0], flow[..., 1])

            horz = cv2.normalize(flow[..., 0], None, 0, 255, cv2.NORM_MINMAX)
            vert = cv2.normalize(flow[..., 1], None, 0, 255, cv2.NORM_MINMAX)
            horz = horz.astype('uint8')
            vert = vert.astype('uint8')

            flow_image[..., 0] = horz
            flow_image[..., 1] = vert
            flow_image[..., 2] = cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX)

            # cv2.imshow('flow_image{0}'.format(frames[k]), flow_image)
            cv2.imwrite(save_base + '/' + video + '/' + frames[k], flow_image)
            print(save_base + '/' + video + '/' + frames[k])
            im1 = im2

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))