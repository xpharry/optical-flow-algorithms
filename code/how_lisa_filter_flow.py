# -*- coding: utf-8 -*-
"""
Author: Peng Xu

"""
import csv
import os
import numpy as np
import cv2
from PIL import Image
import numpy as np
from matplotlib import pyplot as plt
import math

# global variables
csv_file = '/data/how_lisa_filter_flow/lipstick_g01_c05_patch/patch_csv.csv'
flow_path = '/data/ai-bandits/datasets/optical_flow/flow_images'

print("********* research how lisa filter flows *********\n")


def get_csv_info(csv_file):
    image_names = []
    is_accepted = []
    with open(csv_file, newline='') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        # print(list(spamreader)[0][0])
        for row in spamreader:
            # print(row[0].split(','))
            list = row[0].split(',')
            image_names.append(list[0])
            is_accepted.append(list[-1])
            # print(', '.join(row))

    image_names.pop(0)
    is_accepted.pop(0)

    is_accepted = map(int, is_accepted)

    # print('---------------image_names:---------------\n', image_names)
    # print('---------------is_accepted:---------------\n', is_accepted)

    return image_names, is_accepted


def get_image_path(data_path, image_name):
    image_name_split = image_name.split('.')
    prefix = image_name_split[0]
    prefix_list = prefix.split('_')
    prefix_list.pop(0)
    prefix_list.pop(0)
    prefix = '_'.join(prefix_list)
    image_path = os.path.join(data_path, prefix, image_name)
    return image_path


def image_entropy(img):
    """calculate the entropy of an image"""
    histogram = cv2.calcHist([img],[2],None,[256],[0,256])
    histogram_length = sum(histogram)

    samples_probability = [float(h) / histogram_length for h in histogram]

    return -sum([p * math.log(p, 2) for p in samples_probability if p != 0])


# main
image_names, is_accepted = get_csv_info(csv_file)
# print(is_accepted)

# print(get_image_path(flow_path, image_names[0]))
img_file = get_image_path(flow_path, image_names[0])

# Load an color image
img = cv2.imread(img_file)
# print(img)

# print(image_entropy(img))

entropy_accepted = []
entropy_removed = []
process_bar = 0
for img_name, is_acc in zip(image_names, is_accepted):
    img_file = get_image_path(flow_path, img_name)
    img = cv2.imread(img_file)
    # entropy = image_entropy(img)
    entropy = np.std(img[..., 2])
    if is_acc:
        entropy_accepted.append(entropy)
    else:
        entropy_removed.append(entropy)

    process_bar += 1
    if process_bar % 100 == 0:
        print(process_bar)


import matplotlib.pyplot as pp
val = 1. # this is the value where you want the data to appear on the y-axis.
arr1 = np.asarray(entropy_accepted)
arr2 = np.asarray(entropy_removed)
pp.plot(arr1, np.zeros_like(arr1) + val, 'o')
pp.plot(arr2, np.zeros_like(arr2) - val, 'x')
pp.show()

# plt.hlines(1,1,20)  # Draw a horizontal line
# plt.eventplot(arr, orientation='horizontal', colors='b')
# plt.axis('off')
# plt.show()