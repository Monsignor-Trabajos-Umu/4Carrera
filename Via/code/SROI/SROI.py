import cv2 as cv
import numpy as np
from collections import deque
from umucv.stream import autoStream
from umucv.util import ROI
import time


# selección de región de interés más cómoda que cv.selectROI


def savepict(savedQueue: deque):
    for img in savedQueue:
        timestr = time.strftime("%Y%m%d-%H%M%S")
        cv.imwrite(f"./rois/roi_{timestr}.png", img)

def capture_roi(roi: ROI, frame, key, savedQueue: deque):
    """
    Seleciona un ROI y si se pulsa la telca t se guarda en la cola
    Args:
        roi: ROI
        frame: Imagen del frame
        key: Tecla pulsad
        savedQueue: Deque donde guardar el trozo del roi

    """
    # seleccionamos una región
    if roi.roi:
        [x1, y1, x2, y2] = roi.roi

        if key == ord('t'):
            trozo = frame[y1:y2 + 1, x1:x2 + 1].copy()
            cv.imshow('trozo', trozo)
            # suavizado opcional
            # quitar el roi cuando se selecciona la región
            roi.roi = []
            savedQueue.append(trozo)

        cv.rectangle(frame, (x1, y1), (x2, y2), color=(0, 255, 255), thickness=2)
def main():
    cv.namedWindow('input')
    roi = ROI('input')
    savedROIS = deque()

    for key, frame in autoStream():
        # print(roi.roi)
        if key == ord('s'):
            savepict(savedROIS)
        capture_roi(roi, frame, key, savedROIS)
        cv.imshow('input', frame)

    cv.destroyAllWindows()


if __name__ == '__main__':
    main()
