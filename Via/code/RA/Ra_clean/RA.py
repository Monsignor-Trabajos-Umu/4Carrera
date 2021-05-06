import json
import cv2 as cv
import cv2.aruco as aruco
import numpy as np
from umucv.stream import Camera
from umucv.htrans import htrans
from umucv.util import lineType

cube = np.array([
    [0, 0, 0],
    [1, 0, 0],
    [1, 1, 0],
    [0, 1, 0],
    [0, 0, 0],

    [0, 0, 1],
    [1, 0, 1],
    [1, 1, 1],
    [0, 1, 1],
    [0, 0, 1],

    [1, 0, 1],
    [1, 0, 0],
    [1, 1, 0],
    [1, 1, 1],
    [0, 1, 1],
    [0, 1, 0]
])
square = np.array(
    [[0, 0, 0],
     [0, 1, 0],
     [1, 1, 0],
     [1, 0, 0]])
# Area minima de un contorno para detectarlo como movimiento
min_size = 0
with open("calibrate.json") as f:
    loaded_dict = json.load(f)
    cam_matrix = np.array(loaded_dict.get('camera_matrix'))
    dist_coefs = np.array(loaded_dict.get('distortion_coefficients'))


# juntar columnas
def jc(*args):
    return np.hstack(args)


# mide el error de una transformación (p.ej. una cámara)
# rms = root mean squared error
# "reprojection error"
def rmsreproj(view, model, transf):
    err = view - htrans(transf, model)
    return np.sqrt(np.mean(err.flatten() ** 2))


def pose(K, rvec, tvec):
    rvec_goodShape = rvec.reshape(3, -1)
    tvec_goodShape = tvec.reshape(3, -1)
    R, _ = cv.Rodrigues(rvec_goodShape)
    M = K @ jc(R, tvec_goodShape)
    return M


contador = 0


def calculate_matrix(image):
    global contador
    imgen_auro = image.copy()
    # aruco data
    aruco_dict = aruco.Dictionary_get(aruco.DICT_ARUCO_ORIGINAL)
    parameters = aruco.DetectorParameters_create()

    height, width, channels = image.shape
    # blured = cv.medianBlur(image.copy(), (3, 3))
    gray = cv.cvtColor(imgen_auro, cv.COLOR_BGR2GRAY)
    corners, ids, rejectedImgPoints = aruco.detectMarkers(gray, aruco_dict, parameters=parameters)
    if ids is not None and corners is not None:
        for id, corner in zip(ids, corners):
            rvecs, tvecs, _objpoints = aruco.estimatePoseSingleMarkers(corner, 0.5, cam_matrix, dist_coefs)
            if rvecs.size != 0:
                print(id)
                # Calculamos la matriz
                rvec = rvecs[0]
                tvec = tvecs[0]
                M = pose(cam_matrix, rvec, tvec)
                # Caso base
                if id[0] == 0:
                    cv.drawContours(image, [htrans(M, cube).astype(int)], -1, (0, 128, 0), 3, lineType)
                    aruco.drawAxis(image, cam_matrix, dist_coefs, rvec, tvec, 0.1)
                if id[0] == 1:
                    contador += 1
                    # capturamos el color de un punto cerca del marcador para borrarlo
                    # dibujando un cuadrado encima
                    # hacemos que se mueva el cubo
                    cosa = cube * (0.5, 0.5, 0.75 + 0.5 * np.sin(contador / 100)) + (0.25, 0.25, 0)
                    cv.drawContours(image, [htrans(M, cosa).astype(int)], -1, (0, 128, 0), 3, cv.LINE_AA)
        aruco.drawDetectedMarkers(image, corners, ids)
    cv.imshow("cv frame", image)
    cv.waitKey(1)


cam = Camera(debug=False)


def main():
    while True:
        frame = cam.frame
        calculate_matrix(frame)


if __name__ == '__main__':
    main()
