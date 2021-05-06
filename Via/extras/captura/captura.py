#!/usr/bin/env python

import cv2 as cv
from umucv.stream import autoStream
import time




#cap = cv.VideoCapture(0)

#while(cv.waitKey(1) & 0xFF != 27):
#    ret, frame = cap.read()

for key, frame in autoStream():
    cv.imshow('webcam',frame)
    if key == ord('s'):
        cv.imwrite(f"pic_{time.asctime()}.png",frame)

    
cv.destroyAllWindows()

