import numpy as np
import cv2
import os




def hello(message):
    return message

def detect(image_file_path):
    print(image_file_path.decode())
    file_path = image_file_path.decode()

    #Ensures that the script can detect files that are in the same directory
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
   
    # Load face detection model
    face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
    # Load eye detection model
    eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')

    img = cv2.imread(file_path, cv2.IMREAD_COLOR)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)
    eyes = eye_cascade.detectMultiScale(gray, 1.3, 5)

    return [len(faces), len(eyes)]
