import cv2 as cv
import numpy as np
from umucv.stream import autoStream



def bgr2gray(x):
    return cv.cvtColor(x, cv.COLOR_BGR2GRAY)


def main():
    cv.namedWindow('input')
    for key, frame in autoStream():
        cv.imshow('input', frame)
        frame_g = bgr2gray(frame)
        # Arraya (100 x 1 x 2) [[[x,y]],[[x,y]]....
        corners = cv.goodFeaturesToTrack(frame_g, maxCorners=100, qualityLevel=0.01, minDistance=10)
        corners = np.int0(corners)

        for i in corners:
            # i = [[x,y]] ravel me aplana el array -> [x,y]
            x, y = i.ravel()
            cv.circle(frame, (x, y), 5, 255, -1)

        cv.imshow('input_puntos', frame)

    cv.destroyAllWindows()


if __name__ == '__main__':
    main()
