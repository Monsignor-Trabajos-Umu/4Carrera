import numpy as np
import cv2   as cv
import numpy.linalg      as la

# para imprimir arrays con el número de decimales deseados
import contextlib


@contextlib.contextmanager
def printoptions(*args, **kwargs):
    original = np.get_printoptions()
    np.set_printoptions(*args, **kwargs)
    yield
    np.set_printoptions(**original)


def sharr(a, prec=3):
    with printoptions(precision=prec, suppress=True):
        print(a)


# crea un vector (array 1D), conveniente para hacer operaciones matemáticas
def vec(*argn):
    return np.array(argn)


# convierte un conjunto de puntos ordinarios (almacenados como filas de la matriz de entrada)
# en coordenas homogéneas (añadimos una columna de 1)
def homog(x):
    ax = np.array(x)
    uc = np.ones(ax.shape[:-1] + (1,))
    return np.append(ax, uc, axis=-1)


# convierte en coordenadas tradicionales
def inhomog(x):
    ax = np.array(x)
    return ax[..., :-1] / ax[..., [-1]]


# aplica una transformación homogénea h a un conjunto
# de puntos ordinarios, almacenados como filas
def htrans(h, x):
    return inhomog(homog(x) @ h.T)


pi = np.pi
degree = pi / 180

# para dibujar en 3D
from mpl_toolkits.mplot3d import Axes3D


# crea una matriz columna a partir de elementos o de un vector 1D
def col(*args):
    a = args[0]
    n = len(args)
    if n == 1 and type(a) == np.ndarray and len(a.shape) == 1:
        return a.reshape(len(a), 1)
    return np.array(args).reshape(n, 1)


# crea una matriz fila
def row(*args):
    return col(*args).T


# juntar columnas
def jc(*args):
    return np.hstack(args)


# juntar filas
def jr(*args):
    return np.vstack(args)


# dibujar una polilínea en 3D
def plot3(ax, c, color):
    x, y, z = c.T
    ax.plot(x, y, z, color)


# espacio nulo de una matriz, que sirve para obtener el centro
# de la cámara
def null1(M):
    u, s, vt = la.svd(M)
    return vt[-1, :]


# Descomposición RQ (que no suele estar en los paquetes numéricos)
# pero es fácil expresar en términos de la QR.
# Descompone una matriz como producto de triangular x rotación
# (que es justo la estructura de una matriz de cámara)
# M = K [R |t ]
# el trozo KR te lo da la descomposición rq
def rq(M):
    Q, R = la.qr(np.flipud(np.fliplr(M)).T)
    R = np.fliplr(np.flipud(R.T))
    Q = np.fliplr(np.flipud(Q.T))
    return R, Q


# Descomposición de la matriz de cámara como K,R,C
def sepcam(M):
    K, R = rq(M[:, :3])

    # para corregir los signos de f dentro de K
    s = np.diag(np.sign(np.diag(K)))

    K = K @ s  # pongo signos positivos en K
    K = K / K[2, 2]  # y hago que el elemento 3,3 sea 1

    R = s @ R  # cambio los signos igual a R para compensar
    R = R * np.sign(la.det(R))  # y hago que tenga det = 1 (bien orientado)

    # el centro de proyección es el espacio nulo de la matriz,
    # el único punto que la cámara "no puede ver", porque al proyectarlo
    # produce (0,0,0), que es un vector homogéneo "ilegal"
    C = inhomog(null1(M))

    return K, R, C


# Permite dibujar la posicion de la camara en un modelo 3d
# esquema en 3d de una cámara
def cameraOutline(M):
    K, R, C = sepcam(M)

    # formamos una transformación 3D para mover la cámara en el origen a la posición de M
    rt = jr(jc(R, -R @ col(C)),
            row(0, 0, 0, 1))

    sc = 0.3;
    x = 1;
    y = x;
    z = 0.99;

    ps = [x, 0, z,
          (-x), 0, z,
          0, 0, z,
          0, 1.3 * y, z,
          0, (-y), z,
          x, (-y), z,
          x, y, z,
          (-x), y, z,
          (-x), (-y), z,
          x, (-y), z,
          x, y, z,
          0, y, z,
          0, 0, z,
          0, 0, 0,
          1, 1, z,
          0, 0, 0,
          (-1), 1, z,
          0, 0, 0,
          (-1), (-1), z,
          0, 0, 0,
          (1), (-1), z,
          0, 0, 0,
          0, 0, (2 * x)]

    ps = np.array(ps).reshape(-1, 3)
    return htrans(la.inv(rt), sc * ps)


# mide el error de una transformación (p.ej. una cámara)
# rms = root mean squared error
# "reprojection error"
def rmsreproj(view, model, transf):
    err = view - htrans(transf, model)
    return np.sqrt(np.mean(err.flatten() ** 2))


def pose(K, image, model):
    ok, rvec, tvec = cv.solvePnP(model, image, K, (0, 0, 0, 0))
    if not ok:
        return 1e6, None
    R, _ = cv.Rodrigues(rvec)
    M = K @ jc(R, tvec)
    rms = rmsreproj(image, model, M)
    return rms, M
