
import cv2

image = cv2.imread("gym2.jpg")

thumbnail = cv2.resize(image, (400, 227), interpolation = cv2.INTER_AREA)

cv2.imshow('example', thumbnail)
cv2.waitKey(0)
cv2.destroyAllWindows()