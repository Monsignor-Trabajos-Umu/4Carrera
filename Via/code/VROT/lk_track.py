#!/usr/bin/env python

# Calculamos una lista de posiciones de cada trayectoria.
# Cada trayectoria tiene una longitud máxima.
# Se añaden nuevos puntos iniciales cada "detect_interval" frames.


import cv2 as cv
import numpy as np
from umucv.stream import autoStream, sourceArgs
from umucv.util import putText
import time

corners_params = dict(maxCorners=100,
                      qualityLevel=0.1,
                      minDistance=10,
                      blockSize=7)
lk_params = dict(winSize=(15, 15),
                 maxLevel=2,
                 criteria=(cv.TERM_CRITERIA_EPS | cv.TERM_CRITERIA_COUNT, 10, 0.03))


def putBetterText(img, string, orig=(5, 16), color=(255, 255, 255), div=2, scale=1, thickness=1):
    (x, y) = orig
    (w, h), b = cv.getTextSize(string, cv.FONT_HERSHEY_PLAIN, scale, thickness)
    if div > 1:
        img[y - h - 4:y + b, x - 3:x + w + 3] //= div
    line_height = h + 5
    x, y0 = (x, y)
    for i, line in enumerate(string.split("\n")):
        y = y0 + (i + 1) * line_height
        cv.putText(img, line, (x, y), cv.FONT_HERSHEY_PLAIN, scale, color, thickness, cv.LINE_AA)


def _get_movement(tracks: list):
    """
    Obtiene t_x y t_y que son "cuanto se ha movido el punto con respecto a su posicion anterior"
    Args:
        tracks (np.):

    Returns:
        t_x: Movimiento en el eje x
        t_y: Movimiento en el eje y

    """
    t_x, t_y = 0, 0
    if len(tracks):
        # Sacamos los ultimos 2 estados
        prev_pts = np.array([t[-2] for t in tracks])
        curr_pts = np.array([t[-1] for t in tracks])

        # Find transformation matrix
        """cos(θ) * s   -sin(θ) * s    t_x
           sin(θ) * s    cos(θ) * s    t_y """
        matriz, inliers = cv.estimateAffinePartial2D(prev_pts, curr_pts)
        # Sacamos el angulo del movimiento respento Y y X | A veces no se puede resolver -_-
        if matriz is not None:
            # theta_X = np.degrees(np.arctan2(-matriz[0, 1], matriz[0, 0]))
            # theta_Y = np.degrees(np.arctan2(-matriz[1, 1], matriz[1, 0]))
            t_x = int(matriz[0, 2])
            t_y = int(matriz[1, 2])

    return t_x, t_y


class Vroot:
    # Recordamos que los valores por defecto se crean en la primera lecturar de codico
    def __init__(self, track_len=20, detect_interval=5):

        self.corners_params = corners_params
        self.lk_params = lk_params
        self.track_len = track_len
        self.detect_interval = detect_interval

    def start(self):
        base_t_x, base_t_y, theta_X, theta_Y = 0, 0, 0, 0
        posicion_x = 0
        # tracks [[[p1_timepo0]

        tracks = []
        for n, (key, frame) in enumerate(autoStream()):

            if key == ord('r'):
                base_t_x, base_t_y = 0, 0

            gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            t0 = time.time()
            if len(tracks):
                # Sacamos los últimos puntos de cada trayectoria
                p0 = np.float32([t[-1] for t in tracks])
                # Calculamos la nueva posicion de los puntos p0
                p1, _, _ = cv.calcOpticalFlowPyrLK(prevgray, gray, p0, None, **self.lk_params)
                # calculamos la posicion en el pasado relativa a p1
                p0r, _, _ = cv.calcOpticalFlowPyrLK(gray, prevgray, p1, None, **self.lk_params)
                # el criterio para considerar bueno un punto siguiente es que si lo proyectamos
                # hacia el pasado, vuelva muy cerca del punto incial, es decir:
                # "back-tracking for match verification between frames"
                d = abs(p0 - p0r).reshape(-1, 2).max(axis=1)
                good = d < 1

                # assert p0r.shape == p1.shape
                # Elegimos los puntos buenos
                new_tracks = []
                for t, (x_new, y_new), ok in zip(tracks, p1.reshape(-1, 2), good):
                    if not ok:
                        continue
                    t.append([x_new, y_new])
                    if len(t) > self.track_len:
                        del t[0]
                    new_tracks.append(t)

                tracks = new_tracks
                # Calculamos el movimiento
                t_x, t_y = _get_movement(tracks)

                base_t_x += t_x
                base_t_y += t_y
                # dibujamos las trayectorias
                cv.polylines(frame, [np.int32(t) for t in tracks], isClosed=False, color=(0, 0, 255))
                for t in tracks:
                    x, y = np.int32(t[-1])
                    cv.circle(frame, (x, y), 2, (0, 0, 255), -1)

            t1 = time.time()

            # resetear el tracking
            if n % self.detect_interval == 0:

                # Creamos una máscara para indicar al detector de puntos nuevos las zona
                # permitida
                mask = np.zeros_like(gray)
                mask[:] = 255
                for x, y in [np.int32(t[-1]) for t in tracks]:
                    cv.circle(mask, (x, y), 5, 0, -1)
                # cv.imshow("mascara", mask)
                corners = cv.goodFeaturesToTrack(gray, mask=mask, **self.corners_params)
                if corners is not None:
                    for [(x, y)] in np.float32(corners):
                        tracks.append([[x, y]])
            putBetterText(frame,
                          # f'theta_X = {theta_X}\n'
                          # f'theta_Y = {theta_Y} \n'
                          f't_x = {base_t_x}\n'
                          f't_y = {base_t_y}\n'
                          f'{len(tracks)} corners, {(t1 - t0) * 1000:.0f}ms',
                          div=1, scale=2, color=(255, 255, 0))

            cv.imshow('input', frame)
            prevgray = gray


if __name__ == '__main__':
    vrot = Vroot()
    vrot.start()
