from OpenGL.GLUT import *
from OpenGL.GLU import *
import cv2 as cv
from PIL import Image
import numpy as np
from Ra_pruebas.objloader import *
import cv2.aruco as aruco
import json
from pyzbar.pyzbar import decode
from umucv.stream import Camera

"""
This is file loads and displays the 3d model on OpenGL screen.
"""

ref = (np.array(
    [[-1, 1], [1, 1],
     [1, -1], [-1, -1]]))
ref3d = np.hstack([ref, np.zeros([len(ref), 1])])


class OpenGLGlyphs:
    # constants
    INVERSE_MATRIX = np.array([[1.0, 1.0, 1.0, 1.0],
                               [-1.0, -1.0, -1.0, -1.0],
                               [-1.0, -1.0, -1.0, -1.0],
                               [1.0, 1.0, 1.0, 1.0]])

    def __init__(self):
        # initialise webcam and start thread
        self.cam = Camera(debug=False)

        # initialise shapes
        self.wolf = None
        self.file = None
        self.cnt = 1

        # Window name
        self.window_id = None
        # initialise texture
        self.texture_background = None

        print("getting data from file")

        self.cam_matrix, self.dist_coefs, rvecs, tvecs = self.get_cam_matrix("calibrate.json")

    def get_cam_matrix(self, file):
        with open(file) as f:
            loaded_dict = json.load(f)
            cam_matrix = np.array(loaded_dict.get('camera_matrix'))
            dist_coeff = np.array(loaded_dict.get('distortion_coefficients'))
            rvecs = np.array(loaded_dict.get('rvecs'))
            tvecs = np.array(loaded_dict.get('tvecs'))
            return cam_matrix, dist_coeff, rvecs, tvecs

    def _init_gl(self, Width, Height):
        glClearColor(0.0, 0.0, 0.0, 0.0)
        glClearDepth(1.0)
        glDepthFunc(GL_LESS)
        glEnable(GL_DEPTH_TEST)
        glShadeModel(GL_SMOOTH)
        glMatrixMode(GL_PROJECTION)
        glLoadIdentity()
        gluPerspective(37, 1.3, 0.1, 100.0)
        glMatrixMode(GL_MODELVIEW)

        glLightfv(GL_LIGHT0, GL_POSITION, (-40, 300, 200, 0.0))
        glLightfv(GL_LIGHT0, GL_AMBIENT, (0.2, 0.2, 0.2, 1.0))
        glLightfv(GL_LIGHT0, GL_DIFFUSE, (0.5, 0.5, 0.5, 1.0))
        glEnable(GL_LIGHT0)
        glEnable(GL_LIGHTING)
        glEnable(GL_COLOR_MATERIAL)

        # Load 3d object
        File = 'cloud.obj'
        self.wolf = OBJ(File, swapyz=True)

        # assign texture
        glEnable(GL_TEXTURE_2D)
        self.texture_background = glGenTextures(1)

    def _draw_scene(self):
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glLoadIdentity()

        # get image from webcam
        image = self.cam.frame
        # image = imutils.resize(image,width=640)

        # convert image to OpenGL texture format
        bg_image = cv.flip(image, 0)
        bg_image = Image.fromarray(bg_image)
        ix = bg_image.size[0]
        iy = bg_image.size[1]
        bg_image = bg_image.tobytes("raw", "BGRX", 0, -1)

        # create background texture
        glBindTexture(GL_TEXTURE_2D, self.texture_background)
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
        glTexImage2D(GL_TEXTURE_2D, 0, 3, ix, iy, 0, GL_RGBA, GL_UNSIGNED_BYTE, bg_image)

        # draw background
        glBindTexture(GL_TEXTURE_2D, self.texture_background)
        glPushMatrix()
        glTranslatef(0.0, 0.0, -10.0)
        self._draw_background()
        glPopMatrix()

        # handle glyphs
        self._calculate_matrix(image)

        glutSwapBuffers()

    def _calculate_corners(self, image):
        data, pts_reales = None, None
        for barcode in decode(image):
            data = barcode.data
            rect = barcode.rect
            points = barcode.polygon
            # Convertirmos el namedTupple a Numpy array para que opencv lo entienda.
            # print(points)
            pointsOpencv = []
            for point in points:
                pointArray = [point.x, point.y]
                pointsOpencv.append(pointArray)
            pts_reales = np.array(pointsOpencv, np.int32)
            pts = pts_reales.reshape((-1, 1, 2))
            cv.polylines(image, [pts], True, (255, 255, 0), 4)
            [cv.circle(image, (point.x, point.y), 6, [255, 0, 0], -1) for point in points]

        return data, pts_reales

    def _calculate_matrix(self, image):
        # aruco data
        aruco_dict = aruco.Dictionary_get(aruco.DICT_ARUCO_ORIGINAL)
        parameters = aruco.DetectorParameters_create()

        height, width, channels = image.shape
        # blured = cv.medianBlur(image.copy(), (3, 3))
        gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)
        corners, ids, rejectedImgPoints = aruco.detectMarkers(gray, aruco_dict, parameters=parameters)
        if ids is not None and corners is not None:
            rvecs, tvecs, _objpoints = aruco.estimatePoseSingleMarkers(corners, 0.5, self.cam_matrix,
                                                                       self.dist_coefs)
            aruco.drawDetectedMarkers(image, corners, ids)
            for zvec, tvec in zip(rvecs, tvecs):
                aruco.drawAxis(image, self.cam_matrix, self.dist_coefs, zvec, tvec, 0.1)

            # build view matrix
            # board = aruco.GridBoard_create(6,8,0.05,0.01,aruco_dict)
            # corners, ids, rejectedImgPoints,rec_idx = aruco.refineDetectedMarkers(gray,board,corners,ids,rejectedImgPoints)
            # ret,rvecs,tvecs = aruco.estimatePoseBoard(corners,ids,board,self.cam_matrix,self.dist_coefs)
            rmtx = cv.Rodrigues(rvecs)[0]

            view_matrix = np.array([[rmtx[0][0], rmtx[0][1], rmtx[0][2], tvecs[0][0][0]],
                                    [rmtx[1][0], rmtx[1][1], rmtx[1][2], tvecs[0][0][1]],
                                    [rmtx[2][0], rmtx[2][1], rmtx[2][2], tvecs[0][0][2]],
                                    [0.0, 0.0, 0.0, 1.0]])

            # view_matrix = np.array([[rmtx[0][0],rmtx[0][1],rmtx[0][2],tvecs[0]],
            #                         [rmtx[1][0],rmtx[1][1],rmtx[1][2],tvecs[1]],
            #                         [rmtx[2][0],rmtx[2][1],rmtx[2][2],tvecs[2]],
            #                         [0.0       ,0.0       ,0.0       ,1.0    ]])

            view_matrix = view_matrix * self.INVERSE_MATRIX

            view_matrix = np.transpose(view_matrix)

            # load view matrix and draw shape
            # glPushMatrix()
            # glLoadMatrixd(view_matrix)

            # glCallList(self.wolf.gl_list)

            # glPopMatrix()
        cv.imshow("cv frame", image)
        cv.waitKey(1)

    def _draw_background(self):
        # draw background
        glBegin(GL_QUADS)
        glTexCoord2f(0.0, 1.0)
        glVertex3f(-4.0, -3.0, 0.0)
        glTexCoord2f(1.0, 1.0)
        glVertex3f(4.0, -3.0, 0.0)
        glTexCoord2f(1.0, 0.0)
        glVertex3f(4.0, 3.0, 0.0)
        glTexCoord2f(0.0, 0.0)
        glVertex3f(-4.0, 3.0, 0.0)
        glEnd()

    def main(self):
        # setup and run OpenGL
        glutInit()
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)
        glutInitWindowSize(540, 960)
        glutInitWindowPosition(500, 400)
        self.window_id = glutCreateWindow(b"OpenGL Glyphs")
        glutDisplayFunc(self._draw_scene)
        glutIdleFunc(self._draw_scene)
        self._init_gl(640, 480)
        glutMainLoop()


# run( an instance of OpenGL Glyphs
print(bool(glGenFramebuffers))
glutInit()
openGLGlyphs = OpenGLGlyphs()
openGLGlyphs.main()
