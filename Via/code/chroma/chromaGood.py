import cv2 as cv
import numpy as np
from umucv.stream import autoStream, Camera
from colorama import init, Fore
import matplotlib.pyplot as plt

# Recuerda es BGR
lower_color = np.array([0, 0, 0])
upper_color = np.array([0, 0, 0])


def set_LR(value):
    global lower_color
    lower_color[2] = value


def set_UR(value):
    global upper_color
    upper_color[2] = value


def set_LG(value):
    global lower_color
    lower_color[1] = value


def set_UG(value):
    global upper_color
    upper_color[1] = value


def set_LB(value):
    global lower_color
    lower_color[0] = value


def set_UB(value):
    global upper_color
    upper_color[0] = value


def build_trackbars(cvScreenName: str):
    cv.createTrackbar("1-LR", cvScreenName, 0, 255, set_LR)
    cv.createTrackbar("2-UR", cvScreenName, 0, 255, set_UR)

    cv.createTrackbar("3-LG", cvScreenName, 0, 255, set_LG)
    cv.createTrackbar("4-UG", cvScreenName, 0, 255, set_UG)

    cv.createTrackbar("5-LB", cvScreenName, 0, 255, set_LB)
    cv.createTrackbar("6-UB", cvScreenName, 0, 255, set_UB)


CANALES_COLOR = ('b', 'g', 'r')


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


primera_pasada = True


def extraer_mascaras(back, actual):
    global primera_pasada
    key = cv.waitKey(1) & 0xFF
    # Calculamos las diferencias para saber mas menos por
    # donde cortar
    dbf = cv.absdiff(back, actual)
    if primera_pasada:
        # Creamos trackBarras
        cv.namedWindow("Filtro")
        build_trackbars("Filtro")
        mostrar_histograma(dbf)
        primera_pasada = False
    elif key == ord('p'):
        mostrar_histograma(dbf)

    # lower_color y upper_color los selecionamos basandonos en los histogramas histograma
    # Generamos una mascara
    mask_blanco_negro = cv.inRange(actual, lower_color, upper_color)

    # Ahora aplicamos la mascara a la imagen original para extraer el objeto
    mask_color = np.copy(actual)
    mask_color[mask_blanco_negro != 0] = [0, 0, 0]
    cv.imshow("Filtro", mask_blanco_negro)

    # Nuestra mascara necesita ser de 3 dimensiones y esta en 2
    # Podemos pasarla de gris a color
    mask_blanco_negro = cv.cvtColor(mask_blanco_negro, cv.COLOR_GRAY2BGR)
    # Nuestra mascara es un array siendo 0 -> false y 255 ->true
    mask_boolean: np.ndarray = mask_blanco_negro.astype(bool)
    return mask_boolean


def chromea(mascara: np.ndarray, objeto: np.ndarray, fondo: np.ndarray):
    """
    Realiza el chroma coloca el objeto sobre el fondo
    Args:
        mascara(np.ndarray): Mascara del objeto
        objeto (np.ndarray): Objeto que colocar
        fondo (np.ndarray): Fondo de la imagen

    Returns:
        chroma(np.ndarray):Chroma ya compuesto

    """
    # Cambiamos las dimensiones del fondo para que sean las misma que el objeto
    h, w, p = objeto.shape
    chroma = cv.resize(fondo, (w, h))

    # Como estamos filtrando un color selecionamos invertimos la mascara para selecionar
    # Todos los colores que no sean el de la mascara
    maskBoolan: np.ndarray = mascara.astype(bool)
    maskBoolan = np.invert(maskBoolan)

    np.copyto(chroma, objeto, where=maskBoolan)
    cv.imshow("output", chroma)

    return chroma


def main():
    # Capturamos el fondo
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
        mask_bw = extraer_mascaras(back, frame)

        # Leemos el fondo donde vamos a poner
        h, w, _ = mask_bw.shape
        #print(mask_bw.shape)
        background_image = cv.imread('../../img/CHROMA/good.jfif')
        background_image = cv.resize(background_image, (w, h))
        #print(background_image.shape)

        np.copyto(background_image, frame, where=mask_bw)
        cv.imshow("output", background_image)


if __name__ == '__main__':
    init(autoreset=True)
    main()
