import cv2 as cv
import numpy as np
from umucv.stream import Camera
from colorama import init, Fore
import datetime

# Area minima de un contorno para detectarlo como movimiento
min_size = 0


def DoNothing(value):
    pass


cam = Camera(debug=False)


def cap_img() -> (np.ndarray, np.ndarray):
    # Convertimos color y aplicamos un blur
    # Como nuestra camara no es perfecta aplicamos un blur para "Tapar" esas
    # inperfeciones.
    frame: np.ndarray = cam.frame.copy()
    frame = cv.resize(frame, (500, 500), interpolation=cv.INTER_AREA)
    gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    gray = cv.GaussianBlur(gray, (21, 21), 0)
    return gray, frame


def detect_movemente_contour(fondo, actual):
    """
    Detecta movimiento sobre un fondo y devuelve el contorno del los objetos con movimiento.
    Args:
        fondo: Imagen de fondo
        actual: Imagen actual

    Returns:
        contours :Devuelve los contornos del objeto

    """
    # calculamos la diferencia entre frames
    frameDelta = cv.absdiff(fondo, actual)
    # Aplicamos un threshold es decir si el pixel tiene valor menor que 25 lo ponemos negro
    # Si tiene mayor igual que 25 lo ponemos a blanco.
    thresh = cv.threshold(frameDelta, 25, 255, cv.THRESH_BINARY)[1]
    cv.imshow('threshold', thresh)
    cv.waitKey(1)
    # Hacemos los puntos blancos "mas gordos" para poder pillar mejores contornos
    #
    thresh = cv.dilate(thresh, None, iterations=2)
    # Solo necesitamos los contornos mas grandes
    contours, hierarchy = cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    return contours


def menu():
    print(f'{Fore.GREEN} Que quieres hacer ?')
    print(f'{Fore.BLUE} 1 - Selecionar Fondo')
    print(f'{Fore.BLUE} 2 - Empezar a detectar movieminto')
    print(f'{Fore.BLUE} 3 - Salir')
    return int(input())


def main():
    firstFrame = None
    while True:
        option = menu()
        if option == 1:
            print(f'{Fore.CYAN} Vamos a capturar el fondo')
            while firstFrame is None:
                gray, _ = cap_img()
                gray_copy_text = gray.copy()

                cv.putText(gray_copy_text, "Pulsa s para capturar", (10, 20),
                           cv.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 2)
                cv.imshow('fondo', gray_copy_text)
                key = cv.waitKey(1) & 0xFF
                if key == 115:
                    firstFrame = gray
                    cv.destroyWindow('fondo')

        elif option == 2:

            if firstFrame is None:
                print(f"{Fore.RED} Seleciona captura el fondo antes guapo")
                continue

            cv.namedWindow("Camara")
            cv.createTrackbar("Sensiviliad contornos", "Camara", 0, 5000, DoNothing)
            while True:
                estado_moviento = "ALL CLEAR"
                gray_actual, color_actual = cap_img()
                # Calculamos los contornos
                contours = detect_movemente_contour(firstFrame, gray_actual)

                # loop over the contours
                for c in contours:
                    # Si el contorno es muy pequeño lo ignoramos
                    if cv.contourArea(c) < cv.getTrackbarPos("Sensiviliad contornos", "Camara"):
                        continue
                    # compute the bounding box for the contour, draw it on the frame,
                    # and update the text
                    (x, y, w, h) = cv.boundingRect(c)
                    cv.rectangle(color_actual, (x, y), (x + w, y + h), (0, 255, 0), 2)
                    estado_moviento = "MOVIMIENTO DETECTADO"

                cv.putText(color_actual, f"Room Status: {estado_moviento}", (10, 20),
                           cv.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)

                cv.imshow("Camara", color_actual)
                key = cv.waitKey(1) & 0xFF
                if key == 113:
                    cv.destroyAllWindows()
                    break
        elif option == 3:
            break


if __name__ == '__main__':
    init(autoreset=True)
    main()
