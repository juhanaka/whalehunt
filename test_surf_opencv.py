from datetime import datetime
import cv2

img = cv2.imread('data/imgs/w_0.jpg',0)

now = datetime.now()

for i in range(100):
	surf = cv2.SURF(400)
	kp, des = surf.detectAndCompute(img,None)
print datetime.now() - now

