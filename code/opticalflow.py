import cv2
import numpy as np
frame1 = cv2.imread('a.jpg')
frame2 = cv2.imread('b.jpg')
prvs = cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)
next = cv2.cvtColor(frame2,cv2.COLOR_BGR2GRAY)

flow_image = np.zeros_like(frame1);
# print flow_image.shape
flow_image[...,1] = 255

flow = cv2.calcOpticalFlowFarneback(prvs, next, None, 0.5, 3, 15, 3, 5, 1.2, 0)
mag, ang = cv2.cartToPolar(flow[...,0], flow[...,1])

# Change here
horz = cv2.normalize(flow[...,0], None, 0, 255, cv2.NORM_MINMAX)
vert = cv2.normalize(flow[...,1], None, 0, 255, cv2.NORM_MINMAX)
horz = horz.astype('uint8')
vert = vert.astype('uint8')

flow_image[..., 0] = ang * 180 / np.pi / 2;
flow_image[..., 2] = cv2.normalize(mag, None, 0, 255, cv2.NORM_MINMAX);
rgb = cv2.cvtColor(flow_image, cv2.COLOR_HSV2BGR);

# Change here too
cv2.imshow('Horizontal Component', horz)
cv2.imshow('Vertical Component', vert)
cv2.imshow('flow_image',rgb)

# k = cv2.waitKey(0) & 0xff
# if k == ord('s'): # Change here
cv2.imwrite('opticalflow_horz.pgm', horz)
cv2.imwrite('opticalflow_vert.pgm', vert)
cv2.imwrite('c_python.jpg', rgb)

# cv2.destroyAllWindows()