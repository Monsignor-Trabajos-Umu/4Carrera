import pygame, OpenGL, math, numpy
from pygame.locals import *
from OpenGL.GL import *
from OpenGL.WGL import *
from OpenGL.GLU import *
from PIL import Image
from ctypes import *

size = (800, 600)
pygame.display.set_mode(size, pygame.OPENGL | pygame.DOUBLEBUF)

img = Image.open('myPixelArt.bmp')
glEnable(GL_TEXTURE_2D)

hdc = windll.user32.GetDC(1)
print(hdc)
hglrc = wglCreateContext(hdc)
wglMakeCurrent(hdc, hglrc)
im = glGenTextures(1, img)
print(im)
