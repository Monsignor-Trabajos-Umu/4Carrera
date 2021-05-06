# K medias
from sklearn.cluster import KMeans
import joblib
#from sklearn.externals import joblib
import numpy as np
import pickle
from typing import List, Tuple


def simil(u, v):
    t = max(u.sum(), v.sum())
    return np.minimum(u, v).sum() / t


# Todo Hacer una clase padre para usar herencia y desacoplar codigo
class KmeansMaching:
    def __init__(self):
        self.get_desc = None
        self.codebook = None
        self.imagecodes = None

    def initialize(self, mkSift, all_points, imgs: List[Tuple[str, np.ndarray]]):
        """
        Iniciliza la clase corectamente
        :param mkSift:
        :param all_points:
        :param imgs:
        :return:
        """
        self.get_desc = mkSift
        temp = [t[1] for t in all_points]
        points = np.vstack(temp)
        # Cargamos el codebook
        try:
            self.codebook = joblib.load('codebook.pkl')
        except FileNotFoundError:
            # codebook = KMeans(n_clusters=500, random_state=0).fit(points[np.random.choice(len(points), 100000)])
            print("Haciendo k means ve a tomarte un cafe")
            self.codebook = KMeans(n_clusters=500, random_state=0).fit(points)
            joblib.dump(self.codebook, 'codebook.pkl')
            # Cargamos imagecodes
        try:
            self.imagecodes = pickle.load(open("imagecodes.p", "rb"))
        except FileNotFoundError:
            # Obteniendo el  centroide de  imagenes con su
            self.imagecodes = []
            print("Se ha quedado buen dia he ")
            for name, img in imgs:
                self.imagecodes.append((name, self.getcode(img)))
            pickle.dump(self.imagecodes, open("imagecodes.p", "wb"))

    def getcode(self, img):
        desc = self.get_desc(img)
        index = self.codebook.predict(desc)
        r = self.codebook.cluster_centers_[index] - desc
        d = np.sqrt((r ** 2).sum(axis=1))
        return np.histogram(index[d < 250], np.arange(self.codebook.n_clusters + 1))[0]

    def find(self, x):
        v = self.getcode(x)
        print(v.sum())
        dists = sorted([(simil(v, desc), file_name) for file_name, desc in self.imagecodes])[::-1]
        return dists
