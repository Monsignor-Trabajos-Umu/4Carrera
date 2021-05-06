# Vaya puto parche hay que hacer para que funcione en consola
#import numpy.core.multiarray
import cv2 as cv
from umucv.stream import autoStream
from umucv.util import ROI
import time


# selección de región de interés más cómoda que cv.selectROI


def savepict(img):
    timestr = time.strftime("%Y%m%d-%H%M%S")
    cv.imwrite(f"{timestr}.png", img)

def main():
    cv.namedWindow('input')
    for key, frame in autoStream():
        # print(roi.roi)
        time.time()
        if int(time.time()) % 3 == 0:
            savepict(frame)
        cv.imshow('input', frame)

    cv.destroyAllWindows()


if __name__ == '__main__':
    main()
