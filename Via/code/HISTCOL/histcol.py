import cv2 as cv
import numpy as np
import math
from collections import deque
from umucv.stream import autoStream
from umucv.util import ROI, putText
from matplotlib import pyplot as plt
# selección de región de interés más cómoda que cv.selectROI


CANALES_COLOR = ('b', 'g', 'r')


def truncate(number, digits) -> float:
    stepper = 10.0 ** digits
    return math.trunc(stepper * number) / stepper


def calcular_histogramas(roi: np.ndarray) -> list:
    """
    Normalizamos y calculamos el histograma para cada color
    Args:
        roi: Imagen para calcular histograma

    Returns:
        histr_color:lista con los 3 histogramas normalizados
    """
    histr_color = []
    for i, col in enumerate(CANALES_COLOR):
        histr = cv.calcHist([roi], [i], None, [256], [0, 256])
        cv.normalize(histr, histr, alpha=0, beta=400, norm_type=cv.NORM_MINMAX)
        histr_color.append(histr)
    return histr_color


# TODO Mostrar el histograma con opencv no con matplotlib
def mostrar_histograma(roi: np.ndarray):
    """
    Mostramos los histogramas de los 3 canales de color en el mismo plot
    Args:
        roi: Imagen sobre la cual calculamos el histograma

    """
    histr_color = calcular_histogramas(roi)
    for i, col in enumerate(CANALES_COLOR):
        histr = histr_color[i]
        plt.plot(histr, color=col)
        plt.xlim([0, 256])
    plt.show()


def hconcat_resize_min(im_list, interpolation=cv.INTER_CUBIC):
    """
    Modifica las dimensiones de las imagenes para que tengan el mismo tamaño.
    Args:
        im_list:
        interpolation:

    Returns:
        im_list_resize: Lista con las imagenes con el mismo tamaño
    """
    h_min = min(im.shape[0] for im in im_list)
    im_list_resize = [cv.resize(im, (int(im.shape[1] * h_min / im.shape[0]), h_min), interpolation=interpolation)
                      for im in im_list]
    return cv.hconcat(im_list_resize)


def add_to_saved_roi(roi: np.ndarray, savedQueue: deque):
    """
    Añade la imagen del roi a la lista de rois guardados.
    Args:
        roi: roi para guardar
        savedQueue: Deque donde estan los rois

    Returns:

    """
    savedQueue.append(roi)
    model_pict = hconcat_resize_min(savedQueue)
    cv.imshow('models', model_pict)


def compare_models(roi_actual: np.ndarray, roi_modelo: np.ndarray):
    """
    Calcula el valor de semenjanza entre dos rois
    Args:
        roi_actual: roi actual
        roi_modelo: roi modelo

    Returns:
        valor semejanza
    """
    # Suma de diferencias absolutas en cada canal y quedarnos el máximo de los tres canales
    h1 = calcular_histogramas(roi_actual)
    h2 = calcular_histogramas(roi_modelo)
    resultado = []
    for i, col in enumerate(CANALES_COLOR):
        # Correlation mas cercano 1 mejor
        temp = cv.compareHist(h1[i], h2[i], 0)
        resultado.append(temp)
    # Elejimos el histograma que menos se parece
    return min(resultado)


def find_best_models(imagen_texto, roi_actual: np.ndarray, savedModels: deque):
    """
    Encuentra el modelo que mas se parece al roi_actual de los guardados
    y lo muestra por pantalla.
    Args:
        imagen_texto:
        roi_actual:
        savedModels:

    Returns:

    """
    if savedModels:
        results: [int, np.ndarray] = [(compare_models(roi_actual, modelox), modelox)
                                      for modelox in savedModels]
        menor_valor, mejor_modelo = results[0]
        texto = ""
        mayor_valor = -1
        for valor, modelo in results:
            valor_truncado = truncate(valor, 3)
            texto = f"{texto}  {valor_truncado}"
            if valor > mayor_valor:
                mayor_valor = valor
                mejor_modelo = modelo
        if mayor_valor <= 0.3:
            cv.imshow('Detectado', cv.imread("notfound.jpeg"))
        else:
            cv.imshow('Detectado', mejor_modelo)
        putText(imagen_texto, texto)
        # cv.putText(imagen_texto, texto, (0, 50), cv.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2, cv.LINE_AA)


def capture_roi(roi: ROI, frame, key, savedModels: deque):
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
        trozo = frame[y1:y2 + 1, x1:x2 + 1].copy()
        find_best_models(frame, trozo, savedModels)
        # Como matplotlib es bloqueante y no puedo hacer un thread
        # Ni tengo ganas de usar multiprocesing
        if key == ord('t'):
            mostrar_histograma(trozo)
        elif key == ord('c'):
            cv.imshow('trozo', trozo)
            # quitar el roi cuando se selecciona la región
            roi.roi = []
            add_to_saved_roi(trozo, savedModels)
        cv.rectangle(frame, (x1, y1), (x2, y2), color=(0, 255, 255), thickness=2)


def main():
    cv.namedWindow('input')
    cv.namedWindow('models')
    roi = ROI('input')
    savedROIS = deque()

    for key, frame in autoStream():
        # print(roi.roi)
        capture_roi(roi, frame, key, savedROIS)
        cv.imshow('input', frame)

    cv.destroyAllWindows()


if __name__ == '__main__':
    main()
