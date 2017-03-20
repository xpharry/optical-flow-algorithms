# -*- coding: utf-8 -*-
"""
Author: Peng Xu

output UV is an M*N*2 matrix. UV(:,:,1) is the horizontal flow and
UV(:,:,2) is the vertical flow.

Example
-------
uv = estimate_flow_demo; or estimate_flow_demo;

"""

import sys
import cv2
import numpy as np
from math import pi
import scipy.io

np.set_printoptions(threshold=np.nan)

filepath = '/home/peng/projects/optical_flow/flow_estimation_py/data'


def read_source_frames(filename1, filename2):
    frame1 = cv2.imread(filename1)
    frame2 = cv2.imread(filename2)
    return frame1, frame2


def read_flow_file(filename):
    tag_float = 202021.25  # check for this when READING the file

    idx_list = find_ch(filename, '.')
    idx = idx_list[-1]

    if not filename[idx: ] == '.flo':
        print('readFlowFile: filename {} should have extension ''.flo'''.format(filename))

    fid = open(filename, 'r')

    if fid == -1:
        print('readFlowFile: could not open {}'.format(filename))

    with open(filename, 'rb') as fid:
        arr = np.fromfile(fid, np.float32)
        tag = arr[0]

    with open(filename, 'rb') as fid:
        arr = np.fromfile(fid, np.int32)
        width = arr[1]
        height = arr[2]

    n_bands = 2

    # arrange into matrix form
    with open(filename, 'rb') as fid:
        tmp = np.fromfile(fid, np.float32)
        tmp = tmp[3:].reshape((height, width * n_bands))

    img = np.zeros((height, width, n_bands))

    img[..., 0] = tmp[:, 0:width*n_bands:2]
    img[..., 1] = tmp[:, 1:width*n_bands:2]

    fid.close()

    return img


def read_groud_truth(flow):

    tu = flow[..., 0]
    tv = flow[..., 1]

    # Set unknown values to nan
    unknown_flow_thresh = 1e9
    tu = find_and_set_nan(tu, unknown_flow_thresh)
    tv = find_and_set_nan(tv, unknown_flow_thresh)

    return tu, tv


def find_and_set_nan(input_list, thresh):
    for i in range(len(input_list)):
        for j in range(len(input_list[0])):
            if input_list[i][j] > thresh:
                # print('====ok====')
                # print(input_list[i][j])
                input_list[i][j] = float('nan')
                # print(input_list[i][j])
            # else:
            #     print('====not ok====')
            #     print(input_list[i][j])
            #     print(input_list[i][j])
    return input_list


def find_ch(input_str, char):
    a_list = []
    for i, ch in zip(range(len(input_str)), input_str):
        if ch == char:
            a_list.append(i)
    return a_list


def estimate_flow_farnback(frame1, frame2):

    width = frame1.shape[1]
    height = frame1.shape[0]

    if not (frame1.shape == frame2.shape):
        print("The two image sizes do not match!")
        frame2 = cv2.resize(frame2, (width, height), interpolation=cv2.INTER_AREA)

    prvs = cv2.cvtColor(frame1, cv2.COLOR_BGR2GRAY)
    next = cv2.cvtColor(frame2, cv2.COLOR_BGR2GRAY)

    flow = cv2.calcOpticalFlowFarneback(prvs, next, None, 0.5, 3, 15, 3, 5, 1.2, 0)

    u = flow[..., 0]
    v = flow[..., 1]

    u = cv2.normalize(flow[..., 0], None, 0, 255, cv2.NORM_MINMAX)
    v = cv2.normalize(flow[..., 1], None, 0, 255, cv2.NORM_MINMAX)

    return u, v


def scale_vector(vec):
    vec_max = np.max(vec, 0)
    vec_min = np.min(vec, 0)
    print(vec_max)
    print(vec_min)
    for i in range(len(vec)):
        vec[i] = (vec[i] - vec_min) / (vec_max - vec_min)
    return vec


