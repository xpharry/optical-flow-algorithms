# -*- coding: utf-8 -*-
"""
Author: Peng Xu

This code only accepts two frames for testing.

"""

import cv2
import numpy as np
import time

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))

filepath = '/home/peng/projects/optical_flow_algorithms/data/makeup'

frame1 = cv2.imread(filepath + '/0001.jpg')
frame2 = cv2.imread(filepath + '/0001.jpg')

if not (frame1.shape == frame2.shape):
    print("The two image sizes do not match!")
    width = frame1.shape[1]
    height = frame1.shape[0]
    frame2 = cv2.resize(frame2, (width, height), interpolation=cv2.INTER_AREA)

# print(frame1.shape)
# print(frame2.shape)

prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)
next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)

flow_image = np.zeros_like(frame1)

hsv = np.zeros_like(frame1)
hsv[..., 1] = 255

flow = cv2.calcOpticalFlowFarneback(prvs, next, None, 0.5, 3, 15, 3, 5, 1.2, 0)

mag, ang = cv2.cartToPolar(flow[..., 0], flow[..., 1])

mag = mag * 180 / 3.14

horz = cv2.normalize(flow[...,0], None, 0, 255, cv2.NORM_MINMAX)
vert = cv2.normalize(flow[...,1], None, 0, 255, cv2.NORM_MINMAX)
horz = horz.astype('uint8')
vert = vert.astype('uint8')

flow_image[...,0] = horz
flow_image[...,1] = vert
flow_image[...,2] = cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX)

# print(max(flow_image[...,2]))

# flow_image[...,0] *= (flow_image[...,2] > 40)
# flow_image[...,1] *= (flow_image[...,2] > 40)
# flow_image[...,2] *= (flow_image[...,2] > 40)

# flow_image = cv2.medianBlur(flow_image,25)

cv2.imwrite(filepath + '/flow_farnback_with_smooth.jpg', flow_image)

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))