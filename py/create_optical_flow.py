import cv2
import numpy as np
frame1 = cv2.imread('../data/tennis492.jpg')
frame2 = cv2.imread('../data/tennis493.jpg')
prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)
next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)

flow_image = np.zeros_like(frame1);

flow = cv2.calcOpticalFlowFarneback(prvs, next, None, 0.5, 3, 15, 3, 5, 1.2, 0);
mag, ang = cv2.cartToPolar(flow[...,0], flow[...,1])

horz = cv2.normalize(flow[...,0], None, 0, 255, cv2.NORM_MINMAX)
vert = cv2.normalize(flow[...,1], None, 0, 255, cv2.NORM_MINMAX)
horz = horz.astype('uint8')
vert = vert.astype('uint8')

flow_image[...,0] = horz;
flow_image[...,1] = vert;
flow_image[...,2] = cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX);

flow_image[..., 2] = cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX);
rgb = cv2.cvtColor(flow_image, cv2.COLOR_HSV2BGR);
cv2.imwrite('flow_image.jpg', rgb)

np.savetxt('save_data.txt', flow_image[...,0], '%3d\n')
