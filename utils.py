import cv2
import numpy as np


def write_img(path, img):
    cv2.imwrite(path, img)

def open_img(img):
    img = cv2.imread(img).astype(np.uint8)
    img = cv2.cvtColor(img, cv2.COLOR_RGB2RGBA)
    return img

def imshow(name, img):
    cv2.imshow(name, img)
    cv2.waitKey(0)
