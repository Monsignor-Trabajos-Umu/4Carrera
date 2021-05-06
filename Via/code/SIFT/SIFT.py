import glob
import pickle
import threading
# Tecnicamente append y popleft son operaciones atomicas y len() tambien
from collections import deque
from typing import List, Tuple, Deque

import cv2 as cv
import numpy as np
from umucv.stream import Camera
from SIFT.Matching.default_Matcher import DefaultMatching
from SIFT.Matching.k_matcher import KmeansMaching

DEBUG = False

printLock = threading.Lock()
butteflies = {
    1: "Danaus plexippus",
    2: "Heliconius charitonius",
    3: "Heliconius erato",
    4: "Junonia coenia",
    5: "Lycaena phlaeas",
    6: "Nymphalis antiopa",
    7: "Papilio cresphontes",
    8: "Pieris rapae",
    9: "Vanessa atalanta",
    0: "Vanessa cardui"
}


def get_id(name_img):
    true_filename = name_img.split("\\")[1]
    id_butterfly = int(true_filename[2])
    return id_butterfly


def safe_print(text):
    with printLock:
        print(text)


def read_files(path) -> List[Tuple[str, np.ndarray]]:
    return [(file_name, cv.imread(file_name))
            for file_name in sorted(glob.glob(path))]


def read_files_select_p(path) -> List[Tuple[str, np.ndarray]]:
    """
    Lee las imagenes y guarda un 20% en imgToTest
    Args:
        path:

    Returns:

    """
    files = read_files(path)
    indices = np.random.permutation(len(files))
    p_division = int(len(indices) * 0.8)
    training_idx, test_idx = indices[:p_division], indices[p_division:]
    training = [files[i] for i in training_idx]
    test = [files[i] for i in test_idx]
    for file_name, img in test:
        true_filename = file_name.split("\\")[1]
        # print(f"Saving {true_filename}")
        cv.imwrite(f"./imgToTests/{true_filename}", img)
    return training


# Hacemos una statica para reducir "trabajo"
def mkAKAZE(minscale=0):
    # sift = cv.xfeatures2d.SIFT_create(**defautl_sift_config)
    akaze = cv.AKAZE_create()

    def fun(x):
        kp, desc = akaze.detectAndCompute(x, mask=None)
        if DEBUG:
            while True:
                flag = cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS
                cv.drawKeypoints(x, kp, x, color=(100, 150, 255), flags=flag)
                cv.imshow('SIFT', x)
                key = cv.waitKey(1) & 0xFF
                if key == 27:
                    cv.destroyAllWindows()
                    break
        sc = np.array([k.size for k in kp])
        return desc[sc > minscale].astype(np.uint8)

    return fun


def get_draw_sift(x: np.ndarray):
    akaze = cv.AKAZE_create()
    img = x.copy()
    kp, desc = akaze.detectAndCompute(img, mask=None)
    flag = cv.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS
    cv.drawKeypoints(img, kp, img, color=(100, 150, 255), flags=flag)
    return img


class Sift:
    def __init__(self, matching: str = None, folderpath=None, mk=None):
        """
        Iniciliazmos la clase SIFT
        Args:
            matching: Sin usar esta puesto para futura retro compatiblidad cuando
            empecie a usar otro tipo de matching
            folderpath:
            mk:
        """
        print("Inicilizando la clase Sift")
        if folderpath is None:
            folderpath = "./images/*.png"
        if mk is None:
            mk = mkAKAZE()
        self.get_desc = mk
        # Cargamos los keypoints de las imagenes en memoria
        self.all_points: List[Tuple[str, np.ndarray]] = self.__load_saved_sifts(folderpath)
        matching = DefaultMatching(mk, self.all_points)
        # Una vez que tenemos los puntos cargados
        self.matching = matching

    # Vamos usar threads para cargar las imagesnes
    def __thread_load_sift(self, imgs: Deque, allpoints: Deque):
        # file, cv.imread(file)
        # pop y append son thread safe
        while imgs:
            file_name, img = imgs.popleft()
            try:
                desc = self.get_desc(img)
                # No me fio de append una tupla en la misma linea
                tp: Tuple[str, np.ndarray] = (file_name, desc)
                allpoints.append(tp)
                safe_print(f"Img:{file_name} desc:{len(desc)}")
            except TypeError:
                safe_print(f"Img:{file_name} no tiene desc :(")

    def __load_saved_sifts(self, folderpath, filename=None) -> List[Tuple[str, np.ndarray]]:
        """
        Si los puntos ya estan calculados (existe el fichero) los cargamos con pickle
        sino los calculamos usando threads y la funcion __thread_load_sift posteriormente
        los guardamos en un fichero.
        Args:
            folderpath:
            filename:

        Returns:

        """
        if filename is None:
            filename = "allpoints.p"

        # Go me queria matar pero los try estan para usarse
        try:
            print("Cargando imagenes de memoria")
            allpoints = pickle.load(open("allpoints.p", "rb"))
            print("Imagenes cargadas")
        except FileNotFoundError:
            # O no ,no lo tenemos guardado
            print("Cargando imagenes desde ficheros")
            imgs: List[Tuple[str, np.ndarray]] = read_files_select_p(folderpath)
            # Pasamos de lista a deque para poder procesarlos con threads
            deque_imgs = deque(imgs)
            allpoints = deque()
            threads = []
            for _ in range(0, 5):
                t = threading.Thread(target=self.__thread_load_sift, args=(deque_imgs, allpoints))
                threads.append(t)
                t.start()
            # Esperamos los que los threads terminen
            [t.join() for t in threads]
            # Lo convertimos en una lista
            allpoints = list(allpoints)
            pickle.dump(allpoints, open(filename, "wb"))

        return allpoints

    def start(self):
        cam = Camera(debug=False)
        while True:
            frame = cam.frame
            # Mostramos el sift
            img = get_draw_sift(frame)
            cv.imshow("SIFT", img)
            key = cv.waitKey(1) & 0xFF
            if key == 27:
                cam.stop()
                cv.destroyAllWindows()
                exit()
            elif key == ord('s'):
                values: List[Tuple[int, str]] = self.matching.find(frame)
                puntos_comun, path_foto = values[0]
                # Imagen co
                img = cv.imread(path_foto)
                cv.imshow("Imagen mas parecida", img)
                cv.waitKey(1) & 0XFF
                lista_puntos_comun = [0] * 10

                for puntos_comun, path_foto in values:
                    # Añadimos un threshold
                    if puntos_comun >= 5:
                        id_butterfly = get_id(path_foto)
                        lista_puntos_comun[id_butterfly] += puntos_comun

                print(lista_puntos_comun)
                # Obtenemos el indice del mas parecido
                indice_mas_parecido: int = int(np.argsort(lista_puntos_comun)[-1])
                nombre_mariposa = butteflies[indice_mas_parecido]
                print(f"La mariposa deberia de ser {nombre_mariposa}")


if __name__ == '__main__':
    mkAkaze = mkAKAZE()
    # kmeans = KmeansMaching(mkAKAZE)
    sf = Sift(mk=mkAkaze, matching=None)
    sf.start()
