# -*- coding: utf-8 -*-
''' PYNALTY.PY
    
    Realiza a análise de um imagem png no momento que a bola entra no gol em pênaltis
    Inputs: argv[1] = name_image.png
            argv[2] = number of frames from the kick until the ball enters the goal
            argv[3] = Frequency sample of video

    Clicar em para calibrar:
    Referencias do gol ('0 0    ; 0 2.44  ; 7.32 2.44  ;  7.32 0')
                      ('dir-inf  dir-sup   esq-sup       esq-inf')
      
    Na segunda figura clique livremente na imagem.
    
    Exemplo para rodar:  python pynalty.py 1389.png 15 29.79

    Paulo R. P. Santiago 15-06-2021
'''

#import os
import sys
import numpy as np
from numpy import linalg as LA
from numpy.linalg import inv
import matplotlib.pyplot as plt
from matplotlib.image import imread

#######################################################
######### Get image pixel x, y by ginput ##############
#######################################################
def getcoordspix(img, titleinstruc=None):
    if titleinstruc is None:
        titleinstruc = 'Mouse buttom LEFT: mark | RIGHT: unmark | MIDDLE: stop'
    
    plt.imshow(img)
    plt.title(titleinstruc)
    plt.xlabel('Mouse LEFT: mark | RIGHT: unmark | MIDDLE: stop')
    pxy = plt.ginput(n=50, timeout=0)
    pxy = np.matrix(pxy)
    
    return pxy

#######################################################
############### Function to DLT 2D ####################
#######################################################
def dlt2d(F, L):
    '''
        Create DLT2D
    '''
    F = np.matrix(F)
    L = np.matrix(L)
    Lt = L.transpose()
    C = Lt.flatten('F').transpose()
    
    m = np.size(F, 0)
    B = np.zeros((2*m, 8))
    for i in range(m):
        j = i + 1
        B[(2*j-1)-1,0] = F[i,0]
        B[(2*j-1)-1,1] = F[i,1]
        B[(2*j-1)-1,2] = 1
        B[(2*j-1)-1,6] = -F[i,0]*L[i,0]
        B[(2*j-1)-1,7] = -F[i,1]*L[i,0]
        B[(2*j)-1,3] = F[i,0]
        B[(2*j)-1,4] = F[i,1]
        B[(2*j)-1,5] = 1
        B[(2*j)-1,6] = -F[i,0]*L[i,1]
        B[(2*j)-1,7] = -F[i,1]*L[i,1]
    
    A = inv(B) * C
    return np.asarray(A)

#######################################################
############### Function to REC 2D#####################
#######################################################
def rec2d(A, cc2d):
    nlin = np.size(cc2d, 0)
    H = np.matrix(np.zeros((nlin, 2)))

    for k in range(nlin):
        cc2d1 = []
        cc2d2 = []
        x = cc2d[k, 0]
        y = cc2d[k, 1]
        cc2d1 = np.matrix([[A[0,0] -x * A[6,0], A[1,0] -x * A[7,0]], [A[3,0] -y * A[6,0], A[4,0]-y*A[7,0]]])
        cc2d2 = np.matrix([[x - A[2,0]], [y - A[5,0]]])
        G1 = inv(cc2d1) * cc2d2
        H[k, :] = G1.transpose()

    return np.asarray(H)

#######################################################
######### Funciton to Distance and Speed of ball ######
#######################################################
def distvelball_penalti(phorz, pvert, nframes, fpsvideo=None):

    if fpsvideo is None:
        fpsvideo = 30
    
    ballradius = 0.11 # radius of the ball in meters
    distpenalty = 11 # distance of the penalty or free kick
    midgoal = 3.66 # Middle of the goal
    phorz = phorz - midgoal
    ppenalty = np.asarray([0, 0, ballradius]) # position of ball in penalty

    # Condições para bola rasteira
    if pvert < ballradius:
       pvert = ballradius
       
    pgoal = np.asarray([phorz, distpenalty, pvert]) # location 3D ball in goal
    distball = LA.norm(pgoal - ppenalty) # distance of ball to 3D location in goal
    velball_ms = distball / nframes * fpsvideo
    velball_kmh = velball_ms * 3.6
    
    return distball, velball_ms, velball_kmh

#######################################################
############### MAIN FUNCTION #########################
#######################################################
def main():
    
    # Define global (real)  references
    matref = np.matrix('0 0; 0 2.44; 7.32 2.44; 7.32 0')
    nframes = int(sys.argv[2]) # number of frames from the kick until the ball enters the goal 
    fs = float(sys.argv[3]) # Frequency sample of video

    img = imread(sys.argv[1]) # read image png
    title2calib = 'Mark goal points: left-down; right-up; left-up'
    pixcal = getcoordspix(img, title2calib)
    plt.close()
    dlt8coefs = dlt2d(matref, pixcal)
    Href = rec2d(dlt8coefs, pixcal)
    print(f'\nCalibration points REC2D:\n{np.round(Href, 3)}')
    
    titlefree = 'Mark points free'
    cc2d = getcoordspix(img, titlefree)
    r2d = rec2d(dlt8coefs, cc2d)
    print(f'\n2D reconstruction points:\n{np.round(r2d, 3)}\n')

    distball, velball_ms, velball_kmh = distvelball_penalti(r2d[0,0], r2d[0,1], nframes, fpsvideo=fs)
    print(f'A distância percorrida pela bola até o gol foi de {distball:.3f} metros')
    print(f'A velocidade média do bola até o gol foi de {velball_ms:.3f} m/s ou {velball_kmh:.3f} km/h')
    return r2d, distball, velball_ms, velball_kmh

#######################################################
#####################  RUN MAIN CODE ##################
#######################################################
if __name__ == '__main__':
    main()
