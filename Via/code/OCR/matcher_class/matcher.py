from abc import ABC, abstractmethod
from typing import List
import os
import numpy as np
import cv2 as cv


def center(p):
    r, c = p.shape
    rs = np.outer(range(r), np.ones(c))
    cs = np.outer(np.ones(r), range(c))
    s = np.sum(p)
    my = np.sum(p * rs) / s
    mx = np.sum(p * cs) / s
    return mx, my


def boundingBox(c):
    (x1, y1), (x2, y2) = c.min(0), c.max(0)
    return (x1, y1), (x2, y2)


# La figura se escala a un tamaño 20x20
# respetando la proporción de tamaño
# El resultado se mete en una caja 28x28 de
# modo que la media quede en el centro
def adaptsize(x):
    h, w = x.shape
    s = max(h, w)
    h2 = (s - h) // 2
    w2 = (s - w) // 2
    y = x
    if w2 > 0:
        z1 = np.zeros([s, w2])
        z2 = np.zeros([s, s - w - w2])
        y = np.hstack([z1, x, z2])
    if h2 > 0:
        z1 = np.zeros([h2, s])
        z2 = np.zeros([s - h - h2, s])
        y = np.vstack([z1, x, z2])
    y = cv.resize(y, (20, 20)) / 255
    mx, my = center(y)
    H = np.array([[1., 0, 4 - (mx - 9.5)], [0, 1, 4 - (my - 9.5)]])
    return cv.warpAffine(y, H, (28, 28))


dilate = 0
threshold = 0


def set_dilate(val):
    global dilate
    dilate = val


class MatCher(ABC):

    def __init__(self):
        self.ok = None
        mnist = np.load("data/mnist.npz")
        self.xl, self.yl, self.xt, self.yt = [mnist[d] for d in ['xl', 'yl', 'xt', 'yt']]
        cv.namedWindow("threshold")
        cv.createTrackbar("iterations", "threshold", 0, 10, set_dilate)

    def prepara_img(self, digits: np.ndarray):
        """
        Normaliza los datos(img) para que se asemejen a los datos de mnist
        Args:
            digits: Imagen con los numeros.
            dilate: Numero de iteraciones que queremos que erode realize.

        Returns:
            ok: Lista con los numeros normalizados
        """
        # Aplicamos un filtro gausiano para reducir el ruido.
        # pasamos a gris
        digits = cv.cvtColor(digits, cv.COLOR_BGR2GRAY)
        # digits_blured = cv.medianBlur(digits, 5)
        digits_blured = cv.GaussianBlur(digits, (13, 13), cv.BORDER_CONSTANT)

        # ret, gt = cv.threshold(cv.cvtColor(digits_blured, cv.COLOR_RGB2GRAY), 0, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)
        gt = cv.adaptiveThreshold(digits_blured, 255, cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY, 11, 2)
        #_, gt = cv.threshold(gt, 0, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)

        gt_dilatado = cv.erode(gt, None, iterations=dilate)
        cv.imshow("threshold", gt_dilatado)
        contours, _ = cv.findContours(255 - gt_dilatado, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)[-2:]
        regions = [boundingBox(x.reshape(-1, 2)) for x in contours]

        # invertimos para seleccionar la tinta negra como objeto, y tener 0:papel blanco, 1: tinta.
        raw = [255 - gt_dilatado[y1:y2, x1:x2] for (x1, y1), (x2, y2) in regions if x2 - x1 > 13 and y2 - y1 > 13]
        ok: List[np.ndarray] = [adaptsize(x) for x in raw]
        self.ok = ok
        if ok:
            ok_img = -np.hstack([x.reshape(28, 28) for x in ok])

            # Opencv funciona con uint8 y np de 3 dimensiones
            ok_img = ok_img.astype(np.uint8)
            ok_img = cv.cvtColor(ok_img, cv.COLOR_GRAY2BGR)
            # cv.imshow("Numeros normalizados", ok_img)
        else:
            ok_img = None
            regions = None
        return ok_img, regions

    @abstractmethod
    def predict(self):
        pass
