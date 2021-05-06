import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt
from umucv.stream import Camera, autoStream

t_value = 0

window_detection_name = 'dif'
low_H_name = 'threshold'


def set_threshold(val):
    global t_value
    t_value = val


cv.namedWindow(window_detection_name)
cv.createTrackbar(low_H_name, window_detection_name, 0, 255, set_threshold)


def chromea(img):
    # el paisaje ficticio donde queremos insertar el personaje
    dst = cv.imread("good.jfif")
    # nos aseguramos de que tenga el mismo tamaño que las imágenes anteriores
    r, c = img.shape
    result = cv.resize(dst, (c, r))

    # hay que convertir la mask a 3 canales para poder copiar rgb
    # mask3 = np.expand_dims(mask, axis=2)

    # np.copyto(result, obj, where=mask3)

    # imshow(result);
    # title('resultado');
    # cv.imwrite('chroma.png',cv.cvtColor(result,cv.COLOR_RGB2BGR))


def main():
    back = None
    for key, frame in autoStream():
        cv.imshow('input', frame)
        if key == ord('n'):
            back = frame.copy()
            cv.imshow("fondo", back)
            break

    # Ya hemos capturado el fondo
    cam = Camera()

    while True:
        frame = cam.frame.copy()
        cv.imshow('input', frame)
        key = cv.waitKey(1) & 0xFF
        if key == ord("q"):
            cv.destroyAllWindows()
            break
        # Calculamos las diferencias
        dbf = cv.absdiff(back, frame)
        if key == ord('p'):
            plt.hist(dbf.flatten(), 100)
            plt.show()

        # Aplicamos un threshold es decir si el pixel tiene valor menor que 25 lo ponemos a negro
        # Si tiene mayor igual que t_value lo saturamos.
        thresh: np.ndarray = cv.threshold(dbf, t_value, 255, cv.THRESH_BINARY)[1]
        cv.imshow(window_detection_name, thresh)
        mask = thresh.astype(bool)
        # el paisaje ficticio donde queremos insertar el personaje
        dst = cv.imread("good.jfif")
        # nos aseguramos de que tenga el mismo tamaño que las imágenes anteriores
        r, c, _ = mask.shape
        result = cv.resize(dst, (c, r))
        np.copyto(result, frame, where=mask)
        cv.imshow('result', result)


if __name__ == '__main__':
    main()