def get_max(arr):
    maxval = -999.0
    for i in range(len(arr)):
        for j in range(len(arr[0])):
            if np.isnan(arr[i][j]):
                continue
            if arr[i][j] > maxval:
                maxval = arr[i][j]
    return maxval


def get_min(arr):
    minval = +999.0
    for i in range(len(arr)):
        for j in range(len(arr[0])):
            if np.isnan(arr[i][j]):
                continue
            if arr[i][j] < minval:
                minval = arr[i][j]
    return minval


def scale_array(arr):
    arr_max = get_max(arr)
    arr_min = get_min(arr)
    print(arr_max)
    print(arr_min)
    for i in range(len(arr)):
        for j in range(len(arr[0])):
            if np.isnan(arr[i][j]):
                continue
            arr[i][j] = (arr[i][j] - arr_min) / (arr_max - arr_min)
    return arr


def flow_ang_err(tu, tv, u, v):
    valid_idx = []
    for j in range(len(tu[0])):
        for i in range(len(tu)):
            if np.isnan(tu[i][j]) or np.isnan(tv[i][j]):
                continue
            valid_idx.append([i,j])

    idx_len = len(valid_idx)

    stu = np.zeros((idx_len, 1))
    stv = np.zeros((idx_len, 1))
    su = np.zeros((idx_len, 1))
    sv = np.zeros((idx_len, 1))

    for idx, item in enumerate(valid_idx):
        # print(idx, item)
        i = item[0]
        j = item[1]
        stu[idx] = tu[i][j]
        stv[idx] = tv[i][j]
        su[idx] = u[i][j]
        sv[idx] = v[i][j]

    n = np.sqrt(np.square(su) + np.square(sv) + 1)
    # print(n)
    n = np.divide(1.0, n)

    un = su * n
    vn = sv * n

    tn = np.sqrt(np.square(stu) + np.square(stv) + 1)
    tn = np.divide(1, tn)

    tun = stu * tn
    tvn = stv * tn

    ang = np.arccos(un * tun + vn * tvn + n * tn)

    mang = np.mean(ang)
    aae = mang * 180 / pi

    epe = np.sqrt(np.square(stu - su) + np.square(stv - sv))
    aepe = np.mean(epe[:])

    return aae, aepe

if __name__ == '__main__':
    # read ground truth
    flow_image = read_flow_file(filepath + '/other-gt-flow/RubberWhale/flow10.flo')
    tu, tv = read_groud_truth(flow_image)

    print('=============')
    print(tu[0:5, 0:5])

    tu = scale_array(tu)
    tv = scale_array(tv)

    print('-------------')
    print(tu[0:5, 0:5])

    # read flow
    filename1 = filepath + '/other-data/RubberWhale/frame10.png'
    filename2 = filepath + '/other-data/RubberWhale/frame10.png'
    im1, im2 = read_source_frames(filename1, filename2)

    u,v = estimate_flow_farnback(im1, im2)

    print('=============farnback')
    print(u[0:5, 0:5])

    u = scale_array(u)
    v = scale_array(v)

    print('-------------')
    print(u[0:5, 0:5])

    # uvmat = scipy.io.loadmat('/home/peng/projects/optical_flow/flow_estimation_py/data/uvmat.mat')
    # uv = uvmat['uv']
    # uvmat = scipy.io.loadmat('/home/peng/projects/optical_flow/flow_estimation_py/data/flowmat.mat')
    # uv = uvmat['flow']
    # print(type(uv))
    # print(uv.shape)
    # u = uv[..., 0]
    # v = uv[..., 1]

    print('=============brox')
    print(u[0:5, 0:5])

    u = scale_array(u)
    v = scale_array(v)

    print('-------------')
    print(u[0:5, 0:5])

    # compute flow error
    aae, aepe = flow_ang_err(tu, tv, u, v)
    # aae, aepe = flow_ang_err(tu[0:5, 0:5], tv[0:5, 0:5], u[0:5, 0:5], v[0:5, 0:5])
    print('\nAAE {:3.3f} average EPE {:f} \n'.format(aae, aepe))
