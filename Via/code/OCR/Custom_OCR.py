import glob
import pickle
import threading
# Tecnicamente append y popleft son operaciones atomicas y len() tambien
from collections import deque
from typing import List, Tuple, Deque

import cv2 as cv
import numpy as np
from umucv.stream import Camera
from matcher_class.conv_matcher import ConvMatcher


def show_predict(frame, predicted_img: np.ndarray, regions, values):
    """
    Ponemos los datos pre
    Args:
        frame:
        predicted_img:
        regions:
        values:

    Returns:

    """
    actual_frame = frame.copy()
    value = 0
    for (x1, y1), (x2, y2) in regions:
        if x2 - x1 > 13 and y2 - y1 > 13:
            current_value = str(values[value])
            cv.putText(actual_frame,  # numpy array on which text is written
                       current_value,  # text
                       (x1, y1),  # position at which writing has to start
                       cv.FONT_HERSHEY_SIMPLEX,  # font family
                       1,  # font size
                       (255, 0, 0),  # font color
                       3)  # font stroke
            cv.rectangle(actual_frame, (x1, y1), (x2, y2), (255, 0, 0), 2)
            value += 1
    # Si el array es muy grande peta
    # TODO reducir el tamño de la imagen predicted_img si es demasido grande
    # Y siempre va a ser 28
    _, p_x, _ = predicted_img.shape
    _, a_x, _ = actual_frame.shape
    if p_x > a_x:
        predicted_img = cv.resize(predicted_img, (a_x, 28), interpolation=cv.INTER_AREA)

    actual_frame[0:predicted_img.shape[0], 0:predicted_img.shape[1]] = predicted_img
    return actual_frame


class ORC:
    def __init__(self, matching: str = None):
        """
        Iniciliazmos la clase SIFT
        Args:
            matching: Sin usar esta puesto para futura retro compatiblidad cuando
            empecie a usar otro tipo de matching
            folderpath:
            mk:
        """
        print("Inicilizando la clase ORC")
        if matching is None:
            matching = ConvMatcher()
        self.matching = matching

    def start(self):
        cam = Camera(debug=False)
        while True:
            frame = cam.frame
            copy_frame = frame.copy()
            # Mostramos el sift
            img, regions = self.matching.prepara_img(copy_frame)
            if regions:
                values = self.matching.predict()
                actual_frame = show_predict(frame, img, regions, values)
            else:
                actual_frame = frame
            cv.imshow("entrada", actual_frame)
            key = cv.waitKey(1) & 0xFF
            if key == ord('q'):
                cam.stop()
                cv.destroyAllWindows()
                exit()


if __name__ == '__main__':
    # kmeans = KmeansMaching(mkAKAZE)
    sf = ORC(matching=None)
    sf.start()
